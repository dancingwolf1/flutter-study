import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/pages/contract/contract_add_distance.dart';
import 'package:flutter_spterp/pages/contract/contract_add_pump_price.dart';
import 'package:flutter_spterp/pages/contract/contract_add_grade_price.dart';
import 'contract_add_price_markup.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:flutter_spterp/component/value_perocessor.dart';
import 'package:flutter_spterp/util/adaptive.dart';
import 'package:flutter_spterp/util/public_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
import 'package:flutter_spterp/component/appbar.dart';
import 'package:flutter_spterp/component/list/list_page.dart';

class ContractPriceDetailPage extends StatefulWidget {
  ContractPriceDetailPage({this.contractUid, this.contractDetailCode})
      : super();
  final String contractUid;
  final String contractDetailCode;

  @override
  ContractPriceDetailPageState createState() => ContractPriceDetailPageState();
}

class ContractPriceDetailPageState extends State<ContractPriceDetailPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<dynamic> _contractGradePriceDate = [];
  List<dynamic> _contractPriceMarkupDate = [];
  List<dynamic> _contractPumpPriceDate = [];
  List<dynamic> _contractDistanceSetDate = [];

  bool isLoadedContractGradePriceDate = false;
  bool isLoadedContractPriceMarkupDate = false;
  bool isLoadedContractPumpPriceDate = false;
  bool isLoadedContractDistanceSetDate = false;

  double tableRowIndex = 0; // 表格行数

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);
    _getDate(1);
    _getDate(2);
    _getDate(3);
    _getDate(4);
  }

  void init() {
    _getDate(1);
    _getDate(2);
    _getDate(3);
    _getDate(4);
  }

  _getDate(int type) async {
    if (type == 1) {
      List<dynamic> contractGradePriceDate = await getContractGradePrice(
          widget.contractUid, widget.contractDetailCode);
      setState(() {
        _contractGradePriceDate = contractGradePriceDate;
        isLoadedContractGradePriceDate = true;
      });
    }
    if (type == 2) {
      List<dynamic> contractPriceMarkup = await getContractPriceMarkup(
          widget.contractUid, widget.contractDetailCode);
      setState(() {
        _contractPriceMarkupDate = contractPriceMarkup;
        isLoadedContractPriceMarkupDate = true;
      });
    }
    if (type == 3) {
      List<dynamic> contractPumpPrice = await getContractPumpPrice(
          widget.contractUid, widget.contractDetailCode);
      setState(() {
        _contractPumpPriceDate = contractPumpPrice;
        isLoadedContractPumpPriceDate = true;
      });
    }
    if (type == 4) {
      List<dynamic> contractDistanceSetDate = await getContractDistanceSet(
          widget.contractUid, widget.contractDetailCode);
      setState(() {
        _contractDistanceSetDate = contractDistanceSetDate;
        isLoadedContractDistanceSetDate = true;
      });
    }
  }

  /// 每行的小组件

  TableRow _contractGradePriceItemWidget(contractGradePriceItem) {
    tableRowIndex++;
    Color rowBgColor = Colors.white;
    if (tableRowIndex % 2 != 0) {
      // 为偶数
      rowBgColor = Color.fromRGBO(53, 134, 249, 0.06);
    }
    return TableRow(
        decoration: BoxDecoration(
          color: rowBgColor,
        ),
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(24)),
            height: ScreenUtil().setWidth(64),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(valueProcessor(contractGradePriceItem['stgId'])),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(24)),
            height: ScreenUtil().setWidth(64),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                  valueProcessor(
                      contractGradePriceItem['pumpPrice'].toString()),
                  textAlign: TextAlign.right),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(24)),
            height: ScreenUtil().setWidth(64),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                  valueProcessor(
                      contractGradePriceItem['notPumpPrice'].toString()),
                  textAlign: TextAlign.right),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(24)),
            height: ScreenUtil().setWidth(64),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                  valueProcessor(
                      contractGradePriceItem['towerCranePrice'].toString()),
                  textAlign: TextAlign.right),
            ),
          ),
        ]);
  }

  // card1 卡片的头部
  _getCardTop(var contract) {
    return Row(
      children: <Widget>[
        Container(
          width: ScreenUtil().setWidth(4),
          height: ScreenUtil().setWidth(32),
          color: usePublicColor(1),
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(26)),
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Text(
                contract['pname'] == null ? "" : contract['pname'],
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(30),
                    height: 1,
                    color: usePublicColor(3),
                    fontWeight: FontWeight.w800),
              ),
                SizedBox(
                  width: ScreenUtil().setWidth(32),
                ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "单价:  ",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(26),
                          color: Color.fromRGBO(139, 137, 151, 1))),
                  TextSpan(
                      text: "${contract['unitPrice']}",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(26),
                          color: Color.fromRGBO(59, 57, 73, 1),
                          fontWeight: FontWeight.w700)),
                ]),
              ),
            ],
          ),
        ),
        /*   Container(
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(22)),
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(16),
              ScreenUtil().setWidth(6),
              ScreenUtil().setWidth(16),
              ScreenUtil().setWidth(6)),
          child: Text(
            "$contractStatus",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(20),
                fontWeight: FontWeight.w700,
                color: contractStatus != "未审核"
                    ? usePublicColor(5)
                    : usePublicColor(6)),
          ),
          decoration: BoxDecoration(
              color: contractStatus != "未审核"
                  ? usePublicColor(4)
                  : usePublicColor(7),
              borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8)))),
        )*/
      ],
    );
  }

  // card2 卡片的头部
  _getCardTopThirdly(var contract) {
    return Row(
      children: <Widget>[
        Container(
          width: ScreenUtil().setWidth(4),
          height: ScreenUtil().setWidth(32),
          color: usePublicColor(1),
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(26)),
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Text(
                contract['pumpTypeName'] == null
                    ? ""
                    : contract['pumpTypeName'],
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(30),
                    height: 1,
                    color: usePublicColor(3),
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(32),
              ),

            ],
          ),
        ),
        /*   Container(
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(22)),
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(16),
              ScreenUtil().setWidth(6),
              ScreenUtil().setWidth(16),
              ScreenUtil().setWidth(6)),
          child: Text(
            "$contractStatus",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(20),
                fontWeight: FontWeight.w700,
                color: contractStatus != "未审核"
                    ? usePublicColor(5)
                    : usePublicColor(6)),
          ),
          decoration: BoxDecoration(
              color: contractStatus != "未审核"
                  ? usePublicColor(4)
                  : usePublicColor(7),
              borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8)))),
        )*/
      ],
    );
  }
  // card3 卡片的头部
  _getCardTopFour(var contract) {
    return Row(
      children: <Widget>[
        Container(
          width: ScreenUtil().setWidth(4),
          height: ScreenUtil().setWidth(32),
          color: usePublicColor(1),
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(26)),
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Text(
                contract['compName'] == null
                    ? ""
                    : contract['compName'],
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(30),
                    height: 1,
                    color: usePublicColor(3),
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(32),
              ),

            ],
          ),
        ),
        /*   Container(
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(22)),
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(16),
              ScreenUtil().setWidth(6),
              ScreenUtil().setWidth(16),
              ScreenUtil().setWidth(6)),
          child: Text(
            "$contractStatus",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(20),
                fontWeight: FontWeight.w700,
                color: contractStatus != "未审核"
                    ? usePublicColor(5)
                    : usePublicColor(6)),
          ),
          decoration: BoxDecoration(
              color: contractStatus != "未审核"
                  ? usePublicColor(4)
                  : usePublicColor(7),
              borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8)))),
        )*/
      ],
    );
  }

  Widget _contractPriceMarkupItemWidget(contractPriceMarkupItem) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((ScreenUtil().setWidth(8))),
          color: Colors.white,
        ),
        margin: EdgeInsets.only(
            right: ScreenUtil().setWidth(24),
            left: ScreenUtil().setWidth(24),
            top: ScreenUtil().setWidth(20)),
        child: Column(children: <Widget>[
          SizedBox(
            height: ScreenUtil().setWidth(14),
          ),
          _getCardTop(contractPriceMarkupItem),
          SizedBox(
            height: ScreenUtil().setWidth(16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "泵送价",
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(26),
                        color: Color.fromRGBO(139, 137, 151, 1)),
                  ),
                  SizedBox(height: ScreenUtil().setWidth(12)),
                  Text(
                    contractPriceMarkupItem['jumpPrice'].toString(),
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(26),
                        color: Color.fromRGBO(59, 57, 73, 1),
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text("自卸价",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(26),
                          color: Color.fromRGBO(139, 137, 151, 1))),
                  SizedBox(height: ScreenUtil().setWidth(12)),
                  Text(contractPriceMarkupItem['towerCranePrice'].toString(),
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(26),
                          color: Color.fromRGBO(59, 57, 73, 1),
                          fontWeight: FontWeight.w700)),
                ],
              ),
              Column(
                children: <Widget>[
                  Text("塔吊价",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(26),
                          color: Color.fromRGBO(139, 137, 151, 1))),
                  SizedBox(height: ScreenUtil().setWidth(12)),
                  Text(contractPriceMarkupItem['selfDiscPrice'].toString(),
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(26),
                          color: Color.fromRGBO(59, 57, 73, 1),
                          fontWeight: FontWeight.w700)),
                ],
              ),

              Column(
                children: <Widget>[
                  Text("其他价",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(26),
                          color: Color.fromRGBO(139, 137, 151, 1))),
                  SizedBox(height: ScreenUtil().setWidth(12)),
                  Text(contractPriceMarkupItem['otherPrice'].toString(),
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(26),
                          color: Color.fromRGBO(59, 57, 73, 1),
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setWidth(24),
          ),
        ]),
      );

