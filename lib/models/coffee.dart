class Coffee {
  int _coffee_seq, _price;
  String _choose_time, _choose_yn, _coffee_name, _hot_yn, _category;

  int get coffee_seq => _coffee_seq;
  int get price => _price;
  String get choose_time => _choose_time;
  String get choose_yn => _choose_yn;
  String get coffee_name => _coffee_name;
  String get hot_yn => _hot_yn;
  String get category => _category;

  Coffee.map(dynamic obj) {
    this._coffee_seq = obj['coffee_seq'];
    this._price = obj['price'];
    this._choose_time = obj['choose_time'];
    this._choose_yn = obj['choose_yn'];
    this._coffee_name = obj['coffee_name'];
    this._hot_yn = obj['hot_yn'];
    this._category = obj['category'];
  }

  Coffee({coffee_seq, price, choose_time, choose_yn, coffee_name, hot_yn, category});

  List<Coffee> convertCoffees(List<dynamic> target) {

  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['coffee_seq'] = _coffee_seq;
    map['price'] = _price;
    map['choose_time'] = _choose_time;
    map['choose_yn'] = _choose_yn;
    map['coffee_name'] = _coffee_name;
    map['hot_yn'] = _hot_yn;
    map['category'] = _category;

    return map;
  }
}