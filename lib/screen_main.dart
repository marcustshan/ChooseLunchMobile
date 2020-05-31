import 'dart:convert';
import 'dart:core';

import 'package:chooselunch/models/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_list/grouped_list.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:chooselunch/utils/network_util.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime currentBackPressTime;
  
  NetworkUtil _http = new NetworkUtil();
  IO.Socket _socket;

  User _user;

  List _restaurants = [];
  List _messages = [];
  List _lunch_choices = [];
  List _coffee_choices = [];

  @override
  void initState() {
    super.initState();
  }

  void _fnGetRestaurants() async {
    print('식당 조회 시작');
    var restaurants = await _http.get('/getRestaurants');
    _restaurants = restaurants;
    print('식당 조회 종료');
  }

  void _fnGetTodayLunchChoices() async {
    print('점심 선택 조회 시작');
    var lunch_choices = await _http.get('/getTodayChoices');
    _lunch_choices = lunch_choices;
    print('점심 선택 조회 종료');
  }

  void _fnGetTodayCoffeeChoices() async {
    print('커피 선택 조회 시작');
    var coffee_choices = await _http.get('/getTodayCoffeeChoices');
    _coffee_choices = coffee_choices;
    print('커피 선택 조회 종료');
  }

  void _fnGetTodayMessages() async {
    print('채팅 조회 시작');
    var messages = await _http.get('/getTodayMessages');
    _messages = messages;
    print('채팅 조회 종료');
  }

  void _fnInitSocket() {
    _socket = IO.io('http://cl.byulsoft.com:8090', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.on('receiveChat', (data) {
      print('와우 채팅 왔는가보다');
    });
    _socket.on('chosen', (data) {
      print('와우 누가 선택 했나봐');
    });
    _socket.on('userschanged', (data) {
      print('와우 누가 접속 했나봐');
    });

    _socket.emit('connected', _user.toMap());
  }

  @override
  Widget build(BuildContext context) {
    _user = ModalRoute.of(context).settings.arguments;

    _fnInitSocket();
    // _fnGetRestaurants();
    _fnGetTodayLunchChoices();
    _fnGetTodayCoffeeChoices();
    _fnGetTodayMessages();

    print('종료 하고 온거니?');

    Widget main_widget = WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
                _buildLunchList(),
                Text('야 여기가 커피 고르는데야'),
                Text('야 여기는 채팅'),
              ],
            ),
          ),
        ),
      ),
    );

    return main_widget;
  }

  Future<bool> _onBackPressed() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: '한번 더 누르시면 앱이 종료됩니다.');
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget _buildLunchList() {
    print('뭐지?');

    print('식당 조회 시작');
    _http.get('/getRestaurants').then((restaurants) {
      _restaurants = restaurants;
      return new GroupedListView(
          elements: _lunch_choices,
          groupBy: (element) => element['category_name'],
          itemBuilder: (context, element) => Text(element['name']),
          order: GroupedListOrder.ASC
      );
    });
    print('식당 조회 종료');


  }
}
