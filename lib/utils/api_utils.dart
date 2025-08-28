// ignore_for_file: constant_identifier_names, avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:konata/models/chats.dart';
import 'package:konata/models/qna_api_models.dart';
import 'package:konata/models/regist_api_models.dart';
import 'package:konata/utils/api_paths.dart';
import 'package:konata/utils/api_utils_test.dart';
import 'package:konata/utils/variable.dart';

///親ユーザー登録
///アプリダウンロード後のユーザー登録時に呼び出される。
///処理成功時は利用者DBのユーザーID（2種）を返す。
///エラー発生されたら、isError=trueで返却
Future<RegistResponse> registParent(RegistUserInfo userInfo) async {
  final body = {
    'mail': userInfo.mail,
    'pass_txt': userInfo.pass_txt,
    /*
    'aeos_parameter': userInfo.aeos_parameter,
    'nickname': 'あなた',
    'sex': userInfo.sex,
    'birthmonth': userInfo.birthmonth,
    */
  };
  try {
    if (isTest) return await registParentTest(userInfo);
    var url = Uri.https(ApiPaths.api_root, ApiPaths.api_regist_parent);
    var response = await http.post(url, body: body);
    if (response.statusCode == successCode) {
      final RegistResponse info = RegistResponse.fromJson(jsonDecode(response.body));
      return info;
    } else {
      var ret = RegistResponse(errorCode: response.statusCode, errorMessage: errorMessage);
      if (response.statusCode != errorCode) {
        ret.errorMessage = jsonDecode(response.body)['error'];
      }
      return ret;
    }
  } catch (error) {
    return RegistResponse(errorCode: errorCode, errorMessage: errorMessage);
  }
}

///親ユーザーログイン
///アプリ再起動やログアウト後に開いた際に呼び出される。
///処理成功時は利用者DBのユーザーID（2種）を返す。
Future<RegistResponse> loginParent(RegistUserInfo userInfo, {bool errorTest = false}) async {
  final body = {
    'mail': userInfo.mail,
    'pass_txt': userInfo.pass_txt,
  };
  try {
    if (isTest) return await loginParentTest(userInfo, errorTest: errorTest);
    var url = Uri.https(ApiPaths.api_root, ApiPaths.api_login_parent);
    var response = await http.post(url, body: body);
    if (response.statusCode == successCode) {
      return RegistResponse.fromJson(jsonDecode(response.body));
    }
    return RegistResponse(errorCode: errorCode, errorMessage: jsonDecode(response.body)['error']);
  } catch (error) {
    print(error);
    return RegistResponse(errorCode: errorCode, errorMessage: errorMessage);
  }
}

///ユーザー照会
///parent_idが一致するリストを返す。
Future<RegistResponse> reference(RegistUserInfo userInfo) async {
  final body = {
    'aivo_id': userInfo.aivo_id,
    'parent_id': userInfo.parent_id,
  };
  try {
    ///テスト
    if (isTest) return await referenceTest(userInfo);
    var url = Uri.https(ApiPaths.api_root, ApiPaths.api_reference);
    var response = await http.post(url, body: body);
    final RegistResponse info = RegistResponse.fromJson(jsonDecode(response.body));
    return info;
  } catch (error) {
    return RegistResponse(errorCode: errorCode);
  }
}

///子ユーザー登録
Future<RegistResponse> registChild(RegistUserInfo userInfo) async {
  final body = {
    'aivo_id': userInfo.aivo_id,
    'parent_id': userInfo.parent_id,
    'aeos_parameter': userInfo.aeos_parameter,
    'nickname': userInfo.nickname,
    'sex': userInfo.sex,
    'birthmonth': userInfo.birthmonth,
  };
  try {
    if (isTest) return await registChildTest(userInfo);
    var url = Uri.https(ApiPaths.api_root, ApiPaths.api_regist_child);
    var response = await http.post(url, body: body);
    final RegistResponse info = RegistResponse.fromJson(jsonDecode(response.body));
    return info;
  } catch (error) {
    return RegistResponse(errorCode: errorCode);
  }
}

