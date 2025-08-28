// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:konata/models/regist_api_models.dart';
import 'package:konata/utils/methods.dart';

const TextStyle textStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black);
const TextStyle boldStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);

final ButtonStyle flatButtonStyle = ElevatedButton.styleFrom(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  foregroundColor: Colors.black,
  backgroundColor: Colors.white,
  shape: const RoundedRectangleBorder(
    side: BorderSide(
      color: Color.fromARGB(255, 72, 163, 72),
      width: 1,
    ),
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  ),
);

const chatTextStyle = TextStyle(
  fontSize: 18,
  decoration: TextDecoration.none,
  color: Color.fromARGB(255, 114, 191, 197),
  fontWeight: FontWeight.bold,
  shadows: <Shadow>[
    Shadow(
      color: Colors.black,
      blurRadius: 2.0,
      offset: Offset(2.0, 2.0),
    ),
  ],
);

const bgColor2 = Color.fromRGBO(0, 204, 202, 1);
const curveColor = Color.fromARGB(255, 127, 82, 91);
const blueColor = Color.fromARGB(255, 0, 146, 255);

final textBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: const BorderSide(color: Colors.grey));
final focusBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: const BorderSide(color: Colors.lightBlue));
final errorBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: const BorderSide(color: Colors.red));
final buttonColor = MaterialStateProperty.all(blueColor);
const buttonTextStyle = TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold);
const buttonBlackTextStyle = TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold);
const bigTextStyle = TextStyle(fontSize: 18, color: blueColor, fontWeight: FontWeight.bold);
const buttonMargin = EdgeInsets.only(left: 80.0, right: 80.0, bottom: 20.0);
const buttonMarginTablet = EdgeInsets.only(left: 160.0, right: 160.0, bottom: 20.0);
const copyRight = Text('Konata', style: TextStyle(color: blueColor, fontWeight: FontWeight.bold));
const bgColor = Color.fromARGB(255, 218, 237, 239);
final shadowBorder = BoxDecoration(
  shape: BoxShape.circle,
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.grey.shade200,
      offset: Offset(-2, -2),
      blurRadius: 5,
      spreadRadius: 2,
    ),
    // Dark shadow on the bottom-right
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      offset: Offset(2, 2),
      blurRadius: 5,
      spreadRadius: 2,
    ),
  ],
);

final clipArt = ClipPath(
  clipper: CurvedClipper(),
  child: Container(
    color: curveColor,
    height: 100,
  ),
);

///ヘッダのAvatar
const avatar = CircleAvatar(
  foregroundImage: AssetImage('assets/images/symtom2.jpg'),
  backgroundColor: blueColor,
  radius: 55.0,
);

const registAvatar = CircleAvatar(
  radius: 47.0,
  backgroundColor: Colors.black12,
  child: CircleAvatar(
    foregroundImage: AssetImage('assets/images/symtom.jpg'),
    radius: 46.0,
  ),
);

///フッターのCopyright
const copyRightWidget = Positioned(
  bottom: 2,
  left: 0,
  right: 0,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      /*
      CircleAvatar(
        radius: 15.0,
        backgroundColor: Colors.grey,
        child: CircleAvatar(foregroundImage: AssetImage('assets/images/kidou.png'), radius: 14.0),
      ),
      SizedBox(width: 5),
      copyRight,
      */
    ],
  ),
);

///ポップアップの閉じるボタン
///丸いボタン
final circleBtn = Container(
  padding: const EdgeInsets.all(10),
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.grey.shade200,
    boxShadow: [
      // Top-left shadow (lighter)
      const BoxShadow(
        color: Colors.white,
        offset: Offset(-1, -1),
        blurRadius: 2,
        spreadRadius: 1,
      ),
      // Bottom-right shadow (darker)
      BoxShadow(
        color: Colors.grey.shade300,
        offset: const Offset(1, 1),
        blurRadius: 2,
        spreadRadius: 1,
      ),
    ],
  ),
  child: Icon(Icons.close, color: Colors.grey.shade700),
);

BtnDecoration(Color color) => BoxDecoration(
      color: color, //const Color.fromARGB(255, 255, 240, 230),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        // Top-left shadow (lighter)
        const BoxShadow(
          color: Colors.white,
          offset: Offset(-1, -1),
          blurRadius: 2,
          spreadRadius: 1,
        ),
        // Bottom-right shadow (darker)
        BoxShadow(
          color: Colors.grey.shade300,
          offset: Offset(1, 1),
          blurRadius: 2,
          spreadRadius: 1,
        ),
      ],
    );

const FIX_URL = 'https://yahoo.co.jp';

const endText = '承知しました。\nお疲れ様でした。';

const isTest = false;

//QnA用
late String session_id; //セッションID
late RegistUserInfo selectUser; //診断人（メニュー選択）
bool isIpad = false; //iPad or Tablet
bool isOnEmulator = false; //Emulator or not

//error
const String errorMessage = '予期しないエラーが発生しました';
const int successCode = 200;
const int errorCode = 500;

String startMessage = '';
String message1 = 'こんにちは\nマイクをクリックしてから\nお話してして下さい';
String message2 = 'こんにちは\nマイクをクリックしてから\nお話してして下さい';
//String message2 = 'マイククリックして\n会話しましょう';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

String wavPath = 'assets/sounds/ding.wav';
String neWavPath = 'assets/sounds/nenene.mp3';

///------------------------thema----------------------------
enum ThemaType {
  Health,
  Disaster,
}

const Map<ThemaType, String> themaTypeMap = {
  ThemaType.Health: '健康',
  ThemaType.Disaster: '災害',
};

String getThemaTypeName(ThemaType type) {
  return themaTypeMap[type] ?? '不明';
}

String firstDisaterMsg = 'こんにちは';
