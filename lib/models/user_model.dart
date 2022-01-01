class UserModel {
  String? uid;
  String? fullName;
  String? email;
  String? profilePic;
  String? idDesg;
  String? status;
  String? role;

  UserModel({
    this.uid,
    this.fullName,
    this.email,
    this.profilePic,
    this.idDesg,
    this.status,
    this.role,
  });

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullName = map["fullName"];
    email = map["email"];
    profilePic = map["profilePic"];
    idDesg = map["idDesg"];
    status = map["status"];
    role = map["role"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullName": fullName,
      "email": email,
      "profilePic": profilePic,
      "idDesg": idDesg,
      "status": status,
      "role": role,
    };
  }
}
