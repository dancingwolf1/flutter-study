import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:flutter_spterp/util/public_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
import 'package:flutter_spterp/component/appbar.dart';
import 'package:flutter_spterp/component/input_filtrate/sidebar_input.dart';
import 'package:flutter_spterp/component/pop_page/index.dart';

class ContractAddGradePricePage extends StatefulWidget {
  ContractAddGradePricePage(this.contractUid, this.contractDetailCode);

  final String contractUid;
  final String contractDetailCode;

  @override
  ContractAddGradePricePageState createState() =>
      ContractAddGradePricePageState();
}

class ContractAddGradePricePageState extends State<ContractAddGradePricePage> {
  List<dynamic> _stgIds = [];
  bool isLoaded = false;
  int execTime = DateTime.now().millisecondsSinceEpoch;
  bool _isloading = false;
  bool isAllSelect = true; // 默认按钮为"全选"

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await _loadDate();
  }

  Future _loadDate() async {
    List<dynamic> stgIds = await getStgIdDropDown();

    setState(() {
      _stgIds = stgIds;
      isLoaded = true;
    });
  }

  ///选择输入框
  /// [control]输入抗控制器
  /// [title]输入框标题
  /// [hintText]输入框提示信息
  /// [select] 点击选择执行事件
  Widget selectInputBox(
    TextEditingController control, // 选择输入框控制器
    String title,
    String hintText,
    Function selectTop,
    Function onChanged,
  ) {
    return Container(
      height: ScreenUtil().setWidth(98),
      child: TextField(
        maxLines: 1,
        controller: control,
        enableInteractiveSelection: false,
        onTap: selectTop,
        onChanged: onChanged,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Text("$title",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                color: Color.fromRGBO(139, 137, 151, 1),
              )),
          hintStyle: TextStyle(
              fontSize: ScreenUtil().setSp(26),
              color: Color.fromRGBO(201, 199, 210, 1)),
          hintText: "$hintText",
        ),
      ),
      decoration: BoxDecoration(
        border: Border(
            bottom:
                BorderSide(width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.16))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "添加砼价格", isRightButton: false),
      body: isLoaded
          ? loading(
              _isloading,
              ListView(
                children: _listBuilder(),
              ))
          : loading(true, Container()),
      bottomNavigationBar: BottomAppBar(
        color: usePublicColor(9),
        child: Container(
          margin: EdgeInsets.only(
              bottom: ScreenUtil().setWidth(16),
              top: ScreenUtil().setWidth(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: ScreenUtil().setWidth(222),
                  height: ScreenUtil().setWidth(96),
                  decoration: BoxDecoration(
                    color: usePublicColor(7),
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(8)),
                  ),
                  child: Center(
                      child: Text(
                    "默认选择",
                    style: TextStyle(color: usePublicColor(6)),
                  )),
                ),
                onTap: () {
                  setState(() {
                    _stgIds.forEach((item) {
                      if (item['default']) {
                        item['selected'] = true;
                      }
                    });
                  });
                },
              ),
              isAllSelect
                  ? GestureDetector(
                      child: Container(
                        width: ScreenUtil().setWidth(222),
                        height: ScreenUtil().setWidth(96),
                        decoration: BoxDecoration(
                          color: usePublicColor(8),
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(8)),
                        ),
                        child: Center(
                            child: Text(
                          "全选",
                          style: TextStyle(color: usePublicColor(1)),
                        )),
                      ),
                      onTap: () {
                        setState(() {
                          isAllSelect = !isAllSelect;
                          _stgIds.forEach((item) {
                            item['selected'] = true;
                          });
                        });
                      },
                    )
                  : GestureDetector(
                      child: Container(
                        width: ScreenUtil().setWidth(222),
                        height: ScreenUtil().setWidth(96),
                        decoration: BoxDecoration(
                          color: usePublicColor(8),
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(8)),
                        ),
                        child: Center(
                            child: Text(
                          "全不选",
                          style: TextStyle(color: usePublicColor(1)),
                        )),
                      ),
                      onTap: () {
                        setState(() {
                          isAllSelect = !isAllSelect;
                          _stgIds.forEach((item) {
                            item['selected'] = false;
                          });
                        });
                      },
                    ),
              /*      GestureDetector(
                child: Container(
                  width: ScreenUtil().setWidth(222),
                  height: ScreenUtil().setWidth(96),
                  decoration: BoxDecoration(
                    color: usePublicColor(1),
                    borderRadius:
                    BorderRadius.circular(ScreenUtil().setWidth(8)),
                  ),
                  child: Center(
                      child: Text(
                        "全不选",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                onTap: () {
                  setState(() {
                    _stgIds.forEach((item) {
                      item['selected'] = false;
                    });
                  });
                },
              ),*/ // 全不选
              GestureDetector(
                child: Container(
                  width: ScreenUtil().setWidth(222),
                  height: ScreenUtil().setWidth(96),
                  decoration: BoxDecoration(
                    color: usePublicColor(1),
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(8)),
                  ),
                  child: Center(
                      child: Text(
                    "确定",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
                onTap: () async {
                  setState(() {
                    _isloading = true;
                  });
                  List<Map<String, dynamic>> selectedStgs = [];
                  _stgIds.forEach((item) {
                    if (item['selected'] != null && item['selected']) {
                      Map<String, dynamic> stg = {
                        "notPumpPrice": item['notPumpPrice'],
                        "pumpPrice": item['pumpPrice'],
                        "towerCranePrice": item['towerCranePrice'],
                        "stgId": item['stgId'],
                        "priceETime": execTime
                      };
                      selectedStgs.add(stg);
                    }
                  });
                  await saveContractGradePrice(widget.contractUid,
                      widget.contractDetailCode, json.encode(selectedStgs));
                  setState(() {
                    isLoaded = false;
                  });
                  Toast.show("编辑砼价格成功");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _listBuilder() {
    List<Widget> list = [];

    list.add(Container(
      height: 50,
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          onTapSelectTime(context, "选择执行时间", () {
            DatePicker.showDateTimePicker(context,
                showTitleActions: true,
                locale: LocaleType.zh, onConfirm: (date) {
              setState(() {
                execTime = date.millisecondsSinceEpoch;
              });
            });
          }, execTime, dateLength: 19),
/*          Expanded(
            child:
                Text("执行时间: ${DateTime.fromMillisecondsSinceEpoch(execTime)}"),
            flex: 2,
          ),
          Expanded(
              child: RaisedButton(
            onPressed: () {
              DatePicker.showDateTimePicker(context,
                  showTitleActions: true,
                  locale: LocaleType.zh, onConfirm: (date) {
                setState(() {
                  execTime = date.millisecondsSinceEpoch;
                });
              });
            },
            child: Text(
              "选择时间",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
          )),*/
        ],
      ),
    ));

    // 返回价格方式文字
    /// [title] 价格方式
    /// [value] 价格
    _getPrice(String title, String value) {
      return Column(
        children: <Widget>[
          Text("$title",
              style: TextStyle(
                  fontSize: ScreenUtil().setWidth(26),
                  color: Color.fromRGBO(139, 137, 151, 1))),
          SizedBox(
            height: ScreenUtil().setWidth(12),
          ),
          Text("${value}",
              style: TextStyle(
                  fontSize: ScreenUtil().setWidth(26),
                  color: Color.fromRGBO(59, 57, 73, 1))),
        ],
      );
    }

    _stgIds.forEach((item) {
      list.add(Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(8)),
        ),
        padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(12),
            right: ScreenUtil().setWidth(12),
            bottom: ScreenUtil().setWidth(12)),
        margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(10),
            right: ScreenUtil().setWidth(24),
            left: ScreenUtil().setWidth(24),
            bottom: ScreenUtil().setWidth(10)),
        child: Row(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(102),
              child: Center(
                child: Radio<int>(
                    // 1是未选中 0 选中
                    value: item['selected'] == null
                        ? 1
                        : item['selected'] == false ? 1 : 0,
                    groupValue: 0,
                    onChanged: (v) {
                      setState(() {
                        item['selected'] =
                            item['selected'] == null ? true : !item['selected'];
                      });
                    }),
              ),
            ),
            Expanded(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(16)),
                ),
                Row(children: <Widget>[
                  Text("${item['stgId']}",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(32),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left)
                ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _getPrice("非泵", item['notPumpPrice'].toString()),
                      _getPrice("泵送", item['pumpPrice'].toString()),
                      _getPrice("塔吊", item['towerCranePrice'].toString()),
                    ]),
              ],
            )),
            Container(
              width: ScreenUtil().setWidth(194),
              child: Center(
                  child: GestureDetector(
                      child: Image.asset("images/paper_edit.png"),
                      onTap: () {
                        double _notPumpPrice = item['notPumpPrice'];
                        double _pumpPrice = item['pumpPrice'];
                        double _towerCranePrice = item['towerCranePrice'];
                        TextEditingController _notPumpPriceController =
                            new TextEditingController();
                        TextEditingController _pumpPriceController =
                            new TextEditingController();
                        TextEditingController _towerCranePriceController =
                            new TextEditingController();
                        setState(() {
                          _notPumpPriceController.text =
                              _notPumpPrice.toString();
                          _pumpPriceController.text = _pumpPrice.toString();
                          _towerCranePriceController.text =
                              _towerCranePrice.toString();
                        });
                        popPage(
                            context,
                            Container(
                              height: 250,
                              child: Column(children: <Widget>[
                                Container(
//                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      selectInputBox(_notPumpPriceController,
                                          "非泵价", "非泵价格", () {}, (val) {
                                        _notPumpPrice = double.parse(val);
                                      }),
                                      selectInputBox(_pumpPriceController,
                                          "非泵价", "非泵价格", () {}, (val) {
                                        _pumpPrice = double.parse(val);
                                      }),
                                      selectInputBox(_towerCranePriceController,
                                          "塔吊价", "塔吊价格", () {}, (val) {
                                        _towerCranePrice = double.parse(val);
                                      }),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setWidth(40),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Container(
                                        width: ScreenUtil().setWidth(200),
                                        height: ScreenUtil().setWidth(80),
                                        decoration: BoxDecoration(
                                          color: usePublicColor(1),
                                          borderRadius: BorderRadius.circular(
                                              ScreenUtil().setWidth(8)),
                                        ),
                                        child: Center(
                                            child: Text(
                                          "确定",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                      ),
                                 /*     onTap: () async {
                                        Navigator.pop(context);
                                      },*/
                                        onTap: () {
                                          setState(() {
                                            item['notPumpPrice'] = _notPumpPrice;
                                            item['pumpPrice'] = _pumpPrice;
                                            item['towerCranePrice'] =
                                                _towerCranePrice;
                                          });
                                          Navigator.pop(context);
                                        }
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        width: ScreenUtil().setWidth(200),
                                        height: ScreenUtil().setWidth(80),
                                        decoration: BoxDecoration(
                                          color: usePublicColor(8),
                                          borderRadius: BorderRadius.circular(
                                              ScreenUtil().setWidth(8)),
                                        ),
                                        child: Center(
                                            child: Text(
                                          "取消",
                                          style: TextStyle(
                                              color: usePublicColor(1)),
                                        )),
                                      ),
                                        onTap: () async {
                                          Navigator.pop(context);
                                        }
                              /*        onTap: () {
                                        setState(() {
                                          item['notPumpPrice'] = _notPumpPrice;
                                          item['pumpPrice'] = _pumpPrice;
                                          item['towerCranePrice'] =
                                              _towerCranePrice;
                                        });
                                        Navigator.pop(context);
                                      },*/
                                    ),
                                    /*       FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        '取消',
                                        style: TextStyle(
                                            color: Colors.blue),
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          item['notPumpPrice'] =
                                              _notPumpPrice;
                                          item['pumpPrice'] =
                                              _pumpPrice;
                                          item['towerCranePrice'] =
                                              _towerCranePrice;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text('确认',
                                          style: TextStyle(
                                              color: Colors.blue)),
                                    )*/
                                  ],
                                )
                              ]),
                            ),
                            "${item['stgId']}",
                            radio: ScreenUtil().setWidth(20));
                      })),
            ),
          ],
        ),
      ));
    });
    return list;
  }
}
