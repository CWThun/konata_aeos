// ignore_for_file: non_constant_identifier_names

///レスポンスベース
class BaseResponse {
  ///レスポンスエラー
  int? errorCode;
  String? errorMessage;
  BaseResponse({this.errorCode, this.errorMessage});
}

class RegistUserInfo {
  String? mail;

  String? pass_txt;

  ///（パスワード）SHA-256
  String? pass_hash;

  ///kanata画面のQRコード
  String? aeos_parameter;

  ///愛称
  String? nickname;
  String? sex;
  String? birthmonth;

  ///ユーザー単位のユニークID
  int? aivo_id;

  ///親ユーザー単位のユニークID
  String? parent_id;

  RegistUserInfo({
    this.mail,
    this.pass_txt,
    this.pass_hash,
    this.aeos_parameter,
    this.nickname,
    this.sex,
    this.birthmonth,
    this.aivo_id,
    this.parent_id,
  });

  factory RegistUserInfo.fromJson(Map<String, dynamic> json) {
    var userInfo = RegistUserInfo();
    userInfo.mail = json.containsKey("mail") ? json['mail'] as String? : null;
    userInfo.pass_txt = json.containsKey("pass_txt") ? json['pass_txt'] as String? : null;

    /*
    userInfo.pass_hash = json.containsKey("pass_hash") ? json['pass_hash'] as String? : null;
    userInfo.aeos_parameter = json.containsKey("aeos_parameter") ? json['aeos_parameter'] as String? : null;
    userInfo.nickname = json.containsKey("nickname") ? json['nickname'] as String? : null;
    userInfo.sex = json.containsKey("sex") ? json['sex'] as String? : null;
    userInfo.birthmonth = json.containsKey("birthmonth") ? json['birthmonth'] as String? : null;    
    userInfo.parent_id = json.containsKey("parent_id") ? json['parent_id'] as String? : null;
    */
    userInfo.aivo_id = json.containsKey("aivo_id") ? json['aivo_id'] as int? : null;
    return userInfo;
  }

  Map<String, dynamic> toJson() => {
        'aivo_id': aivo_id,
        'parent_id': parent_id,
        'mail': mail,
      };
}

class RegistResponse extends BaseResponse {
  ///成功メッセージ
  String? message;

  ///ユーザー単位のユニークID
  int? aivo_id;

  ///親ユーザー単位のユニークID
  String? parent_id;

  List<RegistUserInfo>? user_list;

  RegistResponse({
    this.message,
    this.aivo_id,
    this.parent_id,
    this.user_list,
    super.errorCode,
    super.errorMessage,
  });

  factory RegistResponse.fromJson(Map<String, dynamic> json) {
    var response = RegistResponse(errorCode: 200);
    response.message = json.containsKey("message") ? json['message'] as String? : null;
    response.aivo_id = json.containsKey("aivo_id") ? int.parse(json['aivo_id'].toString()) : null;
    //response.parent_id = json.containsKey("parent_id") ? json['parent_id'] as String? : null;

    if (json["user_list"] != null) {
      var userList = json["user_list"] as List;
      response.user_list = userList.map((e) => RegistUserInfo.fromJson(e)).toList();
    }

    return response;
  }

  Map<String, dynamic> toJson() {
    final ret = {
      'message': message,
      'aivo_id': aivo_id,
      'parent_id': parent_id,
    };

    return ret;
  }
}
