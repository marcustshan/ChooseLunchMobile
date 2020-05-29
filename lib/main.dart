import 'package:chooselunch/models/user.dart';
import 'package:chooselunch/screen_login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:double_back_to_close/double_back_to_close.dart';

void main() {
  var _user = UserModel();
  runApp(ChooseLunch());
}

class ChooseLunch extends StatelessWidget {
  DateTime backbuttonpressedTime;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Choose Lunch',
      theme: new ThemeData(primarySwatch: Colors.deepPurple),
      home: DoubleBack(message: '한번 더 누르시면 앱이 종료됩니다.', child: LoginPage()),
    );
  }
}