///医療機関登録
///画面遷移の都合、既に追記済みのaeos_parameter値が入力される事はない想定だが、エラー処理は実装しておく。
///既に値が含まれる場合は登録エラー（メッセージにその旨記載）を返す。
Future<RegistResponse> registClinic(RegistUserInfo userInfo) async {
  final body = {
    'aivo_id': userInfo.aivo_id,
    'parent_id': userInfo.parent_id,
    'aeos_parameter': userInfo.aeos_parameter,
    'nickname': userInfo.nickname,
  };
  try {
    var url = Uri.https(ApiPaths.api_root, ApiPaths.api_regist_clinic);
    var response = await http.post(url, body: body);
    final RegistResponse info = RegistResponse.fromJson(jsonDecode(response.body));
    return info;
  } catch (error) {
    return RegistResponse(errorCode: errorCode);
  }
}

///症状判定
///問診APIについては未確定事項が多いので飽くまで暫定情報として
Future<SymptomResponse> symptom(SymptomRequest request, {bool noSymtom = false}) async {
  final body = {
    'aivo_id': request.aivo_id,
    'parent_id': request.parent_id,
    'voice_recognition': request.voice_recognition,
  };
  try {
    ///テスト
    if (isTest) return await symptomTest(request, noSymtom: noSymtom);

    var url = Uri.https(ApiPaths.api_root, ApiPaths.api_symptom);
    var response = await http.post(url, body: body);
    final SymptomResponse info = SymptomResponse.fromJson(jsonDecode(response.body));
    return info;
  } catch (error) {
    return SymptomResponse(errorCode: errorCode);
  }
}

///問診開始
Future<QnAResponse> questionStart(QuestionRequest request) async {
  final body = {
    'aivo_id': request.aivo_id,
    'parent_id': request.parent_id,
    'symptom': request.symptom,
    'sex': request.sex,
    'birthday': request.birthday,
  };
  try {
    ///テスト
    if (isTest) return await questionStartTest(request);

    var url = Uri.https(ApiPaths.api_root, ApiPaths.api_question_start);
    var response = await http.post(url, body: body);
    final QnAResponse info = QnAResponse.fromJson(jsonDecode(response.body));
    return info;
  } catch (error) {
    return QnAResponse(errorCode: errorCode);
  }
}

///設問取得
Future<QnAResponse> questionGet(QuestionRequest request, {int questionIndex = 0}) async {
  final body = {
    'aivo_id': request.aivo_id,
    'parent_id': request.parent_id,
    'session_id': request.session_id,
  };
  try {
    ///テスト
    if (isTest) return await questionGetTest(request, questionIndex: questionIndex);

    var url = Uri.https(ApiPaths.api_root, ApiPaths.api_question_start);
    var response = await http.post(url, body: body);
    final QnAResponse info = QnAResponse.fromJson(jsonDecode(response.body));

    print(response.body);

    return info;
  } catch (error) {
    return QnAResponse(errorCode: errorCode);
  }
}

///設問回答
///次の設問が無くなるまで取得と回答を繰り返す。
Future<QnAResponse> questionAns(AnswerRequest request, {int questionIndex = 0}) async {
  final body = {
    'aivo_id': request.aivo_id,
    'parent_id': request.parent_id,
    'session_id': request.session_id,
    'answers': request.answers,
  };
  try {
    ///テスト
    if (isTest) return await questionAnsTest(request, questionIndex: questionIndex);

    var url = Uri.https(ApiPaths.api_root, ApiPaths.api_question_start);
    var response = await http.post(url, body: body);
    final QnAResponse info = QnAResponse.fromJson(jsonDecode(response.body));
    return info;
  } catch (error) {
    return QnAResponse(errorCode: errorCode);
  }
}

///設問回答
Future<QnAResponseModel> questionAnser(QnARequestModel request, ThemaType themaTYpe) async {
  try {
    ///テスト
    //if (isTest) return await questionAnserTest(request, questionIndex: questionIndex);

    var url = Uri.https(ApiPaths.api_root, ApiPaths.api_question_start);
    var body = {
      "aivo_id": request.aivo_id.toString(),
      "timestamp": request.timestamp,
      "thema": getThemaTypeName(themaTYpe),
      "speech_txt": request.speech_txt,
    };
    var response = await http.post(url, body: body);
    print(request.toJson());
    print(response.body);
    if (response.statusCode == successCode) {
      final QnAResponseModel info = QnAResponseModel.fromJson(jsonDecode(response.body));
      return info;
    }
    final dict = jsonDecode(response.body);
    print(dict);
    return QnAResponseModel(
      message: dict.containsKey('error') ? dict['error'] as String : dict['message'] as String,
      answer_txt: '',
      isError: true,
    );
  } catch (e) {
    print(e);
    final msg = e.toString().replaceAll('Exception:', '').replaceAll('ErrorException:', '');
    return QnAResponseModel(message: msg, answer_txt: '', isError: true);
  }
}

