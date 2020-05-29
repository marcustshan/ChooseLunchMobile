class UserModel {
  int _user_seq;
  String _id, _name, _smoker_yn, _manager_yn, _token;

  int get user_seq { return _user_seq; }
  String get id { return _id; }
  String get name { return _name; }
  String get smoker_yn { return _smoker_yn; }
  String get manager_yn { return _manager_yn; }
  String get token { return _token; }

  UserModel({user_seq, id, name, smoker_yn, manager_yn, token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      user_seq: json['user_seq'],
      id: json['id'],
      name: json['name'],
      smoker_yn: json['smoker_yn'],
      manager_yn: json['manager_yn'],
      token: json['token'],
    );
  }
}