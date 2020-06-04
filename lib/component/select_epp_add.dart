import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/appbar.dart';
import 'package:flutter_spterp/component/input.dart';
import 'package:flutter_spterp/component/button/raised_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
import 'package:flutter_spterp/util/adaptive.dart';

class SelectEppAdd extends StatefulWidget {
  @override
  SelectEppAddState createState() => SelectEppAddState();
}

class SelectEppAddState extends State<SelectEppAdd> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController _selectedFullNameController; // 工程名全程
  TextEditingController _selectedAbbreviationController; // 工程名简称
  TextEditingController _selectedAddressController; // 工程地址
  TextEditingController _selectedContaceController; // 工程联系人
  TextEditingController _selectedPhoneController; // 联系电话
  TextEditingController _selectedRemarksController; // 备注

  String fullName = "";
  String addreviation = "";
  String address = "";
  String contace = "";
  String phone = "";
  String remarks = "";

  @override
  void initState() {
    super.initState();
    _selectedFullNameController = new TextEditingController(); // 工程名全程
    _selectedAbbreviationController = new TextEditingController(); // 工程名简称
    _selectedAddressController = new TextEditingController(); // 工程地址
    _selectedContaceController = new TextEditingController(); // 工程联系人
    _selectedPhoneController = new TextEditingController(); // 联系电话
    _selectedRemarksController = new TextEditingController(); // 备注
  }

  @override
  Widget build(BuildContext context) {
    adaptation(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: getAppBar(context, "编辑工程名称", isRightButton: false),
      body: Form(
          key: _formKey,
          autovalidate: true,
          child: ListView(
            padding: EdgeInsets.only(top: 8.0),
            children: <Widget>[
              inputWrite("工程名全称", (value) {
                setState(() {
                  fullName = value;
                });
              }),
              inputWrite("工程名简称", (value) {
                setState(() {
                  addreviation = value;
                });
              }),
              inputWrite("工程地址", (value) {
                setState(() {
                  address = value;
                });
              }),
              inputWrite("工程联系人", (value) {
                setState(() {
                  contace = value;
                });
              }),
              inputWrite("联系电话", (value) {
                setState(() {
                  contace = value;
                });
              }),
              textArea(_selectedRemarksController, (value) {
                setState(() {
                  remarks = value;
                });
              }, 3),
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
    if (fullName.length <= 0) {
      Toast.show("请输入工程名全称");
      return;
    }
    if (addreviation.length <= 0) {
      Toast.show("请输入工程名简称");
      return;
    }

    await addEppName(
        eppName: fullName,
        shortName: addreviation,
        address: address,
        linkMan: contace,
        linkTel: phone,
        remarks: remarks);
    Toast.show("添加工程名称信息成功");
    Navigator.pop(context);
  }
}
