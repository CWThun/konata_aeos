// ignore_for_file: avoid_single_cascade_in_expression_statements

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:konata/models/qna.dart';
import 'package:konata/models/user.dart';
import 'package:konata/utils/mem_utils.dart';
import 'package:konata/utils/variable.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

///質問Widget生成
Widget buildQuestionWidget(String title) {
  final textList = splitString(title);

  //boldあり⇒Richテキスト
  if (textList.firstWhereOrNull((element) => element.isBold) != null) {
    return RichText(text: TextSpan(style: textStyle, children: buildTextSpan(textList)), textAlign: TextAlign.center);
  }
  return Text(title, style: textStyle, textAlign: TextAlign.center);
}

List<InlineSpan> buildTextSpan(List<StyleText> styleList) {
  final List<InlineSpan> ret = [];

  styleList.asMap().forEach((key, element) {
    if (element.isBold) {
      ret.add(TextSpan(text: element.text, style: const TextStyle(fontWeight: FontWeight.bold)));
    } else {
      ret.add(TextSpan(text: element.text));
    }
  });

  return ret;
}

///文字列からboldがある場合⇒Richテキスト
///ない場合⇒テキスト
List<StyleText> splitString(String input) {
  final RegExp regex = RegExp(r"<b>(.*?)<\/b>");
  final List<RegExpMatch> matches = regex.allMatches(input).toList();

  final List<StyleText> styleList = [];

  int currentIndex = 0;

  for (final match in matches) {
    // Add substring between the previous match and the current match to group2
    //group2.add(input.substring(currentIndex, match.start));
    // Add substring enclosed within <b> and </b> tags to group1
    //group1.add(input.substring(match.start, match.end));

    //regular
    styleList.add(StyleText(input.substring(currentIndex, match.start), false));

    //bold
    styleList.add(StyleText(input.substring(match.start, match.end).replaceFirst('<b>', '').replaceFirst('</b>', ''), true));

    currentIndex = match.end;
  }

  // Add the remaining part of the input string to group2
  //group2.add(input.substring(currentIndex));

  //regular
  styleList.add(StyleText(input.substring(currentIndex), false));

  return styleList;
}

///タブレットかどうか（android用）
bool checkIfTablet(BuildContext context) {
  ///android
  if (Platform.isAndroid) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    if (shortestSide > 600) {
      return true;
    }
  }
  return false;
}

///ios用：iPadかどうか
Future<bool> checkIpad() async {
  if (Platform.isIOS) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo info = await deviceInfo.iosInfo;
    if (info.model.toLowerCase().contains("ipad")) {
      return true;
    }
  }
  return false;
}

///画面共有外枠<br>
///body: メイン画面<br>
///width:フルスクリーン
Widget screenBody(Widget body, double width, {PreferredSizeWidget? appbar, Widget? bottomBar}) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: appbar,
    body: SafeArea(
      child: Container(
        width: width,
        decoration: const BoxDecoration(
            //border: Border.all(color: const Color.fromARGB(255, 255, 204, 204), width: 8),
            //borderRadius: BorderRadius.circular(20.0),
            ),
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: body,
      ),
    ),
    bottomNavigationBar: bottomBar,
  );
}

Widget loadingWidget(bool isVisible) {
  return Visibility(
    visible: isVisible,
    child: Center(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
  );
}

///テキストWidget生成<br>
Widget buildTextBox(TextEditingController textController, OutlineInputBorder enableBorder, IconData icon, String hintText, {bool isPass = false, double? horizontalPadding}) {
  return Container(
    height: 45,
    padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 40.0),
    child: TextField(
      obscureText: isPass,
      controller: textController,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        prefixIcon: Icon(icon),
        enabledBorder: enableBorder,
        focusedBorder: focusBorder,
      ),
    ),
  );
}

///緑ボタン生成
Widget buildBlueButton(String text, Function clickFunc, {double? horizontalMargin, double? width}) {
  return Container(
    margin: EdgeInsets.only(left: horizontalMargin ?? 80.0, right: horizontalMargin ?? 80.0, bottom: 20.0),
    width: width ?? double.infinity,
    height: 45.0,
    child: ElevatedButton(
      style: ButtonStyle(backgroundColor: buttonColor, elevation: MaterialStateProperty.all(2)),
      onPressed: () async {
        await clickFunc();
      },
      child: Text(text, style: buttonTextStyle),
    ),
  );
}

///白いボタン生成
Widget buildWhiteButton(String text, Function clickFunc, {double? horizontalMargin, double? width}) {
  return Container(
    margin: EdgeInsets.only(left: horizontalMargin ?? 80.0, right: horizontalMargin ?? 80.0, bottom: 20.0),
    width: width ?? double.infinity,
    height: 45.0,
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(2),
      ),
      onPressed: () {
        clickFunc();
      },
      child: Text(text, style: buttonBlackTextStyle),
    ),
  );
}

