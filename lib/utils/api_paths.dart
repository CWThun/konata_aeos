///APIパス
// ignore_for_file: constant_identifier_names

class ApiPaths {
  ///検証環境
  //static const String api_root = 'kanatadev.kanavo-ai.net';

  ///本番環境
  static const String api_root = 'aivo.aeosvoice.net';

  ///親ユーザー登録APIパス
  static const String api_regist_parent = 'api/aivo-regist';

  ///親ユーザーログイン
  static const String api_login_parent = 'api/aivo-regist';

  ///ユーザー照会
  static const String api_reference = '/reference';

  ///子ユーザー登録
  static const String api_regist_child = '/regist_child';

  ///医療機関登録
  static const String api_regist_clinic = '/regist_clinic';

  ///症状判定
  static const String api_symptom = '/symptom';

  ///設問取得
  static const String api_question_get = '/question_get';

  ///設問回答
  static const String api_question_ans = '/question_ans';

  ///問診開始
  static const String api_question_start = 'api/aivo-question';

  ///会話履歴照会
  static const String api_history = 'api/aivo-history';

  ///会話履歴照会
  static const String api_history_thema = 'api/aivo-history-thema';

  ///バーコード登録
  static const String api_allow = 'api/aivo-allow';

  ///問診履歴要約
  static const String api_history_summary = 'api/aivo-history-summary';

  ///AIレポート
  static const String api_report = 'api/aivo-report';
}