///会話履歴照会（1週間）
Future<List<HistoryModel>?> getChatHistory(int aivoId, ThemaType themaType) async {
  try {
    ///テスト
    if (isTest) return await getHistoryTest();

    String path = (themaType == ThemaType.Health) ? ApiPaths.api_history : ApiPaths.api_history_thema;

    var body = {
      'aivo_id': aivoId.toString(),
      "start_date": "", //DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: -14))),
      "end_date": "", //DateFormat('yyyy-MM-dd').format(now),
    };

    if (themaType == ThemaType.Disaster) {
      body = {
        'aivo_id': aivoId.toString(),
        "thema": getThemaTypeName(themaType),
      };
    }

    var url = Uri.https(ApiPaths.api_root, path);
    var response = await http.post(url, body: body);
    print(response.body);
    if (response.statusCode == successCode) {
      ///災害
      if (themaType == ThemaType.Disaster) {
        final items = jsonDecode(response.body)['items'] as dynamic;
        return [HistoryModel.fromJson(items)];
      }
      final items = jsonDecode(response.body)['items'] as List<dynamic>;
      return items.map((e) => HistoryModel.fromJson(e)).toList();
    } else {
      final dict = jsonDecode(response.body);
      print(dict);
      throw Exception(dict.containsKey('error') ? dict['error'] : dict['message']);
    }
  } catch (error) {
    rethrow;
  }
}

///問診履歴要約）
Future<String?> getChatHistorySummary(int aivoId) async {
  try {
    ///テスト
    if (isTest) return '改行を含む要約テキストが入ります';

    final body = {
      'aivo_id': aivoId.toString(),
      "start_date": "",
    };

    var url = Uri.https(ApiPaths.api_root, ApiPaths.api_history_summary);
    var response = await http.post(url, body: body);
    print(response.body);
    if (response.statusCode == successCode) {
      final summary = jsonDecode(response.body)['summary'] as String;
      return summary;
    } else {
      final dict = jsonDecode(response.body);
      print(dict);
      throw Exception(dict.containsKey('error') ? dict['error'] : dict['message']);
    }
  } catch (error) {
    rethrow;
  }
}

///バーコード登録
Future<String> registBarcode(int aivoId, String strBarcode) async {
  try {
    if (isTest) {
      return "連携許可に成功しました";
    }

    final vals = strBarcode.split(',');
    if (vals.length != 3) {
      return "QRコードは不正です";
    }

    var url = Uri.https(ApiPaths.api_root, ApiPaths.api_allow);
    var body = {
      "aivo_id": aivoId.toString(),
      "kanavo_id": vals[1].replaceAll("\"", ""),
      "facility_id": vals[2].replaceAll("\"", ""),
    };

    var response = await http.post(url, body: body);

    print(response.body);
    if (response.statusCode == successCode) {
      return jsonDecode(response.body)['message'] as String;
    }
    return jsonDecode(response.body)['error'] as String;
  } catch (error) {
    rethrow;
  }
}

///バーコード登録
Future<String> reportMessage(int aivoId, String content, String reason, String other) async {
  try {
    //var url = Uri.https(ApiPaths.api_root, ApiPaths.api_report);
    var url = Uri.https("kanatadev.kanavo-ai.net", ApiPaths.api_report);
    var body = {
      "aivo_id": aivoId.toString(),
      "content": content,
      "reason": reason,
      "other": other,
    };

    var response = await http.post(url, body: body);

    print(response.body);
    if (response.statusCode == successCode) {
      return jsonDecode(response.body)['message'] as String;
    }
    return jsonDecode(response.body)['error'] as String;
  } catch (error) {
    rethrow;
  }
}
