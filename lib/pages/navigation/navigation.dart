import 'dart:async';
import 'dart:convert';
import 'package:amap_base/amap_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_spterp/component/appbar.dart';
import 'package:flutter_spterp/dao/gps_dao.dart';
import 'package:flutter_spterp/pages/navigation/keyword_poi_search.screen.dart';

class NavigationPage extends StatefulWidget {
  final String eppCode;
  final int taskSaleInvoiceId; // 小票id

  NavigationPage(this.eppCode, this.taskSaleInvoiceId);

  @override
  NavigationPageState createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage> {
  List addressData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() {
    // 加载地址
    print(widget.eppCode);
    getEppAddress(widget.eppCode).then((resp) {
      setState(() {
        addressData = resp;
      });
    });
  }

  /// 发送位置定时器
  /// 本方法调用后会创建一个定时器，该定时器每个一段时间会发送一次位置信息给服务器。

  @override
  Widget build(BuildContext context) {
    List<Widget> addresses = []; // 地址选择成员
    for (int i = 0; i < addressData.length; i++) {
      var bs = BorderSide(color: Colors.black12);
      var addr = addressData[i];
      Map addrMap = json.decode(addr['address']);
      var item = Container(
        decoration: BoxDecoration(
          border: i == 0 ? Border(top: bs, bottom: bs) : Border(bottom: bs),
        ),
//        color: Colors.white,
        child: Material(
          color: Colors.white,
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text(
                      "${addrMap['title']}(${addrMap['position']['latitude']},${addrMap['position']['longitude']})")
                ],
              ),
            ),
            onTap: () {
              var position = addrMap['position'];
              callNavApp(position['latitude'], position['longitude']);
            },
          ),
        ),
      );
      addresses.add(item);
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: getAppBar(context,"送货中", ),
      body: addressData.length <= 0
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("该工程还未获取过位置，请手动设置目的地。"),
                  RaisedButton(
                    onPressed: addNewLocal,
                    child: Text("设置目的地"),
                  ),
                ],
              ),
            )
          : ListView(
              padding: EdgeInsets.only(top: 8.0),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "请选择地址：",
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: addresses,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text("没有我要去的，手动添加"),
                      ),
                      FlatButton(
                        color: Colors.blueGrey,
                        child: Text(
                          "添加新地址",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: addNewLocal,
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }

  /// 添加新地址
  Future addNewLocal() async {
    Map marker = await Navigator.push(context,
        CupertinoPageRoute(builder: (context) => KeywordPoiSearchScreen()));
    var position = marker['position'].toJson();

    ///保存工程地址   [addressType] 地址添加方式，0手动添加，1获取签收位置
    await saveEppAddress(widget.eppCode, json.encode(marker), 0);
    callNavApp(position['latitude'], position['longitude']);
    _loadData();
  }

  /// 打开导航
  void callNavApp(double lat, double lon) async {
    AMapNavi().startNavi(
      lat: lat,
      lon: lon,
      naviType: AMapNavi.drive,
    );
//    var url =
//        "iosamap://navi?sourceApplication=applicationName&poiname=fangheng&poiid=BGVIS&lat=" +
//            lat.toString() +
//            "&lon=" +
//            lon.toString() +
//            "&dev=1&style=2";
//    if (Platform.isAndroid) {
//      url =
//          "androidamap://navi?sourceApplication=applicationName&poiname=fangheng&poiid=BGVIS&lat=" +
//              lat.toString() +
//              "&lon=" +
//              lon.toString() +
//              "&dev=1&style=2";
//    }
//
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {
//      Toast.show("本功能依赖高德地图app，请先安装高德地图app.");
//    }
  }
}
