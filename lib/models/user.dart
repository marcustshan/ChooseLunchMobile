class User {
  int _user_seq;
  String _id, _name, _smoker_yn, _manager_yn, _token;

  int get user_seq => _user_seq;
  String get id => _id;
  String get name => _name;
  String get smoker_yn => _smoker_yn;
  String get manager_yn => _manager_yn;
  String get token => _token;

  User.map(dynamic obj) {
    this._user_seq = obj['user_seq'];
    this._id = obj['id'];
    this._name = obj['name'];
    this._smoker_yn = obj['smoker_yn'];
    this._manager_yn = obj['manager_yn'];
    this._token = obj['token'];
  }

  User({user_seq, id, name, smoker_yn, manager_yn, token});

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['user_seq'] = _user_seq;
    map['id'] = _id;
    map['name'] = _name;
    map['smoker_yn'] = _smoker_yn;
    map['manager_yn'] = _manager_yn;
    map['token'] = _token;

    return map;
  }
}