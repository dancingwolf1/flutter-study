import 'package:flutter/material.dart';
import 'package:flutter_spterp/pages/home/index.dart';
import 'package:flutter_spterp/pages/news.dart';
import 'package:flutter_spterp/pages/my.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavigationWidget extends StatefulWidget {
  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _currentIndex = 0; //当前的页面索引
  List<Widget> pageList = List();

  @override
  void initState() {
    pageList
      ..add(HomePage())
      ..add(NewsPage())
      ..add(MyPage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    adaptation();
    return Scaffold(
        body: pageList[_currentIndex],
        bottomNavigationBar: new BottomNavigationBar(
          unselectedIconTheme:
              IconThemeData(color: Color.fromRGBO(139, 137, 151, 1)),
          items: [
            BottomNavigationBarItem(
//        unselectedIconTheme:
                icon: _currentIndex == 0?Image(
                  image: AssetImage('images/tab_bottom_01.png'),
                  width: ScreenUtil().setWidth(40),
                ):Image(
                  image: AssetImage('images/untab_bottom_01.png'),
                  width: ScreenUtil().setWidth(40),
                ),
                title: Text("首页")),
            BottomNavigationBarItem(
                icon: _currentIndex == 0?Image(
                  image: AssetImage('images/tab_bottom_04.png'),
                  width: ScreenUtil().setWidth(40),
                ):Image(
                  image: AssetImage('images/untab_bottom_04.png'),
                  width: ScreenUtil().setWidth(40),
                ), title: Text("发现")),
            BottomNavigationBarItem(
                icon: _currentIndex == 1?Image(
                  image: AssetImage('images/tab_bottom_05.png'),
                  width: ScreenUtil().setWidth(40),
                ):Image(
                  image: AssetImage('images/untab_bottom_05.png'),
                  width: ScreenUtil().setWidth(40),
                ),title: Text("我的")),
          ],
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
        ));
  }

  adaptation() {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
  }
}
