// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element, unused_field, prefer_final_fields, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:konata/models/audio_player.dart';
import 'package:konata/models/chats.dart';
import 'package:konata/models/speech_wrapper.dart';
import 'package:konata/models/tts_setup.dart';
import 'package:konata/models/tts_wrapper.dart';
import 'package:konata/utils/api_utils.dart';
import 'package:konata/utils/mem_utils.dart';
import 'package:konata/utils/methods.dart';
import 'package:konata/utils/variable.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:progress_indicators/progress_indicators.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final SpeechWrapper speech = SpeechWrapper();
  final ScrollController _controller = ScrollController();
  final List<ChatMessage> messages = [];

  late bool isChatting = false; //会話中
  late bool isSending = false; //メッセージ送信中
  late bool isDialogShowing = false; //ダイアログ表示中

  String centerMessage = startMessage;
  String lastText = '';

  bool alreadyStarted = false;

  final String endWord = '(^^♪';
  final String chauWord = 'チャオ！';

  final AudioHelper audioHelper = AudioHelper();

  Timer? noQuestionTimer;
  late bool alreadyPing = false; //警告音鳴らすか

  Timer? qnaWaitTimer; //AI回答待ちタイマー
  TTSSetup ttsSetup = TTSSetup(); //音声発音の設定

  TTSWrapper tts = TTSWrapper();

  ThemaType currentThema = ThemaType.Health; //現在のテーマ,デフォルト：健康

  ///患者さんのまとめた質問を送信
  ///「送信」ボタンを押すとき
  Future<bool> sendQuestion(BuildContext context, {bool isFirstDisaterMsg = false}) async {
    await speech.stopListening(); //音声認識を一旦ストップ

    setState(() {
      isSending = true;
      lastText = '';
    });

    //AIの仮メッセージを表示（回答中...のイメージ）
    String question = messages.isNotEmpty ? messages.last.text : '';

    //災害テーマの場合、最初のメッセージ('こんにちは')を送信
    if (isFirstDisaterMsg) {
      question = firstDisaterMsg;
      setState(() {
        alreadyStarted = true;
      });
    }

    //空メッセージ表示
    ChatMessage tempMsg = ChatMessage(text: '', type: MessageType.right, isLoading: true);
    setState(() {
      if (messages.isNotEmpty && messages.last.isLoading) {
        messages.last = messages.last.copyWith(isLoading: false);
      }
      messages.insert(messages.length, tempMsg);
    });

    scrollDown();

    //質問送信
    final qna = await questionAnser(
      QnARequestModel(
        aivo_id: loginUser!.aivo_id!,
        timestamp: getCurrentTimeStamp(),
        speech_txt: question,
      ),
      currentThema,
    );

    //エラー発生の場合
    if (qna.isError) {
      showErrorSnackbar(qna.message);
      setState(() {
        messages.removeLast();
        isSending = false;
      });
      stopChat();

      return true;
    }

    final msg = (qna.answer_txt.contains('（健康）') || qna.answer_txt.contains('（災害）')) ? 'その他はいかがですか？' : qna.answer_txt;
    setState(() {
      messages.last = messages.last.copyWith(text: msg, isLoading: false, date: getCurretDate());
    });

    scrollDown();

    //play wav
    try {
      //音声出す
      if (ttsSetup.voiceOption == 'voice') {
        //音声あり
        await tts.speakAndWait(msg.replaceAll(endWord, '').replaceAll(chauWord, ''), finishSpeech: () {
          setState(() {
            isSending = false;
          });
        });
      } else {
        setState(() {
          isSending = false;
        });
      }

      await unmuteRingtone();
      audioHelper.open(wavPath);
      await audioHelper.playWav();
    } catch (e) {
      showErrorSnackbar('音声ファイルの再生に失敗しました。');
    }

    setState(() {
      isSending = false;
    });
    if (messages.isEmpty) {
      return true;
    }

    //質問監視、10秒間でなければ⇒鳴らす⇒チャオ！
    if (qna.answer_txt.isNotEmpty && !qna.answer_txt.trim().endsWith(endWord)) {
      startNoQuestionTimer();
    }

    //災害の終了メッセージ
    if (currentThema == ThemaType.Disaster && qna.answer_txt.endsWith(endWord)) {
      //チャオメッセージ
      await finishTransaction();
      backToHealthThema(); //テーマを健康に戻す
    }

    //報告Snackbar表示するかの判断
    if (mounted && messages.length < 3 || messages[messages.length - 3].text.trim() == chauWord) {
      if (await timeToShowHint()) {
        saveHintDateTime(DateTime.now());
        showFlushbar(context);
      }
    }

    return true;
  }

  void scrollDown() {
    if (!alreadyStarted) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    });
    //}
  }

  //認証結果の確立が低い⇒再認証
  reListen() async {
    await startListening();
    startWaitTimer(); //患者さんの質問待ちタイマーをスタート
  }

  ///エラー発生の場合⇒再開
  restartWhenError() async {
    if (isChatting) {
      await startListening();
    }
  }

  ///患者の音声の聞くを開始
  startListening() async {
    await muteRingtone();
    await Future.delayed(Duration(microseconds: 200));

    speech.startListening(afterRegconized, stopWaitTimer);
  }

  ///認証結果の処理
  ///新バージョン：送信ボタンクリックするまで、認証を繰り返し
  afterRegconized(String words, double confidence) async {
    await speech.stopListening();

    if (isChatting && !isSending) {
      if (words != '') {
        addQuestion(words);
      }
      reListen(); //繰り返し音声聞き取り
    }
  }

  ///会話終了
  stopChat() async {
    setState(() {
      isChatting = false;
      lastText = '';
    });
    await speech.stopListening();

    await unmuteRingtone();

    ///最後はまだ音声かけない場合、
    ///ラストメッセージ削除
    if (messages.last.isLoading) {
      setState(() {
        messages.removeLast();
      });
    }

    ///会話内容を保存
    await saveChatMessages(messages);
  }

  ///チャオ！メッセージ表示
  showChauoMessage(int index, {bool scroll = true}) {
    setState(() {
      if (messages.last.isLoading) {
        messages.last = messages.last.copyWith(isLoading: false);
      }
      messages.insert(
          index,
          ChatMessage(
            date: getCurretDate(),
            text: chauWord,
            type: MessageType.right,
          ));
    });
    if (scroll) {
      scrollDown();
    }
  }

  ///AIにチャオ！メッセージを送信
  sendChauoMessage() async {
    if (messages.isEmpty || messages.length == 1) return;
    final qna = await questionAnser(
      QnARequestModel(aivo_id: loginUser!.aivo_id!, timestamp: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()), speech_txt: chauWord),
      currentThema,
    );
    //エラー発生の場合
    if (qna.isError) {
      showErrorSnackbar(qna.message);
    }
    print('CHAUO!${qna.message}');
  }

  ///AI回答終了チェック
  isAINotFinish() {
    return (messages.last.type == MessageType.right && !messages.last.text.trim().endsWith(endWord));
  }

  get isChatFinish => (messages.isNotEmpty && (messages.last.text.trim().startsWith(chauWord) || messages.last.text.trim().startsWith(chauWord)));

  ///質問タイマーをスタート
  ///10秒間隔で質問チェック
  startNoQuestionTimer() {
    //すでにタイマーが動いている場合⇒何もしない
    if (noQuestionTimer != null && noQuestionTimer!.isActive) {
      return;
    }

    setState(() {
      alreadyPing = false;
    });
    final waitSecond = ((ttsSetup.aiWaitTime != null) ? ttsSetup.aiWaitTime! : 10); //一旦コメントアウト
    final apiWait = ((waitSecond + 1) * 1000).floor(); //デフォルト3秒 + 1秒
    noQuestionTimer = Timer.periodic(Duration(milliseconds: apiWait), (_) async {
      print('NO QUESTION TIMER TICK----------------------------');
      if (isChatting || isSending) {
        stopNoQuestionTimer();
        return;
      }

      //ダイアログ表示中→何もしない
      if (isDialogShowing) {
        return;
      }

      //10秒経過しても質問がない場合⇒音鳴らす
      if (isAINotFinish()) {
        ///音声を鳴らしてない⇒鳴らす
        if (!alreadyPing) {
          setState(() {
            alreadyPing = true;
          });

          try {
            audioHelper.open(neWavPath);
            await audioHelper.playWav();
          } catch (e) {
            showErrorSnackbar('音声ファイルの再生に失敗しました。');
          }
        }

        ///音声を鳴らしている⇒チャオ！を表示
        else {
          //「チャオ！」表示
          stopNoQuestionTimer();
          if (!noNeedAddChau) {
            await finishTransaction();
            backToHealthThema(); //テーマを健康に戻す
          }
        }
      }
    });
  }

  ///会話終了処理
  finishTransaction() async {
    showChauoMessage(messages.length);
    await sendChauoMessage();
    await saveChatMessages(messages);
  }

  bool get noNeedAddChau => messages.isEmpty || messages.length == 1 || messages.last.text.trim().startsWith(chauWord);

  // チャオ！を強制的に追加できるかのチェック
  bool get canForceAddChau => messages.isNotEmpty && !messages.last.text.trim().startsWith(chauWord);

  ///メモボタンクリック⇒強制「チャオ！」送信
  forceAddChau() async {
    if (canForceAddChau) {
      await finishTransaction();
    }
  }

  ///回答なしのタイマーをストップ
  stopNoQuestionTimer() {
    if (noQuestionTimer != null) {
      noQuestionTimer!.cancel();
      noQuestionTimer = null;
    }
  }

  ///患者さんの質問待ちタイマーをストップ
  stopWaitTimer() {
    if (qnaWaitTimer != null) {
      print('STOP WAIT TIMER');
      qnaWaitTimer!.cancel();
      qnaWaitTimer = null;
    }
  }

  ///患者さんの質問待ちタイマーをスタート
  ///5秒間隔で質問チェック
  ///質問がない場合⇒今の内容で質問を送信
  ///送信ボタンクリックと同じ処理を行う
  startWaitTimer() {
    stopWaitTimer();
    final second = (((ttsSetup.waitTime != null) ? ttsSetup.waitTime! : 3) * 1000 + 1000).floor(); //デフォルト3秒 + 1秒
    qnaWaitTimer = Timer.periodic(Duration(milliseconds: second), (timer) async {
      print('WAIT TIMER TICK: ${timer.tick}');
      await tabProcess(context);
    });
  }

  ///会話の開始メッセージ
  ///患者の音声を待つ形のメッセージ
  addLeftWaitMessage() {
    setState(() {
      if (messages.isNotEmpty && messages.last.isLoading) {
        messages.last = messages.last.copyWith(isLoading: false);
      }

      messages.insert(
        messages.length,
        ChatMessage(text: '', type: MessageType.left, isLoading: true),
      );
    });
    scrollDown();
  }

  ///左メッセージ更新（患者の音声）
  updateLastLeftMessage() {
    ChatMessage last = messages.last;
    setState(() {
      messages.last = last.copyWith(text: lastText, isLoading: true, date: getCurretDate(), time: getCurrentTime());
    });
    scrollDown();
  }

  ///聞き取り繰り返し、取れた分を追加
  addQuestion(words) {
    if (words != null && words != '') {
      setState(() {
        lastText += '${lastText != '' ? '、' : ''}$words';
      });
      updateLastLeftMessage();
    }
  }

  ///患者さんのメッセージの時間
  String getMessageDate(String messageDate, int index) {
    String date = '';
    if (messageDate == '') return '';
    if (index == 0 || messages[index - 1].date != messageDate) {
      date = messageDate;
      if (date == getCurretDate()) return '今日';
      final vals = date.split('年');
      if (vals[0] == DateTime.now().year.toString()) {
        date = vals[1];
      }
    }
    return date;
  }

  ///アイコンクリックイベントの処理
  tabProcess(BuildContext context) async {
    stopNoQuestionTimer(); //質問タイマーをストップ
    stopWaitTimer(); //患者さんの質問待ちタイマーをストップ
    if (isSending) {
      await speech.stopListening(); //予想外認識を防ぐため、一旦ストップ
      return; //メッセージ送信中->処理しない
    }

    ///会話中<br>
    ///メッセージない場合⇒強制終了<br>
    ///メッセージある場合⇒送信
    if (isChatting) {
      var needRestartTimer = true;

      ///メッセージあり⇒送信
      if (lastText != '') {
        needRestartTimer = false;
        await sendQuestion(context);
      }
      await stopChat();

      ///チャットストップですが、前回の音声認識が取れないかつ会話終了してない場合
      ///タイマー再開
      if (needRestartTimer && !isChatFinish) {
        startNoQuestionTimer();
      }
    } else {
      await startChat();
    }
  }

  ///チャット開始
  startChat() async {
    setState(() {
      isChatting = true;
    });

    ///患者さんの仮メッセージを表示（質問中...のイメージ）
    addLeftWaitMessage();

    ///認証結果
    await startListening();

    setState(() {
      alreadyStarted = true;
    });
  }

  //AIコンテンツ報告
  void _showReportDialog(BuildContext context, String contentText) {
    final TextEditingController controller = TextEditingController();
    String selectedReason = '攻撃';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('メッセージを報告'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("メッセージを報告理由？"),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedReason,
              onChanged: (value) => selectedReason = value ?? selectedReason,
              items: ['攻撃', 'スパム', '不正確', 'その他'].map((reason) => DropdownMenuItem(value: reason, child: Text(reason))).toList(),
            ),
            TextField(
              controller: controller,
              decoration: InputDecoration(hintText: '他の理由'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('キャンセル'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // 報告API連携
              //print('Reported $selectedReason / ${controller.text}');
              await reportMessage(loginUser!.aivo_id!, contentText, selectedReason, controller.text);
              if (mounted) {
                showNormalSnackbar('フィードバックありがとうございます。');
              }
            },
            child: Text('報告'),
          ),
        ],
      ),
    );
  }

  ///災害テーマの履歴画面へ遷移
  backToHealthThema() {
    setState(() {
      currentThema = ThemaType.Health; //テーマを健康に戻す
    });
  }

  ///テーマ変更
  changeThema(ThemaType thema) async {
    final lastThema = currentThema; //現在のテーマを保存
    //健康から災害テーマに変更
    if (currentThema == ThemaType.Health && thema == ThemaType.Disaster) {
      if (messages.isNotEmpty && !isChatFinish) {
        await finishTransaction(); //健康トランザクションを終了
      }
    }

    setState(() {
      currentThema = thema;
    });
    //（災害）テーマ開始→APIコール→レスポンスはAIの質問として表示
    if ((lastThema == ThemaType.Health && currentThema == ThemaType.Disaster) || isChatFinish) {
      await sendQuestion(context, isFirstDisaterMsg: true);
    }
  }

  @override
  void initState() {
    super.initState();
    tts.initializeTts();
    speech.initSpeech(() async {
      await restartWhenError();
      final setup = await getTTSSetupFromMemory();
      if (setup != null) {
        setState(() {
          ttsSetup = setup;
        });
      }
    });

    ///メモリからメッセージを読み込む
    loadChatMessages().then((value) {
      if (value.isEmpty) return;
      value = value.where((element) => element.text.isNotEmpty).toList();
      setState(() {
        messages.addAll(value);
        alreadyStarted = true;
      });
      Future.delayed(Duration(seconds: 1), () {
        scrollDown();
        _controller.jumpTo(_controller.position.maxScrollExtent);
      });
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    speech.dispose();
    stopNoQuestionTimer();
    audioHelper.dispose();
    tts.dispose();
    saveChatMessages(messages);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() {
    saveChatMessages(messages);
    return super.didPopRoute();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          backgroundColor: bgColor, //Colors.brown,
          leading: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: InkWell(
                  onTap: () async {
                    //showSnackbar('実装中');
                    //showErrorDialog(context, '実装中', () {}, panaraDialogType: PanaraDialogType.normal);
                    if (isChatting) return;
                    stopNoQuestionTimer();
                    final result = await Get.toNamed('/ttssetting');
                    if (result is bool && result) {
                      tts.dispose();
                      tts = TTSWrapper();
                      tts.initializeTts();
                      final setup = await tts.setVoiceGender();
                      setState(() {
                        ttsSetup = setup;
                      });
                    }
                  },
                  child: Icon(
                    Icons.settings_outlined,
                    color: Color.fromARGB(255, 136, 143, 143),
                    size: 50,
                  ) //Image.asset('assets/images/handshake_new.png', height: 50),
                  )),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: InkWell(
              onTap: () async {
                await gotoThemeHistory(context);
                //Get.toNamed('/history');
              },
              child: Image.asset('assets/images/history.png', height: 50),
            ),
          ),
          actions: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  stopNoQuestionTimer();
                  Get.toNamed('/barcode');
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.qr_code_2,
                    color: Colors.black, //Color.fromARGB(255, 114, 191, 197),
                    size: 40,
                  ),
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Container(
            color: bgColor, //Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: alreadyStarted
                      ? ListView.builder(
                          cacheExtent: 99999,
                          controller: _controller,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            String date = getMessageDate(message.date, index);

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                              child: Column(
                                children: [
                                  if (date != '')
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 141, 156, 182),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(
                                        date,
                                        style: TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  Row(
                                    mainAxisAlignment: message.type == MessageType.left ? MainAxisAlignment.end : MainAxisAlignment.end,
                                    //crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (message.type == MessageType.right)
                                        const Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: CircleAvatar(
                                            radius: 22,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: AssetImage('assets/images/kidou.png'),
                                          ),
                                        ),
                                      const SizedBox(width: 10),

                                      ///右メッセージ（音声認証）の時間
                                      if (message.type == MessageType.left)
                                        Container(
                                          width: 40,
                                          padding: const EdgeInsets.only(top: 20),
                                          child: Text(
                                            message.time,
                                            style: const TextStyle(fontSize: 9),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),

                                      ///メインメッセージ
                                      Expanded(
                                        child: GestureDetector(
                                          onLongPress: () {
                                            if (message.type == MessageType.right) {
                                              _showReportDialog(context, message.text);
                                            } else {
                                              return;
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: message.type == MessageType.right ? Colors.white : Color.fromARGB(255, 0, 204, 202),
                                              borderRadius: BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.shade300,
                                                  blurRadius: 3.0,
                                                  offset: const Offset(0, 2.0),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            margin: message.type == MessageType.left ? EdgeInsets.only(left: 5) : EdgeInsets.only(right: 20),
                                            child: message.isLoading && isChatting
                                                ? messageAndJumpText(message.text)
                                                : Text(message.text, style: TextStyle(fontSize: 16, decoration: TextDecoration.none)),
                                          ),
                                        ),
                                      ),

                                      ///右アイコン

                                      message.type == MessageType.left ? const SizedBox(width: 20, height: 0) : const SizedBox(width: 0, height: 0),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            centerMessage,
                            style: chatTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: InkWell(
                        onTap: () {
                          showErrorDialog(context, '実装中', () {}, panaraDialogType: PanaraDialogType.normal);
                        },
                        child: Image.asset('assets/images/camera.png', height: 60),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await tabProcess(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5, top: 5),
                        width: 70,
                        height: 70,
                        decoration: shadowBorder,
                        child: Icon(
                          getIconData(),
                          size: 60,
                          color: getIconColor(), //Color.fromARGB(255, 114, 191, 197),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: InkWell(
                        onTap: () {
                          showChangeThema(context);
                        },
                        child: Icon(
                          Icons.notifications_active_outlined,
                          color: Color.fromARGB(255, 136, 143, 143),
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData getIconData() {
    return isChatting ? (!isSending ? Icons.pause : Icons.mic) : Icons.mic_none;
  }

  Color getIconColor() {
    return isSending ? Colors.grey : bgColor2; //Color.fromARGB(255, 114, 191, 197);
  }

  Widget messageAndJumpText(String text) {
    if (text == '') {
      return JumpingText('・・・', style: const TextStyle(fontSize: 20.0, color: Colors.black, decoration: TextDecoration.none));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: TextStyle(fontSize: 16, decoration: TextDecoration.none)),
        JumpingText('・・・', style: const TextStyle(fontSize: 20.0, color: Colors.black, decoration: TextDecoration.none))
      ],
    );
  }

  ///テーマ変更ダイアログ
  void showChangeThema(BuildContext context) {
    if (isChatting || isSending) return;
    stopNoQuestionTimer();
    setState(() {
      isDialogShowing = true;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 15.0),
                InkWell(
                  onTap: () async {
                    //Navigator.of(context).pop();
                    showErrorDialog(context, '実装中', () {
                      Navigator.of(context).pop();
                      setState(() {
                        isDialogShowing = false;
                      });
                      if (!isChatFinish) {
                        startNoQuestionTimer();
                      }
                    }, panaraDialogType: PanaraDialogType.normal);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BtnDecoration(Color.fromARGB(255, 230, 247, 255)),
                    child: Center(
                      child: Text(
                        '（お薬）',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 0, 120, 170),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();
                    setState(() {
                      isDialogShowing = false;
                    });
                    //（災害）テーマ選択
                    await changeThema(ThemaType.Disaster);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BtnDecoration(Color.fromARGB(255, 255, 240, 230)),
                    child: Center(
                      child: Text(
                        '（災害）',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 170, 80, 0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      isDialogShowing = false;
                    });
                    if (!isChatFinish) {
                      startNoQuestionTimer();
                    }
                  },
                  child: circleBtn,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///テーマ履歴画面へ移動
  gotoThemeHistory(BuildContext context) async {
    if (isChatting) return;
    stopNoQuestionTimer();

    await forceAddChau(); //強制チャオ！を送信

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 10.0)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 15.0),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.toNamed('/history', arguments: {'thema': ThemaType.Health});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BtnDecoration(Color.fromARGB(255, 193, 240, 207)),
                    child: Center(
                      child: Text(
                        '（健康）',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 97, 189, 109)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.toNamed('/history', arguments: {'thema': ThemaType.Disaster});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BtnDecoration(Color.fromARGB(255, 255, 240, 230)),
                    child: Center(
                      child: Text(
                        '（災害）',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 170, 80, 0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: circleBtn,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
