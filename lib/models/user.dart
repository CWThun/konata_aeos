class User {
  String? id;
  String? parentId;
  String? name;
  User({this.id, this.parentId, this.name});
  factory User.fromJson(Map<String, dynamic> json) {
    var user = User();
    if (json["id"] != null) {
      user.id = json['id'] as String;
    }
    if (json["parentId"] != null) {
      user.parentId = json['parentId'] as String;
    }
    if (json["name"] != null) {
      user.name = json['name'] as String;
    }
    return user;
  }
}
