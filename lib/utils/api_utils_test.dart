import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:konata/models/chats.dart';
import 'package:konata/models/qna_api_models.dart';
import 'package:konata/models/regist_api_models.dart';
import 'package:konata/utils/variable.dart';

///親ユーザー登録<br>
///parent_idが一致するリストを返す。
Future<RegistResponse> registParentTest(RegistUserInfo userInfo) async {
  try {
    String jsonString = await rootBundle.loadString('assets/login.json');
    final RegistResponse info = RegistResponse.fromJson(json.decode(jsonString));
    return info;
  } catch (error) {
    return RegistResponse(errorCode: errorCode);
  }
}

///親ユーザーログイン<br>
///parent_idが一致するリストを返す。
Future<RegistResponse> loginParentTest(RegistUserInfo userInfo, {bool errorTest = false}) async {
  try {
    String jsonString = await rootBundle.loadString(!errorTest ? 'assets/login.json' : 'assets/login_error.json');
    final RegistResponse info = RegistResponse.fromJson(json.decode(jsonString));
    return info;
  } catch (error) {
    return RegistResponse(errorCode: errorCode);
  }
}

///ユーザー照会<br>
///parent_idが一致するリストを返す。
Future<RegistResponse> referenceTest(RegistUserInfo userInfo) async {
  try {
    String jsonString = await rootBundle.loadString('assets/reference.json');
    final RegistResponse info = RegistResponse.fromJson(json.decode(jsonString));
    return info;
  } catch (error) {
    return RegistResponse(errorCode: errorCode);
  }
}

///子ユーザー登録<br>
///userInfo：登録データ
Future<RegistResponse> registChildTest(RegistUserInfo userInfo) async {
  try {
    String jsonString = await rootBundle.loadString('assets/regist_child.json');
    final RegistResponse info = RegistResponse.fromJson(json.decode(jsonString));
    return info;
  } catch (error) {
    return RegistResponse(errorCode: errorCode);
  }
}

///症状判定<br>
///問診APIについては未確定事項が多いので飽くまで暫定情報として<br>
///noSymtom = true：JSONの2つ目のデータ
Future<SymptomResponse> symptomTest(SymptomRequest request, {bool noSymtom = false}) async {
  try {
    String jsonString = await rootBundle.loadString('assets/symptom.json');
    final symtoms = json.decode(jsonString) as List<dynamic>;
    final SymptomResponse info =
        !noSymtom ? SymptomResponse.fromJson(symtoms[0]) : SymptomResponse.fromJson(symtoms[1]);
    return info;
  } catch (error) {
    return SymptomResponse(errorCode: errorCode);
  }
}

///問診開始
Future<QnAResponse> questionStartTest(QuestionRequest request) async {
  try {
    String jsonString = await rootBundle.loadString('assets/question_start.json');
    final QnAResponse info = QnAResponse.fromJson(json.decode(jsonString));
    return info;
  } catch (error) {
    return QnAResponse(errorCode: errorCode);
  }
}

///設問取得
Future<QnAResponse> questionGetTest(QuestionRequest request, {int questionIndex = 0}) async {
  try {
    String jsonString = await rootBundle.loadString('assets/question_get.json');
    final List<dynamic> qList = json.decode(jsonString);
    final QnAResponse info = QnAResponse.fromJson(qList[questionIndex]);
    return info;
  } catch (error) {
    return QnAResponse(errorCode: errorCode);
  }
}

///設問回答<br>
///次の設問が無くなるまで取得と回答を繰り返す。
Future<QnAResponse> questionAnsTest(AnswerRequest request, {int questionIndex = 0}) async {
  try {
    String jsonString = await rootBundle.loadString('assets/question_ans.json');

    final List<dynamic> qList = json.decode(jsonString);

    final QnAResponse info = QnAResponse.fromJson(qList[questionIndex]);
    return info;
  } catch (error) {
    return QnAResponse(errorCode: errorCode);
  }
}

///設問回答
Future<QnAResponseModel> questionAnserTest(QnARequestModel request, {int questionIndex = 0}) async {
  try {
    String jsonString = await rootBundle.loadString('assets/question_anser.json');

    final List<dynamic> qList = json.decode(jsonString);

    final QnAResponseModel info = QnAResponseModel.fromJson(qList[questionIndex]);
    return info;
  } catch (error) {
    return const QnAResponseModel(message: '', answer_txt: '', isError: true);
  }
}

///会話履歴照会
Future<List<HistoryModel>?> getHistoryTest() async {
  try {
    String jsonString = await rootBundle.loadString('assets/history.json');

    final history = json.decode(jsonString);
    final items = history['items'] as List<dynamic>;
    return items.map((e) => HistoryModel.fromJson(e)).toList();
  } catch (error) {
    return null;
  }
}
