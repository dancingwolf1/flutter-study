import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
import 'package:flutter_spterp/pages/home/circular_graph.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spterp/pages/home/index_tool.dart';
import 'package:flutter_spterp/util/contorl_date.dart';
import 'package:flutter_spterp/pages/home/barView.dart';
import 'package:flutter_spterp/util/adaptive.dart';
import 'package:flutter_spterp/component/appbar.dart';
import 'package:flutter_spterp/component/input.dart';
import 'package:flutter_spterp/component/button/raised_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
import 'package:flutter_spterp/util/adaptive.dart';

class SelectConstructionAdd extends StatefulWidget {
  @override
  SelectConstructionAddState createState() => SelectConstructionAddState();
}

class SelectConstructionAddState extends State<SelectConstructionAdd> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController _selectedConstructionController; // 施工单位全程
  TextEditingController _selectedAbbreviationController; // 施工单位简称
  TextEditingController _selectedAddressController; // 施工单位地址
  TextEditingController _selectedLegalPersonController; // 法人
  TextEditingController _selectedfaxController; // 传真
  TextEditingController _selectedphoneController; // 联系电话

  String construction = "";
  String abbreviation = "";
  String address = "";
  String legalPerson = "";
  String fax = "";
  String phone = "";

  @override
  void initState() {
    super.initState();
    _selectedConstructionController = new TextEditingController(); // 工程名全程
    _selectedAbbreviationController = new TextEditingController(); // 工程名简称
    _selectedAddressController = new TextEditingController(); // 工程地址
    _selectedLegalPersonController = new TextEditingController(); // 工程联系人
    _selectedphoneController = new TextEditingController(); // 联系电话
    _selectedphoneController = new TextEditingController(); // 手机号
  }

  @override
  Widget build(BuildContext context) {
    adaptation(context); //适配
    return Scaffold(
      key: _scaffoldKey,
     appBar: getAppBar(context, "编辑施工单位", isRightButton: false),

      body: Form(
          key: _formKey,
          autovalidate: true,
          child: ListView(
            padding: EdgeInsets.all(8.0),
            children: <Widget>[
              inputWrite("施工单位全称", (value) {
                setState(() {
                  construction = value;
                });
              },inputControl: _selectedConstructionController),
              inputWrite("施工单位简称", (value) {
                setState(() {
                  abbreviation = value;
                });
              },inputControl: _selectedAbbreviationController),
              inputWrite("施工单位地址", (value) {
                setState(() {
                  address = value;
                });
              },inputControl: _selectedAddressController),
              inputWrite("法人", (value) {
                setState(() {
                  legalPerson = value;
                });
              },inputControl: _selectedLegalPersonController),
              inputWrite("传真", (value) {
                setState(() {
                  fax = value;
                });
              },inputControl: _selectedfaxController),
              inputWrite("联系电话", (value) {
                setState(() {
                  phone = value;
                });
              },inputControl: _selectedphoneController),
              Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(60),
                  right: ScreenUtil().setWidth(14),
                  left: ScreenUtil().setWidth(14),
                ),
                height: ScreenUtil().setWidth(96),
                width: ScreenUtil().setWidth(700),
                child: getRaisedButton("确认",saveSend,Colors.blueAccent,borderRadius:ScreenUtil().setWidth(8)),
              ),
            ],
          )),
    );
  }

  // 保存并发送方法
  Future saveSend() async {
    // 验证必选项
    if (construction.length <= 0) {
      Toast.show("请输入施工单位全称");
      return;
    }
    if (abbreviation.length <= 0) {
      Toast.show("请输入施工单位简称");
      return;
    }
    await addConstructionUnit(
        builderName: construction,
        builderShortName: abbreviation,
        address: address,
        corporation: legalPerson,
        fax: fax,
        linkTel: phone);

    Toast.show("添加施工单位成功");
    Navigator.pop(context);
  }
}
