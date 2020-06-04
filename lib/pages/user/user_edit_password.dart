import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPasswordPage extends StatefulWidget {
  @override
  UserPasswordPageState createState() => UserPasswordPageState();
}

class UserPasswordPageState extends State<UserPasswordPage> {
  Map<String, dynamic> user = {};

  bool showPassword = true;
  String token = "";
  String oldPassword = "";
  String newPassword = "";

  TextEditingController oldPasswordController;
  TextEditingController newPasswordController;

  RegExp postalCode =
      new RegExp(r'^(?![\d]+$)(?![a-zA-Z]+$)(?![^\da-zA-Z]+$).{6,20}$');//  正则验证

  @override
  void initState() {
    super.initState();
    oldPasswordController = new TextEditingController();
    newPasswordController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('修改密码')),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[],
            ),
          ),
          _shortcutMenu(),
          _tipsText(),
          _loginBtn(context),
        ],
      ),
    );
  }

  _tipsText() {
    return Wrap(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10.0),
          child: Text("必须是6-20个英文字母,数字或符号(除空格),且字母,数字和标点符号至少包含两种",
              style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  _shortcutMenu() {
    return Container(
      child: Column(children: [
        Container(
          child: Stack(
            alignment: const Alignment(1.0, 1.0),
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: "请输入原来密码",
                  prefixIcon: Icon(Icons.lock),
                ),
                maxLines: 1,
                obscureText: true,
                controller: oldPasswordController,
                onChanged: (String value) {
                  setState(() {
                    oldPassword = value;
                  });
                },
              ),
              FlatButton(
                onPressed: () {
                  oldPassword ="";
                  oldPasswordController.clear();
                },
                shape: CircleBorder(),
                child: Icon(Icons.clear, color: Colors.grey),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0),
          child: Stack(
            alignment: const Alignment(1.0, 1.0),
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: "请输入新密码",
                  prefixIcon: Icon(Icons.lock_open),
                ),
                maxLines: 1,
                obscureText: showPassword,
                controller: newPasswordController,
                onChanged: (String value) {
                  setState(() {
                    newPassword = value;
                  });
                },
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                shape: CircleBorder(),
                child: !showPassword
                    ? Icon(Icons.visibility_off, color: Colors.grey)
                    : Icon(Icons.remove_red_eye, color: Colors.grey),
              )
            ],
          ),
        ),
      ]),
    );
  }

  _loginBtn(context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 8.0),
      child: RaisedButton(
        color: Colors.blue,
        onPressed: () {
          if (isLoginPassword(newPassword)) {
            _update(context);
          } else {
            Toast.show("密码格式不规范请重新输入");
          }
        },
        elevation: 10,
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.blue,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Center(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                      child: Center(
                        child: Text(
                          "完  成",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _update(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String str = pref.getString("user");
    user = json.decode(str);
    token = user['token'];
    Map<String, dynamic> respData =
    await updatePassword(oldPassword, newPassword, token);
    Toast.show("修改成功，请重新登录！");
    pref.remove("user");
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', (router) => router == null);
  }
  // 新密码的验证
  static bool isLoginPassword(String input) {
    RegExp mobile = new RegExp(r"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$");
    return mobile.hasMatch(input);
  }
}
