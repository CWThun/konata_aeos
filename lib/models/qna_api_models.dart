// ignore_for_file: non_constant_identifier_names

import 'package:konata/models/regist_api_models.dart';
import 'package:konata/utils/variable.dart';

///質問の回答候補
class QuestionItem {
  String? item_id;
  String? item_title;
  QuestionItem({this.item_id, this.item_title});
  factory QuestionItem.fromJson(Map<String, dynamic> json) {
    var item = QuestionItem();
    item.item_id = json.containsKey("item_id") ? json['item_id'] as String? : null;
    item.item_title = json.containsKey("item_title") ? json['item_title'] as String? : null;
    return item;
  }
}

///質問内容モデル
class QuestionContent {
  String? question_title;
  List<QuestionItem>? items;
  QuestionContent({this.question_title, this.items});

  factory QuestionContent.fromJson(Map<String, dynamic> json) {
    var questionContent = QuestionContent();
    questionContent.question_title = json.containsKey("question_title") ? json['question_title'] as String? : null;
    if (json.containsKey('items')) {
      var items = json['items'] as List;
      questionContent.items = items.map((e) => QuestionItem.fromJson(e)).toList();
    }
    return questionContent;
  }
}

///質問モデル
class Question {
  String? id;
  String? type;
  QuestionContent? content;
  Question({this.id, this.type, this.content});
  factory Question.fromJson(Map<String, dynamic> json) {
    var question = Question();
    question.id = json.containsKey("id") ? json['id'] as String? : null;
    question.type = json.containsKey("type") ? json['type'] as String? : null;
    question.content = json.containsKey("content") ? QuestionContent.fromJson(json['content']) : null;
    return question;
  }
}

///回答モデル
class Answer {
  String? question_id;
  String? question_type;
  String? answer;
  Answer({this.question_id, this.question_type, this.answer});
  factory Answer.fromJson(Map<String, dynamic> json) {
    var answer = Answer();
    answer.question_id = json.containsKey("question_id") ? json['question_id'] as String? : null;
    answer.question_type = json.containsKey("question_type") ? json['question_type'] as String? : null;
    answer.answer = json.containsKey("answer") ? json['answer'] as String? : null;
    return answer;
  }
}

///質問のレスポンスモデル
class QnAResponse extends BaseResponse {
  String? message;
  String? session_id;
  String? sex;
  String? birthday;
  String? next_question_category;
  Question? questions;
  QnAResponse({
    this.message,
    this.session_id,
    this.sex,
    this.birthday,
    this.next_question_category,
    this.questions,
    super.errorCode,
  });
  factory QnAResponse.fromJson(Map<String, dynamic> json) {
    var response = QnAResponse();
    response.errorCode = successCode;
    response.message = json.containsKey("message") ? json['message'] as String? : null;
    response.session_id = json.containsKey("session_id") ? json['session_id'] as String? : null;
    response.sex = json.containsKey("sex") ? json['sex'] as String? : null;
    response.birthday = json.containsKey("birthday") ? json['birthday'] as String? : null;
    response.next_question_category =
        json.containsKey("next_question_category") ? json['next_question_category'] as String? : null;
    if (json.containsKey('questions')) {
      response.questions = Question.fromJson(json['questions']);
    }
    return response;
  }

  isFinish() => next_question_category != null && next_question_category == 'finish';
  toNext() => next_question_category != null && next_question_category == 'normal';
}

///問診モデル
class QuestionRequest {
  int? aivo_id;
  String? parent_id;
  String? symptom;
  String? session_id;
  String? sex;
  String? birthday;
  QuestionRequest({
    this.aivo_id,
    this.parent_id,
    this.symptom,
    this.session_id,
    this.sex,
    this.birthday,
  });
}

class AnswerRequest {
  int? aivo_id;
  String? parent_id;
  String? session_id;
  Answer? answers;
  AnswerRequest({
    this.aivo_id,
    this.parent_id,
    this.session_id,
    this.answers,
  });
}

///症状判定モデル
class SymptomRequest {
  int? aivo_id;
  String? parent_id;
  String? voice_recognition;
  SymptomRequest({this.aivo_id, this.parent_id, this.voice_recognition});
}

///症状判定レスポンスモデル
class SymptomResponse extends BaseResponse {
  String? message;
  String? symptom;
  String? sex;
  String? birthday;
  SymptomResponse({
    this.message,
    this.symptom,
    this.sex,
    this.birthday,
    super.errorCode,
  });
  factory SymptomResponse.fromJson(Map<String, dynamic> json) {
    var response = SymptomResponse();
    response.errorCode = successCode;
    response.message = json.containsKey("message") ? json['message'] as String? : null;
    response.symptom = json.containsKey("symptom") ? json['symptom'] as String? : null;
    response.sex = json.containsKey("sex") ? json['sex'] as String? : null;
    response.birthday = json.containsKey("birthday") ? json['birthday'] as String? : null;
    return response;
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'symptom': symptom,
      };
}
