import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

import 'screen_login.dart';

void main() {
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
      home: new LoginPage(),
    );
    /*
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.restaurant_menu)),
                Tab(icon: Icon(Icons.chat)),
                Tab(icon: Icon(Icons.local_drink)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
            title: Text('Choose Lunch'),
          ),
          body: TabBarView(
            children: [
              Icon(Icons.restaurant_menu),
              Icon(Icons.chat),
              Icon(Icons.local_drink),
              Icon(Icons.settings),
            ],
          ),
        ),
      ),
    );
     */
  }
}
