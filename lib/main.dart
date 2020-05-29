import 'package:chooselunch/models/user.dart';
import 'package:flutter/material.dart';
import 'package:chooselunch/routes/routes.dart';

void main() {
  var _user = UserModel();
  runApp(ChooseLunch());
}

class ChooseLunch extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Simple Login Demo',
      theme: new ThemeData(
          primarySwatch: Colors.deepPurple
      ),
      routes: routes,
    );
  }
}
