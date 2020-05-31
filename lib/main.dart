import 'package:flutter/material.dart';
import 'package:chooselunch/routes/routes.dart';

void main() {
  runApp(ChooseLunch());
}

class ChooseLunch extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Choose Lunch',
      theme: new ThemeData(primarySwatch: Colors.deepPurple),
      routes: routes,
    );
  }
}
