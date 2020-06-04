import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:flutter_spterp/component/appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
import 'package:flutter_spterp/util/public_color.dart';

class ContractAddPriceMarkUpPage extends StatefulWidget {
  ContractAddPriceMarkUpPage(this.contractUid, this.contractDetailCode);

  final String contractUid;
  final String contractDetailCode;

  @override
  ContractAddPriceMarkUpPageState createState() =>
      ContractAddPriceMarkUpPageState();
}

class ContractAddPriceMarkUpPageState
    extends State<ContractAddPriceMarkUpPage> {
  bool isLoaded = false;
  List<dynamic> _priceMarkUps = [];
  bool _loading = false;
  bool isAllSelect = true; // 默认按钮为"全选"

  @override
  void initState() {
    super.initState();
    _loadDate();
  }

  Future _loadDate() async {
    List<dynamic> priceMarkUps = await getPriceMarkupDropDown();
    setState(() {
      _priceMarkUps = priceMarkUps;
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "合同特殊材料", isRightButton: false),
      /*     AppBar(
        title: Text("合同特殊材料"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "确定",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              setState(() {
                _loading = true;
              });
              List<Map<String, dynamic>> selectedStgs = [];
              _priceMarkUps.forEach((item) {
                if (item['selected'] != null && item['selected']) {
                  Map<String, dynamic> stg = {
                    "pName": item['pname'],
                    "pCode": item['pcode'],
                    "unitPrice": item['unitPrice'],
                    "jumpPrice": item['jumpPrice'],
                    "selfDiscPrice": item['selfDiscPrice'],
                    "towerCranePrice": item['towerCranePrice'],
                    "otherPrice": item['otherPrice'],
                    "isDefault": item['isDefault']
                  };

                  selectedStgs.add(stg);
                }
              });
              await saveContractPriceMarkup(widget.contractUid,
                  widget.contractDetailCode, json.encode(selectedStgs));
              setState(() {
                _loading = false;
              });
              Toast.show("编辑特殊材料成功！");
              Navigator.pop(context);
            },
          )
        ],
      ),*/
      body: isLoaded
          ? loading(
              _loading,
              ListView(
                children: _listBuilder(),
              ))
          : Container(),
      bottomNavigationBar: BottomAppBar(
//        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(16),top: ScreenUtil().setWidth(16)),
        child: Container(
          margin: EdgeInsets.only(
              bottom: ScreenUtil().setWidth(16),
              top: ScreenUtil().setWidth(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              /*     Expanded(
              child: Container(
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _priceMarkUps.forEach((item) {
                        if (item['default']) {
                          item['selected'] = true;
                        } else {
                          item['selected'] = false;
                        }
                      });
                    });
                  },
                  child: Text(
                    "选择默认",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Container(
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _priceMarkUps.forEach((item) {
                        item['selected'] = true;
                      });
                    });
                  },
                  child: Text(
                    "全选",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Container(
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _priceMarkUps.forEach((item) {
                        item['selected'] = false;
                      });
                    });
                  },
                  child: Text(
                    "全不选",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                color: Colors.white,
              ),
            ),*/
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

                    _priceMarkUps.forEach((item) {
                      if (item['default']) {
                        item['selected'] = true;
                      } else {
                        item['selected'] = false;
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
                          isAllSelect = ! isAllSelect;
                          _priceMarkUps.forEach((item) {
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
                        isAllSelect = ! isAllSelect;
                        setState(() {
                          _priceMarkUps.forEach((item) {
                            item['selected'] = false;
                          });
                        });
                      },
                    ),
              /*      GestureDetector( // 全不选
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
              onTap:  () {
                setState(() {
                  _priceMarkUps.forEach((item) {
                    item['selected'] = false;
                  });
                });
              },
            ),*/
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
                    _loading = true;
                  });
                  List<Map<String, dynamic>> selectedStgs = [];
                  _priceMarkUps.forEach((item) {
                    if (item['selected'] != null && item['selected']) {
                      Map<String, dynamic> stg = {
                        "pName": item['pname'],
                        "pCode": item['pcode'],
                        "unitPrice": item['unitPrice'],
                        "jumpPrice": item['jumpPrice'],
                        "selfDiscPrice": item['selfDiscPrice'],
                        "towerCranePrice": item['towerCranePrice'],
                        "otherPrice": item['otherPrice'],
                        "isDefault": item['isDefault']
                      };

                      selectedStgs.add(stg);
                    }
                  });
                  await saveContractPriceMarkup(widget.contractUid,
                      widget.contractDetailCode, json.encode(selectedStgs));
                  setState(() {
                    _loading = false;
                  });
                  Toast.show("编辑特殊材料成功！");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  List<Widget> _listBuilder() {
    List<Widget> list = [];

    _priceMarkUps.forEach((item) {
      list.add(

          /*    CheckboxListTile(
          onChanged: (value) {
            setState(() {
              item['selected'] =
              item['selected'] == null ? true : !item['selected'];
            });
          },
          title: Text("${item['pname']}"),
          subtitle: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                    "自卸:${item['selfDiscPrice']}   塔吊:${item['towerCranePrice']} "
                        "单价: ${item['unitPrice']}   泵送: ${item['jumpPrice']}"),
              ),
            ],
          ),
          value: item['selected'] == null ? false : item['selected'],
          controlAffinity: ListTileControlAffinity.leading
      ),*/
          Container(
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
                  Text("${item['pname']}",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(32),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left)
                ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _getPrice("自卸", item['selfDiscPrice'].toString()),
                      _getPrice("塔吊", item['towerCranePrice'].toString()),
                      _getPrice("单价", item['unitPrice'].toString()),
                      _getPrice("泵送", item['jumpPrice'].toString()),
                    ]),
              ],
            )),
            Container(
              width: ScreenUtil().setWidth(194),
              child: Center(),
            ),
          ],
        ),
      ));
    });
    return list;
  }
}
