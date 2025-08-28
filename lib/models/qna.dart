class QnA {
  String? question;
  List<String>? choosen;
  int? chooseIndex;
  String? anwser;
  String? type = "text";
  bool? finish = false;
  bool? otherQnA = false;

  QnA({this.question, this.choosen, this.chooseIndex, this.type, this.finish, this.otherQnA});

  factory QnA.fromJson(Map<String, dynamic> json) {
    var qna = QnA();

    if (json["question"] != null) {
      qna.question = json['question'] as String;
    }
    if (json['choosen'] != null) {
      qna.choosen = (json['choosen'] as List).map((e) => e.toString()).toList();
    }
    if (json["type"] != null) {
      qna.type = json['type'] as String;
    }
    if (json["finish"] != null) {
      qna.finish = json['finish'] as bool;
    }
    if (json["otherQnA"] != null) {
      qna.otherQnA = json['otherQnA'] as bool;
    }
    return qna;
  }
}

class StyleText {
  String text;
  bool isBold;
  StyleText(this.text, this.isBold);
}
