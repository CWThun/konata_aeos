// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:konata/models/chats.dart';
import 'package:konata/models/regist_api_models.dart';
import 'package:konata/models/tts_setup.dart';
import 'package:konata/utils/variable.dart';
import 'package:shared_preferences/shared_preferences.dart';

const USER_MEM_KEY = "USER_MEM";
const CHAT_MEM_KEY = "CHAT_MEM";
const LAST_HINT_TIME_KEY = "LAST_HINT_TIME";
const TTS_SETUP = "TTS_SETUP"; //音声発音の設定
RegistUserInfo? loginUser;

///メモリにログインユーザー存在か
getLoginUserFromMemory() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(USER_MEM_KEY)) {
    final userStr = prefs.getString(USER_MEM_KEY);
    loginUser = RegistUserInfo.fromJson(json.decode(userStr!));
  }
}

saveLoginUserToMemory(RegistUserInfo user) async {
  loginUser = user;
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(USER_MEM_KEY, json.encode(user.toJson()));
}

///すでにログインされているか
bool isAlreadyLogin() {
  return loginUser != null;
}

/// 中央メッセージを取得
/// 最初にmessage1を、次回以降はmessage2を返す
///
getCenterMessage() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('CENTER_MESSAGE')) {
    startMessage = message2;
  } else {
    startMessage = message1;
    prefs.setString('CENTER_MESSAGE', message2);
  }
}

/// 会話履歴を保存
Future<void> saveChatMessages(List<ChatMessage> messages) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(CHAT_MEM_KEY, json.encode(messages.map((e) => e.toJson()).toList()));
}

/// 会話履歴をshared preferencesから取得
Future<List<ChatMessage>> loadChatMessages() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(CHAT_MEM_KEY)) {
    final chatStr = prefs.getString(CHAT_MEM_KEY);
    final messages = (json.decode(chatStr!) as List).map((e) => ChatMessage.fromJson(e)).toList();
    return messages;
  }
  return [];
}

///ヒント表示時刻を保存
Future<void> saveHintDateTime(DateTime time) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(LAST_HINT_TIME_KEY, time.toIso8601String());
}

///ヒント表示時刻を取得
Future<DateTime?> getSavedHintDateTime() async {
  final prefs = await SharedPreferences.getInstance();
  final timeString = prefs.getString(LAST_HINT_TIME_KEY);
  if (timeString == null) return null;
  return DateTime.tryParse(timeString);
}

///音声発音の設定を取得
Future<TTSSetup?> getTTSSetupFromMemory() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(TTS_SETUP)) {
    final ttsStr = prefs.getString(TTS_SETUP);
    return TTSSetup.fromJson(json.decode(ttsStr!));
  }
  return null;
}

///音声発音の設定を保存
saveTTSSetupToMemory(TTSSetup setup) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(TTS_SETUP, json.encode(setup.toJson()));
}
