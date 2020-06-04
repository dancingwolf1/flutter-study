import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spterp/util/user_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spterp/component/list_info.dart';

class UserPage extends StatefulWidget {
  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  List<Map<String, dynamic>> dataList = [];
  bool loadOk = true;
  Map<String, dynamic> selectedEnterprise = {};
  Map<String, dynamic> user = {};

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _getUser();
    setState(() {
      loadOk = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('个人信息')),
      body: loadOk
          ? SingleChildScrollView(
              child: Column(
                children: <Widget>[_shortcutMenu()],
              ),
            )
          : Container(),
    );
  }

  _shortcutMenu() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            contentRowViewPublic("用  户  名", user['username']),
            contentRowViewPublic("手  机  号", user['phone']),
            contentRowViewPublic("邮        箱", user['email']),
            contentRowViewPublic("所属企业", selectedEnterprise['epShortName']),
          ],
        ),
      ),
    );
  }

  Future _getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String enterpriseStr = pref.getString("selectedEnterprise");
    if (enterpriseStr == null || enterpriseStr == "") {
      Map<String, dynamic> userMap = await getUser();// 如果未选择就获取第一个
      enterpriseStr = json.encode(userMap['enterprises'][0]);
    }
    String str = pref.getString("user");
    setState(() {
      user = json.decode(str);//  把用户信息赋值到user；
      selectedEnterprise = json.decode(enterpriseStr);// 把企业信息赋值到selectedEnterprise；
    });
  }
}
