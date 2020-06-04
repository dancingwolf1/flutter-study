import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spterp/pages/component.dart';
import 'package:flutter_spterp/pages/contract/contract_list.dart';
import 'package:flutter_spterp/pages/navigation/navigation_here.dart';
import 'package:flutter_spterp/pages/others/login.dart';
import 'package:flutter_spterp/pages/others/page_transfer.dart';
import 'package:flutter_spterp/pages/others/vedio.dart';
import 'package:flutter_spterp/pages/signature-mine.dart';
import 'package:flutter_spterp/pages/statistic/satistic_click_pie3.dart';
import 'package:flutter_spterp/pages/statistic/satistic_done_circle_chart.dart';
import 'package:flutter_spterp/pages/statistic/satistic_pie_chart.dart';
import 'package:flutter_spterp/pages/statistic/satistic_tiao_chart.dart';
import 'package:flutter_spterp/pages/statistic/satistic_shan_chart.dart';
import 'package:flutter_spterp/pages/widget_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'accessories_application_list.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'others/scanner.dart';
class MenuPage extends StatefulWidget {
  @override
  MenuPageState createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  List<Widget> menuItems = [];
  List<Widget> fastImg = [];
  List<charts.Series> seriesList;
  List fast = []; // 快捷列表
  List fastCopy = []; // 快捷方式副本
  bool isEdit = false; // 默认不在编辑状态下
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await processingAuthority();
    await loadMenu();
  }



  Widget _menuItem(String title, IconData iconDate, Color iconColor,
      StatefulWidget routerPage, AssetImage img, String mid) {
    bool operating =
        false; // 通过对比来判断我要执行什么操作(false执行去除操作,true执行添加操作),关于操作和页面状态都是一个值控制
    for (int i = 0; i < fast.length; i++) {
      if (mid == fast[i].toString()) {
        operating = true;
      }
    }
    return GestureDetector(
      child: Container(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 6,
                ),
                Expanded(
                  child: OverflowBox(
                    child: Stack(
                      children: <Widget>[
                        SizedBox(
                          child: new Image(
                            width: 34,
                            height: 34,
                            image: img,
                          ),
                        ),
                      ],
                    ),
                  ),
                  flex: 2,
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 12, color: Color.fromRGBO(59, 57, 73, 1)),
                  ),
                )
              ],
            ),
            Positioned(
              child: isEdit
                  ? GestureDetector(
                      child: Container(
                        child: Icon(
                          operating ? Icons.remove : Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(20.0)),
                          color: operating ? Colors.red : Colors.blue,
                        ),
                      ),
                      onTap: () {
                        if (operating) {
                          fast.remove(mid);
                          loadMenu();
                          // 找到后消减掉
                        } else if (!operating) {
                          if (fast.length < 4) {
                            fast.add(mid);
                            fast.remove("");
                          } else {
                            Toast.show("最多只能添加四个");
                          }
                          // 添加以后执行一次
                          loadMenu();
                        }
                      },
                    )
                  : Container(),
              top: 0.0,
              right: 22.0,
            ),
          ],
        ),
      ),
      onTap: () {
        if (!isEdit) {
          Navigator.push(
              context, CupertinoPageRoute(builder: (router) => routerPage));
        }
      },
    );
  } // 图标

  Widget _menuItemFast(String title, IconData iconDate, Color iconColor,
      StatefulWidget routerPage, AssetImage img, String mid) {
    bool operating = false;
    for (int i = 0; i < fast.length; i++) {
      if (mid == fast[i].toString()) {
        operating = true;
      }
    }
    return GestureDetector(
      child: Container(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 6,
                ),
                Expanded(
                  child: OverflowBox(
                    child: Stack(
                      children: <Widget>[
                        SizedBox(
                          child: new Image(
                            width: 30,
                            height: 30,
                            image: img,
                          ),
                        ),
                      ],
                    ),
                  ),
                  flex: 10,
                ),
                Container()
              ],
            ),
            Positioned(
              child: isEdit
                  ? GestureDetector(
                      child: Container(
                        child: Icon(
                          operating ? Icons.remove : Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(20.0)),
                          color: operating ? Colors.red : Colors.blue,
                        ),
                      ),
                      onTap: () {
                        if (operating) {
                          fast.remove(mid);
                          loadMenu();
                        } else if (!operating) {
                          if (fast.length < 4) {
//                            fast.add(mid);
                          } else {
                            Toast.show("最多只能添加四个");
                          }
                          loadMenu();
                        }
                      },
                    )
                  : Container(),
              top: 0.0,
              right: 0.0,
            ),
          ],
        ),
      ),
      onTap: () {
        if (!isEdit) {
          Navigator.push(
              context, CupertinoPageRoute(builder: (router) => routerPage));
        }
      },
    );
  } // 快捷键图标

  Future<Widget> _cardItem(
      String modelName, List<Map<String, dynamic>> menuItem) async {
    List<Widget> weightList = [];

    for (int i = 0; i < menuItem.length; i++) {
      /*权限处理*/
      await getPermission(menuItem[i]['authValue'])
          ? weightList.add(_menuItem(
              menuItem[i]['title'],
              menuItem[i]['icon'],
              menuItem[i]['iconColor'],
              menuItem[i]['router'],
              menuItem[i]['image'],
              menuItem[i]['authValue']))
          : null;
      // 根据快捷方式数据生成快捷方式列表
      for (int j = 0; j < fast.length; j++) {
        if (fast[j].toString() == menuItem[i]['authValue']) {
          fastImg.add(_menuItemFast(
              "",
              menuItem[i]['icon'],
              menuItem[i]['iconColor'],
              menuItem[i]['router'],
              menuItem[i]['image'],
              menuItem[i]['authValue']));
        }
      }
    }
    weightList.toString();
    return Container(
      color: Color.fromRGBO(255, 255, 255, 1),
      padding: weightList.length == 0
          ? EdgeInsets.all(0.0)
          : EdgeInsets.only(left: 12, right: 12),
      child: weightList.length == 0
          ? null
          : Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.only(right: 0, bottom: 6),
                      title: Text(
                        modelName,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                GridView.count(
                    primary: false,
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    children: weightList)
              ],
            ),
    );
  }

  loadMenu() async {
    // 生成快捷方式之前给初始化掉
    fastImg = [];
    var menus = [
      isEdit
          ? Container(
              margin: EdgeInsets.only(top: 12, bottom: 12),
              color: Color.fromRGBO(255, 255, 255, 1),
              padding: const EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
//            Text("测试")
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          child: Center(
                              child: Text(
                        "常用项目:",
                        style: TextStyle(
                            color: Color.fromRGBO(112, 112, 112, 1),
                            fontSize: 16),
                      ))),
                      flex: 3,
                    ),
                    Expanded(
                      child: GridView.count(
                        primary: false,
                        shrinkWrap: true,
                        crossAxisCount: 6,
                        children: fastImg,
                      ),
                      flex: 6,
                    ),
                    Expanded(
                      child: Container(),
                      flex: 2,
                    ),
                  ],
                )
              ]),
            )
          : Container(
              margin: EdgeInsets.only(top: 14),
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
      await _cardItem("业务", [
        {
          "authValue": "erpPhone_ContractApi_getContractList",
          "title": "简易合同",
          "icon": FontAwesomeIcons.fileContract,
          "iconColor": Colors.blueAccent,
          "router": ContractListPage(),
          "image": new AssetImage('images/index_06.png'),
          "fast": false
        },


      ]),
        await _cardItem("统计", [
          {
            "authValue": "erpPhone_PartsApi_getPartsList",
            "title": "BarChart_1",
            "icon": FontAwesomeIcons.artstation,
            "iconColor": Colors.orangeAccent,
            "router": AccessoriesListPage(),
            "image": new AssetImage('images/index_22.png'),
            "fast": false
          },
          {
            "authValue": "erpPhone_PartsApi_getPartsList",
            "title": "BarChart_2",
            "icon": FontAwesomeIcons.artstation,
            "iconColor": Colors.orangeAccent,
            "router": TiaoChartPage(),
            "image": new AssetImage('images/index_22.png'),
            "fast": false
          },
          {
            "authValue": "erpPhone_PartsApi_getPartsList",
            "title": "CircularChart_1",
            "icon": FontAwesomeIcons.artstation,
            "iconColor": Colors.orangeAccent,
            "router": PieChartPage(),
            "image": new AssetImage('images/index_22.png'),
            "fast": false
          },
          {
            "authValue": "erpPhone_PartsApi_getPartsList",
            "title": "CircularChart_2",
            "icon": FontAwesomeIcons.artstation,
            "iconColor": Colors.orangeAccent,
            "router": DoneCircleChartPage(),
            "image": new AssetImage('images/index_22.png'),
            "fast": false
          },
          {
            "authValue": "erpPhone_PartsApi_getPartsList",
            "title": "CircularClick",
            "icon": FontAwesomeIcons.artstation,
            "iconColor": Colors.orangeAccent,
            "router": DemoPage(),
            "image": new AssetImage('images/index_22.png'),
            "fast": false
          },
          {
            "authValue": "erpPhone_PartsApi_getPartsList",
            "title": "PieChart",
            "icon": FontAwesomeIcons.artstation,
            "iconColor": Colors.orangeAccent,
            "router": ShanChartPage(),
            "image": new AssetImage('images/index_22.png'),
            "fast": false
          },
        ]),
      await _cardItem("其他", [
        {
          "authValue": "erpPhone_PartsApi_getPartsList",
          "title": "Card",
          "icon": FontAwesomeIcons.artstation,
          "iconColor": Colors.orangeAccent,
          "router": CardPage(),
          "image": new AssetImage('images/index_22.png'),
          "fast": false
        },
        {
          "authValue": "erpPhone_PartsApi_getPartsList",
          "title": "Key",
          "icon": FontAwesomeIcons.artstation,
          "iconColor": Colors.orangeAccent,
          "router": CardPage(),
          "image": new AssetImage('images/index_22.png'),
          "fast": false
        },
        {
          "authValue": "erpPhone_PartsApi_getPartsList",
          "title": "PageTransfer",
          "icon": FontAwesomeIcons.artstation,
          "iconColor": Colors.orangeAccent,
          "router": PageTransfPage(),
          "image": new AssetImage('images/index_22.png'),
          "fast": false
        },
        {
          "authValue": "erpPhone_PartsApi_getPartsList",
          "title": "Vedio",
          "icon": FontAwesomeIcons.artstation,
          "iconColor": Colors.orangeAccent,
          "router": VedioPage(),
          "image": new AssetImage('images/index_22.png'),
          "fast": false
        },
        {
          "authValue": "erpPhone_PartsApi_getPartsList",
          "title": "LoginPage",
          "icon": FontAwesomeIcons.artstation,
          "iconColor": Colors.orangeAccent,
          "router": Login1Page(),
          "image": new AssetImage('images/index_22.png'),
          "fast": false
        },
        {
          "authValue": "erpPhone_PartsApi_getPartsList",
          "title": "Component",
          "icon": FontAwesomeIcons.artstation,
          "iconColor": Colors.orangeAccent,
          "router": ComponentPage(),
          "image": new AssetImage('images/index_22.png'),
          "fast": false
        },
        {
          "authValue": "erpPhone_PartsApi_getPartsList",
          "title": "Signature",
          "icon": FontAwesomeIcons.artstation,
          "iconColor": Colors.orangeAccent,
          "router": MySignaturePage(),
          "image": new AssetImage('images/index_22.png'),
          "fast": false
        },
        {
          "authValue": "erpPhone_PartsApi_getPartsList",
          "title": "Map",
          "icon": FontAwesomeIcons.artstation,
          "iconColor": Colors.orangeAccent,
          "router": GaoDeMapPage(),
          "image": new AssetImage('images/index_22.png'),
          "fast": false
        },
        {
          "authValue": "erpPhone_PartsApi_getPartsList",
          "title": "Scanner",
          "icon": FontAwesomeIcons.artstation,
          "iconColor": Colors.orangeAccent,
          "router": ScannerPage(),
          "image": new AssetImage('images/index_22.png'),
          "fast": false
        },
        /*{
          "authValue": "erpPhone_PartsApi_getPartsList",
          "title": "Video_1",
          "icon": FontAwesomeIcons.artstation,
          "iconColor": Colors.orangeAccent,
          "router": VideoPage(),
          "image": new AssetImage('images/index_22.png'),
          "fast": false
        },*/

      ]),
      Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 18),
      ),
    ];
    setState(() {
      menuItems = menus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "更多",
            style: TextStyle(),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            IconButton(
              icon: Container(
                  width: 200,
                  child: Text("${isEdit ? "确定" : "编辑"}",
                      style: TextStyle(fontSize: 14))),
              onPressed: () async {
                setState(() {
                  isEdit = !isEdit;
                });
                if (isEdit) {
                  setState(() {
                    fastCopy = fast;
                  });
                } else {
                  setState(() {
                    _isLoading = true;
                  });
                  await setUserFavorite(config: fast.toString());
                  setState(() {
                    _isLoading = false;
                  });
                }
                loadMenu();
              },
            ),
          ],
          centerTitle: true),
      body: Container(
        color: Colors.grey[100],
        child: Row(
          children: <Widget>[
            // 编辑快捷方式
            Expanded(
              child: loading(
                  _isLoading,
                  ListView(
                    shrinkWrap: true,
                    children: menuItems == null ? [] : menuItems,
                  )),
            )
          ],
        ),
      ),
    );
  }

  processingAuthority() async {
    List result = await getUserFavorite();
    if (result == null) {
      result = [];
    }
    fast = result.map((v){
      return v.trim();
    }).toList();
  }
}
