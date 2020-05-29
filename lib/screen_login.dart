import 'package:chooselunch/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  SharedPreferences _prefs;

  final TextEditingController _idController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  String _id = "";
  String _password = "";
  bool _remember = false;

  _LoginPageState() {}

  @override
  void initState() {
    super.initState();
    _checkRemember();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildBar(context),
      body: new Container(
        padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 80.0),
        child: new Column(
          children: <Widget>[
            _buildTextFields(),
            _buildCheckbox(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("Choose Lunch Login"),
      centerTitle: true,
    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              autofocus: true,
              controller: _idController,
              decoration: new InputDecoration(
                  labelText: 'ID'
              ),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _passwordController,
              decoration: new InputDecoration(
                  labelText: 'Password'
              ),
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
            onPressed: _loginPressed,
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

  Future<void> _loginPressed () async {
    _id = _idController.text;
    _password = _passwordController.text;
    final response = await http.post(
      'http://cl.byulsoft.com/api/login',
      body: jsonEncode(
        {
          'id': _id,
          'password': _password,
          'mobileYn': 'Y'
        },
      ),
      headers: {'Content-Type': "application/json"},
    );

    // ignore: unrelated_type_equality_checks
    if(response.body == 'false') {
      _showDialog();
    } else {
      final UserModel _user = UserModel.fromJson(jsonDecode(response.body));
      if(_remember) {
      }
    }
  }

  void _checkRemember() async {
    _prefs = await SharedPreferences.getInstance();
    String token = _prefs.getString('ChooseLunchRememberToken');
    String id = _prefs.getString('ChooseLunchRememberId');
    setState(() {
      if(token != null && id != null && token.isNotEmpty && id.isNotEmpty) {
        Fluttertoast.showToast(
            msg: "로그인 실패 !!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    });
  }

  void _onRememberChanged(bool newValue) => setState(() {
    _remember = newValue;
  });

  void _showDialog() {
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