import 'dart:async';
import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:konata/utils/mem_utils.dart';
import 'package:konata/utils/methods.dart';

enum VoiceGender { male, female }

List<String> maleVoices = ['ja-jp-x-jad-local', 'ja-jp-x-jad-network', 'ja-jp-x-jac-local', 'ja-jp-x-jac-network'];
List<String> femaleVoices = ['ja-JP-language', 'ja-jp-x-jab-local', 'ja-jp-x-jab-network', 'ja-jp-x-htm-local', 'ja-jp-x-htm-network'];

class TTSWrapper {
  final FlutterTts tts = FlutterTts();

  void initializeTts() async {
    await tts.setLanguage('ja-JP');
    await tts.setSpeechRate(0.5); //0.0~1.0, 小さいほどゆっくり
    await tts.setPitch(1.0); //0.5~2.0, 1.0がデフォルト
    await tts.awaitSpeakCompletion(false); // 発話の完了まで待機。
    await tts.awaitSynthCompletion(true); // ファイルの合成まで待機。

    await setVoiceGender();
  }

  setVoiceGender() async {
    final ttsSetup = await getTTSSetupFromMemory();
    if (ttsSetup != null) {
      if (ttsSetup.voiceOption == 'voice') {
        await setVoiceByGender(ttsSetup.voiceGender == "male" ? VoiceGender.male : VoiceGender.female);
      }
    }
    return ttsSetup;
  }

  ///発音を完了まで待つメソッド
  speakAndWait(String text, {Function? finishSpeech}) async {
    final Completer<void> completer = Completer();

    tts.setCompletionHandler(() {
      if (!completer.isCompleted) {
        completer.complete();
        if (finishSpeech != null) {
          finishSpeech();
        }
      }
    });

    tts.setCancelHandler(() {
      if (!completer.isCompleted) {
        completer.complete(); // Still complete to avoid hanging
      }
      if (finishSpeech != null) {
        finishSpeech();
      }
    });

    await tts.speak(text);
    await completer.future; // Wait until speech is finished
  }

  Future<void> setVoiceByGender(VoiceGender gender) async {
    List<Map<Object?, Object?>> voices = (await tts.getVoices).where((voice) => voice is Map).cast<Map<Object?, Object?>>().toList();
    if (Platform.isAndroid && voices.isEmpty) {
      showErrorSnackbar('音声が取得できませんでした。TTSの設定を確認してください。');
      return;
    }

    /*
    if (Platform.isIOS) {
      List<String> voiceNames = [];
      for (var voice in voices) {
        if (voice['locale'].toString().startsWith('ja-JP')) {
          voiceNames.add(voice['name'].toString());
        }
      }
      showSnackbar('iOSの音声は設定できません。利用可能な音声: ${voiceNames.join(', ')}', sec: 20);
    }
    */

    Map<String, String>? selectedVoice;

    //男性
    if (gender == VoiceGender.male) {
      if (Platform.isAndroid) {
        for (var voiceName in maleVoices) {
          final hitVoice = voices.where((Map voice) => voice['name'] == voiceName).firstOrNull;
          if (hitVoice != null) {
            selectedVoice = {
              'name': hitVoice['name'].toString(),
              'locale': hitVoice['locale'].toString(),
            };
            break;
          }
        }
      } else {
        selectedVoice = {
          'name': 'Otoya',
          //'name': 'com.apple.ttsbundle.siri_male_ja-JP_compact',
          'locale': 'ja-JP',
        };
      }
    }
    //女性
    else {
      if (Platform.isAndroid) {
        for (var voiceName in femaleVoices) {
          final hitVoice = voices.where((voice) => voice['name'] == voiceName).firstOrNull;
          if (hitVoice != null) {
            selectedVoice = {
              'name': hitVoice['name'].toString(),
              'locale': hitVoice['locale'].toString(),
            };
            break;
          }
        }
      } else {
        selectedVoice = {
          'name': 'Kyoko',
          //'name': 'com.apple.ttsbundle.siri_female_ja-JP_compact',
          'locale': 'ja-JP',
        };
      }
    }

    if (selectedVoice != null) {
      //showErrorSnackbar('音声を設定しました: ${selectedVoice['name']}');
      await tts.setLanguage('ja-JP');
      await tts.setVoice(selectedVoice);
    } else {
      showErrorSnackbar('音声が見つかりませんでした。');
    }
    /*
    await tts.setVoice({
      'name': 'ja-JP-language',
      'locale': 'ja-JP',
    });
    */
  }

  /// Dispose method to release resources
  void dispose() {
    tts.stop();
  }
}
