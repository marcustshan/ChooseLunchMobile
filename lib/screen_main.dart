import 'dart:core';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:chooselunch/models/user.dart';
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

  List<dynamic> _restaurants = [];
  List<dynamic> _messages = [];
  List<dynamic> _lunch_choices = [];
  List<dynamic> _coffee_choices = [];
  List<dynamic> _coffees = [];

  @override
  void initState() {
    super.initState();

    _fnGetRestaurants();
    _fnGetTodayLunchChoices();
    _fnGetTodayCoffeeChoices();
    _fnGetTodayMessages();
    _fnGetCoffees();

    /*
    _http.get('/getRestaurants').then((restaurants) {
      setState(() {
        _restaurants = restaurants;
      });
    });
    _http.get('/getTodayChoices').then((lunch_choices) {
      setState(() {
        _lunch_choices = lunch_choices;
      });
    });
    _http.get('/getTodayCoffeeChoices').then((coffee_choices) {
      setState(() {
        _coffee_choices = coffee_choices;
      });
    });
    _http.get('/getTodayMessages').then((messages) {
      setState(() {
        _messages = messages;
      });
    });
    _http.post('https://www.banapresso.com/query',
      {'Content-Type': "application/json"},
      jsonEncode({
        'ws': "fprocess",
        'query': "MWRQ85AQ0V9VBEJ3GMUJ",
        'params': {'nFCode': 200000}
      })
    ).then((coffees) {
      setState(() {
        _coffees = coffees.rows;
      });
    });
     */
  }

  @override
  Widget build(BuildContext context) {
    _user = ModalRoute.of(context).settings.arguments;

    _fnInitSocket();

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
    if(_restaurants == null || _restaurants.isEmpty) {
      return new Container();
    }

    return new GroupedListView(
        elements: _restaurants,
        groupBy: (element) => element['category_name'],
        useStickyGroupSeparators: true,
        groupSeparatorBuilder: (value) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ),
        itemBuilder: (c, element) {
          return Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              child: ListTile(
                contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Icon(Icons.account_circle),
                title: Text(element['name']),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
          );
        },
        order: GroupedListOrder.ASC
    );
  }

  Widget _buildCoffeeList() {
    if(_coffees == null || _coffees.isEmpty) {
      return new Container();
    }

    return new GroupedListView(
        elements: _coffees,
        groupBy: (element) => element['category_name'],
        useStickyGroupSeparators: true,
        groupSeparatorBuilder: (value) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
        ),
        itemBuilder: (c, element) {
          return Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              child: ListTile(
                contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Icon(Icons.account_circle),
                title: Text(element['name']),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
          );
        },
        order: GroupedListOrder.ASC
    );
  }

  void _fnGetRestaurants() async {
    print('식당 조회 시작');
    List<dynamic> restaurants = await _http.get('/getRestaurants');
    setState(() {
      _restaurants = restaurants;
    });
    print('식당 조회 종료');
  }

  void _fnGetTodayLunchChoices() async {
    print('점심 선택 조회 시작');
    List<dynamic> lunch_choices = await _http.get('/getTodayChoices');
    setState(() {
      _lunch_choices = lunch_choices;
    });
    print('점심 선택 조회 종료');
  }

  void _fnGetTodayCoffeeChoices() async {
    print('커피 선택 조회 시작');
    List<dynamic> coffee_choices = await _http.get('/getTodayCoffeeChoices');
    setState(() {
      _coffee_choices = coffee_choices;
    });
    print('커피 선택 조회 종료');
  }

  void _fnGetTodayMessages() async {
    print('채팅 조회 시작');
    List<dynamic> messages = await _http.get('/getTodayMessages');
    setState(() {
      _messages = messages;
    });
    print('채팅 조회 종료');
  }

  void _fnGetCoffees() async {
    print('커피 조회 시작');

    dynamic coffees = await _http.post('https://www.banapresso.com/query',
        {'Content-Type': "application/json"},
        jsonEncode({
          'ws': "fprocess",
          'query': "MWRQ85AQ0V9VBEJ3GMUJ",
          'params': {'nFCode': 200000}
        })
    );

    setState(() {
      _coffees = coffees['rows'];
    });

    print('커피 조회 종료');
  }

  void _fnInitSocket() {
    if(_socket != null && _socket.connected) {
      return;
    }

    _socket = IO.io('http://cl.byulsoft.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.off('receiveChat');
    _socket.on('receiveChat', (data) {
      print('와우 채팅 왔는가보다');
    });
    _socket.off('chosen');
    _socket.on('chosen', (data) {
      print('와우 누가 선택 했나봐');
    });
    _socket.off('usersChanged');
    _socket.on('usersChanged', (data) {
      print('와우 누가 접속 했나봐');
    });

    _socket.emit('connected', _user.toMap());
  }
}
