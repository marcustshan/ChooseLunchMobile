import 'package:flutter/material.dart';

import 'package:chooselunch/screen_main.dart';
import 'package:chooselunch/screen_login.dart';

final routes = {
  '/': (BuildContext context) => LoginPage(),
  '/login': (BuildContext context) => LoginPage(),
  '/main': (BuildContext context) => MainPage()
};