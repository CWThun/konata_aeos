// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:konata/bindings/add_user_binding.dart';
import 'package:konata/bindings/history_binding.dart';
import 'package:konata/bindings/list_user_binding.dart';
import 'package:konata/bindings/login_binding.dart';
import 'package:konata/bindings/menu_binding.dart';
import 'package:konata/bindings/regist_binding.dart';
import 'package:konata/screens/add_user_screen.dart';
import 'package:konata/screens/barcode_scanner.dart';
import 'package:konata/screens/chat_screen.dart';
import 'package:konata/screens/history_screen.dart';
import 'package:konata/screens/login_screen.dart';
import 'package:konata/screens/menu_screen.dart';
import 'package:konata/screens/regist_screen.dart';
import 'package:konata/screens/tts_setting_screen.dart';
import 'package:konata/screens/user_screen.dart';
import 'package:konata/utils/mem_utils.dart';
import 'package:konata/utils/methods.dart';
import 'package:konata/utils/variable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getLoginUserFromMemory();
  if (Platform.isIOS) {
    isIpad = await checkIpad();
  }

  isOnEmulator = await isEmulator(); //Emulatorチェック

  print(getCurretDate());

  ///Ringtone mute
  /*
  bool? isGranted = await PermissionHandler.permissionsGranted;
  if (isGranted != null && !isGranted) {    
    await PermissionHandler.openDoNotDisturbSetting();
  }
  await SoundMode.setSoundMode(RingerModeStatus.silent);
  */

  //await muteRingtone();

  await getCenterMessage(); //チャット画面のセンタメッセージ

  // フレームワークエラーをキャッチ
  FlutterError.onError = (FlutterErrorDetails details) {
    print(details.exceptionAsString());
    showErrorSnackbar(details.exceptionAsString());
    if (details.stack != null) {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  //非同期エラーをキャッチ
  runZonedGuarded(
    () {
      runApp(const MyApp());
    },
    (error, stackTrace) {
      print(error.toString());
      showErrorSnackbar(error.toString());
      // Log the error to a service, e.g., Firebase Crashlytics or Sentry
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      isIpad = checkIfTablet(context);
    }

    return GetMaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'Konata',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen(), binding: LoginBinding()),
        GetPage(name: '/menu', page: () => const MenuScreen(), binding: MenuBinding()),
        GetPage(name: '/barcode', page: () => const BarcodeScanner()),
        GetPage(name: '/user', page: () => const UserScreen(), binding: ListUserBinding()),
        GetPage(name: '/adduser', page: () => const AddUserScreen(), binding: AddUserBinding()),
        GetPage(name: '/regist', page: () => const RegistScreen(), binding: RegistBinding()),
        GetPage(name: '/chat', page: () => const ChatScreen()),
        GetPage(name: '/history', page: () => const HistoryScreen(), binding: HistoryBinding()),
        GetPage(name: '/ttssetting', page: () => const TtsSettingScreen()),
      ],
      initialRoute: !isAlreadyLogin() ? '/login' : '/chat',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en"),
        const Locale("ja", "JP"),
      ],
    );
  }
}