///メニューボタン生成メソッド
Widget buildButton(String text, bool isIpad, double screenWidth, Function clickFunc, {Color? bgColor, Color? color}) {
  return SizedBox(
    height: !isIpad ? 45 : 50,
    width: !isIpad ? screenWidth - 80 : screenWidth - 320,
    child: ElevatedButton(
      onPressed: () {
        clickFunc();
      },
      style: btnStyle(bgColor: bgColor, color: color),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}

ButtonStyle btnStyle({Color? bgColor, Color? color}) {
  return ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    foregroundColor: color ?? Colors.black,
    backgroundColor: bgColor ?? Colors.white,
    shape: const RoundedRectangleBorder(
      side: BorderSide(
        color: Color.fromARGB(255, 72, 163, 72),
        width: 1,
      ),
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    ),
  );
}

///親idに紐づくユーザー情報取得
Future<List<User>> loadUser(String parentId) async {
  String jsonString = await rootBundle.loadString('assets/user.json');
  var jsonDecode = json.decode(jsonString) as List;
  List<User> ret = [];
  for (var data in jsonDecode) {
    final id = data["parentId"] as String;
    if (id == parentId) {
      final users = data["users"] as List;
      for (var userData in users) {
        ret.add(User.fromJson(userData));
      }
      return ret;
    }
  }
  return ret;
}

///SHA256変換<br>
///pass:パスワード
String sha256Encrypt(String pass) {
  final passInBytes = utf8.encode(pass);
  final passConvert = sha256.convert(passInBytes);
  return passConvert.toString();
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, height - 20);
    path.quadraticBezierTo(width / 5, height / 2.5, width / 2, height - 30);
    path.quadraticBezierTo(width * 3 / 4, height, width, height - 30);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Future<bool> isEmulator() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    // Android
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.isPhysicalDevice == false || androidInfo.model.contains("sdk") || androidInfo.hardware == "goldfish" || androidInfo.hardware == "ranchu";
  } else if (Platform.isIOS) {
    // iOS
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.isPhysicalDevice == false;
  }

  // Default to false (real device)
  return false;
}

showErrorDialog(BuildContext context, String message, Function? func, {PanaraDialogType? panaraDialogType}) async {
  await await PanaraInfoDialog.show(
    context,
    message: message,
    buttonText: 'OK',
    onTapDismiss: () {
      try {
        Navigator.of(context).pop();
      } catch (e) {}

      if (func != null) func();
    },
    panaraDialogType: panaraDialogType ?? PanaraDialogType.error,
  );
}

muteRingtone() async {
  /*
  try {
    const platform = MethodChannel('com.aeos.konata/audio_manager');
    await platform.invokeMethod('muteRingtone');
  } on PlatformException catch (e) {
    print("Failed to mute ringtone: '${e.message}'.");
  }
  */
}

unmuteRingtone() async {
  /*
  try {
    const platform = MethodChannel('com.aeos.konata/audio_manager');
    await platform.invokeMethod('unmuteRingtone');
  } on PlatformException catch (e) {
    print("Failed to unmute ringtone: '${e.message}'.");
  }
  */
}

// Function to show error Snackbar
void showErrorSnackbar(String errorMessage) {
  errorMessage = errorMessage.replaceAll('Exception:', '');
  if (scaffoldMessengerKey.currentState != null) {
    scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

void showSnackbar(String msg, {int sec = 2}) {
  if (scaffoldMessengerKey.currentState != null) {
    scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0)),
        backgroundColor: const Color.fromARGB(255, 0, 204, 102),
        duration: Duration(seconds: sec),
      ),
    );
  }
}

void showNormalSnackbar(String msg, {int sec = 4}) {
  if (scaffoldMessengerKey.currentState != null) {
    scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: sec),
      ),
    );
  }
}

///ヒント表示適切かをチェック
Future<bool> timeToShowHint() async {
  final lastHintTime = await getSavedHintDateTime();
  if (lastHintTime == null) {
    return true;
  }

  final now = DateTime.now();
  final diff = now.difference(lastHintTime).inMinutes;
  //print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA:$diff,now:$now,lastHintTime:$lastHintTime");
  if (diff > 5) {
    return true;
  }
  return false;
}

///Flushbarを表示するメソッド
void showFlushbar(BuildContext context) {
  Flushbar(
    message: "💡 長押しでAIメッセージが報告できます",
    icon: Icon(
      Icons.info_outline,
      size: 28.0,
      color: Colors.blue[300],
    ),
    duration: const Duration(seconds: 6),
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    backgroundColor: Colors.black87,
    flushbarPosition: FlushbarPosition.TOP,
  )..show(context);
}

/// Returns the current date formatted in Japanese locale.
///
/// The date is formatted as "MMM d(E)", where:
/// - MMM is the abbreviated month name.
/// - d is the day of the month.
/// - E is the short day of the week.
String getCurretDate() {
  initializeDateFormatting('ja');
  final now = DateTime.now();
  return "${DateFormat.yMMMd('ja').format(now)}(${DateFormat.E('ja').format(now).toString()})";
}

/// Returns the current time formatted as "HH:mm".
String getCurrentTime() {
  final now = DateTime.now();
  return DateFormat('HH:mm').format(now);
}

///発音を完了まで待つメソッド
Future<void> speakAndWait(String text, FlutterTts tts) async {
  final Completer<void> completer = Completer();

  tts.setCompletionHandler(() {
    print("Speech completed");
    if (!completer.isCompleted) completer.complete();
  });

  await tts.speak(text);
  await completer.future; // Wait until speech is finished
}

///現在のタイムスタンプを取得
String getCurrentTimeStamp() {
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
}
