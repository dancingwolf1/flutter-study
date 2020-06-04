import 'package:flutter/material.dart';
import 'package:flutter_spterp/component/x_router.dart';
import 'package:flutter_spterp/pages/home/index.dart';

import 'package:flutter_spterp/pages/my.dart';
import 'package:flutter_spterp/pages/news.dart';

var nowIndex = 0;

Widget getBottomBar(BuildContext context, int index) {
  return BottomNavigationBar(
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("首页"),
          backgroundColor: Colors.blueGrey),
      BottomNavigationBarItem(
          icon: Icon(Icons.message),
          title: Text("消息"),
          backgroundColor: Colors.blueGrey),
      BottomNavigationBarItem(
          icon: Icon(Icons.new_releases),
          title: Text("发现"),
          backgroundColor: Colors.blueGrey),
      BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text("我的"),
          backgroundColor: Colors.blueGrey),
    ],
    type: BottomNavigationBarType.fixed,
    currentIndex: index,
    fixedColor: Colors.blue,
    onTap: (index) {
      _onItemTapped(index, context);
    },
  );
}

setNowIndex(index) {
  nowIndex = index;
}

_onItemTapped(index, context) {
  if (nowIndex != index) {
    Navigator.of(context).pushAndRemoveUntil(
        new XRoute(builder: (context) => _jump(index)),
        (route) => route == null);
    nowIndex = index;
  }
}

_jump(index) {
  switch (index) {
    case 0:
      return HomePage();
    case 1:
      return NewsPage();
    case 2:
      return MyPage();
  }
}
