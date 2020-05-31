import 'dart:convert';

import 'package:chooselunch/models/user.dart';
import 'package:chooselunch/screen_main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:chooselunch/utils/network_util.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  DateTime currentBackPressTime;

  final TextEditingController _idController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  String _id = "";
  String _password = "";
  bool _remember = false;

  User _user;

  _LoginPageState() {}

  @override
  void initState() {
    super.initState();
    _checkRemember();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        appBar: _buildBar(context),
        body: new Container(
          padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 80.0),
          child: new Column(
            children: <Widget>[
              _buildTextFields(),
              _buildCheckbox(),
              _buildButtons()
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: '한번 더 누르시면 앱이 종료됩니다.');
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("Choose Lunch"),
      centerTitle: true,
      backgroundColor: Colors.deepPurple,
    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _idController,
              decoration: new InputDecoration(labelText: 'ID'),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _passwordController,
              decoration: new InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return new Container(
      padding: EdgeInsets.only(top: 30.0),
      child: new Column(
        children: <Widget>[
          new RaisedButton(
            child: new Text('Login'),
            onPressed: _onLoginPressed,
          )
        ],
      ),
    );
  }

  Widget _buildCheckbox() {
    return new Container(
      padding: EdgeInsets.only(top: 30.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Checkbox(
            value: _remember,
            onChanged: _onRememberChanged,
          ),
          new Text('로그인 유지')
        ],
      ),
    );
  }

  void _fnLoginByToken(String token) async {
    final response = await http.post(
      'http://cl.byulsoft.com/api/loginByToken',
      body: jsonEncode(
        {},
      ),
      headers: {'Content-Type': "application/json", 'jwt-header': token},
    );

    JsonDecoder _decoder = new JsonDecoder();

    // ignore: unrelated_type_equality_checks
    if (response.body == 'false') {
      _fnShowDialog();
    } else {
      // 로그인 성공
      _user = new User.map(_decoder.convert(response.body));
      if (_remember) {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setString('ChooseLunchRememberToken', _user.token);
        _prefs.setString('ChooseLunchRememberId', _user.id);
      }

      Navigator.pushReplacementNamed(
        context,
        '/main',
        arguments: _user
      );
    }
  }

  Future<void> _onLoginPressed() async {
    _id = _idController.text;
    _password = _passwordController.text;
    final response = await http.post(
      'http://cl.byulsoft.com/api/login',
      body: jsonEncode(
        {'id': _id, 'password': _password, 'mobileYn': 'Y'},
      ),
      headers: {'Content-Type': "application/json"},
    );
    
    JsonDecoder _decoder = new JsonDecoder();

    // ignore: unrelated_type_equality_checks
    if (response.body == 'false') {
      _fnShowDialog();
    } else {
      // 로그인 성공
      _user = new User.map(_decoder.convert(response.body));
      if (_remember) {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setString('ChooseLunchRememberToken', _user.token);
        _prefs.setString('ChooseLunchRememberId', _user.id);
      }

      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
          builder: (context) => new MainPage(),
        ),
      );
    }
  }

  void _checkRemember() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String token = _prefs.getString('ChooseLunchRememberToken');
    final String id = _prefs.getString('ChooseLunchRememberId');

    if (token != null && id != null && token.isNotEmpty && id.isNotEmpty) {
      setState(() {
        _id = id;
        _remember = true;

        _fnLoginByToken(token);
      });

      return;
    }
  }

  void _onRememberChanged(bool newValue) => setState(() {
        _remember = newValue;
      });

  void _fnShowDialog() {
    /*
    Fluttertoast.showToast(
        msg: "로그인 실패 !!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
     */

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("로그인 실패 !!"),
          content: new Text("ID 혹은 비밀번호를 확인해주세요."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