/*  Widget _contractPumpPriceItemWidget(contractPumpPriceItem) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((ScreenUtil().setWidth(8))),
          color: Colors.white,
        ),
        margin: EdgeInsets.only(
            right: ScreenUtil().setWidth(24),
            left: ScreenUtil().setWidth(24),
            top: ScreenUtil().setWidth(20)),
        child: Column(children: <Widget>[
          SizedBox(
            height: ScreenUtil().setWidth(24),
          ),
          _getCardTopThirdly(contractPumpPriceItem),
          SizedBox(
            height: ScreenUtil().setWidth(16),
          ),
          Row(children: <Widget>[
            Expanded(
              child: Padding(child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "泵送价格:  ",
                      style: TextStyle(
                          color: Color.fromRGBO(139, 137, 151, 1),
                          fontSize: ScreenUtil().setSp(24)),
                    ),
                    TextSpan(
                      text: "${contractPumpPriceItem['pumpPrice']}",
                      style: TextStyle(
                          color: Color.fromRGBO(139, 137, 151, 1),
                          fontSize: ScreenUtil().setSp(30)),
                    ),
                  ],
                ),
              ),padding:EdgeInsets.only(left: ScreenUtil().setSp(36))),
            ),
            Expanded(
              child: Padding(
                padding:EdgeInsets.only(left: ScreenUtil().setSp(36)),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "台班费:  ",
                        style: TextStyle(
                            color: Color.fromRGBO(139, 137, 151, 1),
                            fontSize: ScreenUtil().setSp(24)),
                      ),
                      TextSpan(
                        text: "${contractPumpPriceItem['tableExpense']}",
                        style: TextStyle(
                            color: Color.fromRGBO(139, 137, 151, 1),
                            fontSize: ScreenUtil().setSp(30)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
          SizedBox(
            height: ScreenUtil().setWidth(16),
          ),
        ]),
      );*/
  Widget _contractPumpPriceItemWidget(contractPumpPriceItem) => listCard(
    "${contractPumpPriceItem['pumpTypeName']}",
      (){},
      Row(children: <Widget>[
        Expanded(
          child: Padding(child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "泵送价格:  ",
                  style: TextStyle(
                      color: Color.fromRGBO(139, 137, 151, 1),
                      fontSize: ScreenUtil().setSp(24)),
                ),
                TextSpan(
                  text: "${contractPumpPriceItem['pumpPrice']}",
                  style: TextStyle(
                      color: Color.fromRGBO(139, 137, 151, 1),
                      fontSize: ScreenUtil().setSp(30)),
                ),
              ],
            ),
          ),padding:EdgeInsets.only(left: ScreenUtil().setSp(36))),
        ),
        Expanded(
          child: Padding(
            padding:EdgeInsets.only(left: ScreenUtil().setSp(36)),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "台班费:  ",
                    style: TextStyle(
                        color: Color.fromRGBO(139, 137, 151, 1),
                        fontSize: ScreenUtil().setSp(24)),
                  ),
                  TextSpan(
                    text: "${contractPumpPriceItem['tableExpense']}",
                    style: TextStyle(
                        color: Color.fromRGBO(139, 137, 151, 1),
                        fontSize: ScreenUtil().setSp(30)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),

  );


  Widget _contractDistanceSetItemWidget(contractDistanceSetItem) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((ScreenUtil().setWidth(8))),
          color: Colors.white,
        ),
        margin: EdgeInsets.only(
            right: ScreenUtil().setWidth(24),
            left: ScreenUtil().setWidth(24),
            top: ScreenUtil().setWidth(20)),
        child: Column(children: <Widget>[
          SizedBox(
            height: ScreenUtil().setWidth(24),
          ),
          _getCardTopFour(contractDistanceSetItem),

          SizedBox(
            height: ScreenUtil().setWidth(16),
          ),
          Row(children: <Widget>[

            Expanded(
              child: Padding(
                padding:EdgeInsets.only(left: ScreenUtil().setSp(36)),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "运输距离:  ",
                        style: TextStyle(
                            color: Color.fromRGBO(139, 137, 151, 1),
                            fontSize: ScreenUtil().setSp(24)),
                      ),
                      TextSpan(
                        text: "${contractDistanceSetItem['distance']}km",
                        style: TextStyle(
                            color: Color.fromRGBO(139, 137, 151, 1),
                            fontSize: ScreenUtil().setSp(30)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
          SizedBox(
            height: ScreenUtil().setWidth(16),
          ),
        ]),
      );
      /*Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              contentRowViewPublic(
                  "站点", "${contractDistanceSetItem['compName']}"),
              contentRowViewPublic(
                  "运距", "${contractDistanceSetItem['distance']}"),
            ],
          ),
        ),
      );*/

  /// 价格组件
  Widget contractPriceWidget(int type) {
    if (type == 1) {
      // 按时间划分map
      Map<String, List> _gradePriceDate = new Map();
      for (Map<String, dynamic> _item in _contractGradePriceDate) {
        String beginTime = _item['priceExecuteTime'];
        if (_gradePriceDate[beginTime] == null) {
          _gradePriceDate[beginTime] = new List();
        }
        _gradePriceDate[beginTime].add(_item);
      }
      List<Widget> cards = [];
      _gradePriceDate.forEach((beginTime, listDate) {
        List<TableRow> tableRows = [];
        TextStyle thStyle = TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(26),
          color: usePublicColor(3),
        );
        tableRows.add(TableRow(
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.16))),
              color: Colors.white,
            ),
            children: [
              Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(24)),
                child: Text("砼标号", style: thStyle),
              ),
              Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(24)),
                child: Text("非泵价", style: thStyle, textAlign: TextAlign.right),
              ),
              Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(24)),
                child: Text("泵送价", style: thStyle, textAlign: TextAlign.right),
              ),
              Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(24)),
                child: Text("塔吊价", style: thStyle, textAlign: TextAlign.right),
              ),
            ]));
        tableRows.addAll(listDate
            .map((itemDate) => _contractGradePriceItemWidget(itemDate))
            .toList());

        cards.add(Container(
          child: Column(
            children: <Widget>[
              /*   ListTile(
                title: Text("执行时间：${valueProcessor(beginTime)}",textAlign: TextAlign.center,),
              ),*/
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setWidth(16),
                        left: ScreenUtil().setWidth(16),
                        right: ScreenUtil().setWidth(16),
                        bottom: ScreenUtil().setWidth(16)),
                    child: Text(
                      "执行时间：${valueProcessor(beginTime)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(26),
                          color: usePublicColor(1)),
                    ),
                  ),
                ],
              ),
              Table(
                columnWidths: {
                  0: FixedColumnWidth(180),
                },
                children: tableRows,
              )
            ],
          ),
        ));
      });

      return ListView(
        children: cards,
      );
    }
    if (type == 2) {
      return ListView(
        children: _contractPriceMarkupDate
            .map((itemDate) => _contractPriceMarkupItemWidget(itemDate))
            .toList(),
      );
    }
    if (type == 3) {
      return ListView(
        children: _contractPumpPriceDate
            .map((itemDate) => _contractPumpPriceItemWidget(itemDate))
            .toList(),
      );
    }
    if (type == 4) {
      return ListView(
        children: _contractDistanceSetDate
            .map((itemDate) => _contractDistanceSetItemWidget(itemDate))
            .toList(),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    adaptation(context);
    return Scaffold(
      appBar: getAppBar(context, "价格明细",
          bottomWidget: TabBar(
              controller: _tabController,
              labelColor: Color.fromRGBO(50, 150, 250, 1),
              unselectedLabelColor: Color.fromRGBO(139, 137, 151, 1),
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
                  fontWeight: FontWeight.w700),
              tabs: [
                Tab(
                  child: Text("砼价格"),
                ),
                Tab(
                  child: Text("特殊材料"),
                ),
                Tab(
                  child: Text("泵车价格"),
                ),
                Tab(
                  child: Text("合同运距"),
                ),
              ]),
          isRightButton: false),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            color: Colors.blue,
          ),
          onPressed: () async {
            if (_tabController.index == 0) {
              await Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ContractAddGradePricePage(
                          widget.contractUid, widget.contractDetailCode)));
            }
            if (_tabController.index == 1) {
              await Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ContractAddPriceMarkUpPage(
                          widget.contractUid, widget.contractDetailCode)));
            }
            if (_tabController.index == 2) {
              await Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ContractAddPumpPricePage(
                          widget.contractUid, widget.contractDetailCode)));
            }
            if (_tabController.index == 3) {
              await Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ContractAddDistancePage(
                          widget.contractUid, widget.contractDetailCode)));
            }
            setState(() {
              init();
            });
          }),
      body: TabBarView(controller: _tabController, children: [
        isLoadedContractGradePriceDate
            ? contractPriceWidget(1)
            : loading(true, Container()),
        isLoadedContractPriceMarkupDate
            ? contractPriceWidget(2)
            : loading(true, Container()),
        isLoadedContractPumpPriceDate
            ? contractPriceWidget(3)
            : loading(true, Container()),
        isLoadedContractDistanceSetDate
            ? contractPriceWidget(4)
            : loading(true, Container()),
      ]),
    );
  }
}
