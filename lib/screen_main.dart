import 'package:chooselunch/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:convert';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.deepPurple),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.restaurant_menu)),
                Tab(icon: Icon(Icons.local_drink)),
                Tab(icon: Icon(Icons.chat)),
              ],
            ),
            title: Text('Choose Lunch'),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  // do something
                },
              )
            ],
          ),
          body: TabBarView(
            children: [
              Icon(Icons.restaurant_menu),
              Icon(Icons.local_drink),
              Icon(Icons.chat),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("Choose Lunch"),
      centerTitle: true,
    );
  }
}
