import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/module/bottom_bar.dart';
import 'package:flutter_spterp/util/user_util.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:qr_flutter/qr_flutter.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  var clickFlag;
  String phone = "";
  String password = "";
  bool isShowPwd = true;
  String link = ""; // 下载链接

  @override
  void initState() {
    super.initState();
    _isLogin();
    _downLink();
  }

  _isLogin() async {
    if (await getUser() != null) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', (router) => router == null);
    }
  }

  _loginForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Form(
        child: Column(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "请输入手机号",
                prefixIcon: Icon(Icons.person),
              ),
              maxLines: 1,
              onChanged: (String value) {
                setState(() {
                  phone = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "请输入密码",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                      (isShowPwd) ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      isShowPwd = !isShowPwd;
                    });
                  },
                ),
              ),
              maxLines: 1,
              obscureText: isShowPwd,
              onChanged: (String value) {
                setState(() {
                  password = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  _loginBtn(context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 8.0),
      child: RaisedButton(
        color: Colors.blue,
        onPressed: () {
          if (phone.length <= 0 && password.length <= 0) {
            Toast.show("用户名或密码不能为空");
            return;
          }

          _login(context);
        },
        elevation: 10,
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.blue,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "登   录",
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _login(context) async {
    Map<String, dynamic> respData = await login(phone, password);



    Navigator.pushNamedAndRemoveUntil(
        context, '/home', (router) => router == null);
    // 处理跳转后底部导航选中index变量未修改导致无法打开我的
    setNowIndex(0);
  }

  /// 获得下载的链接
  _downLink() async {
    Map result = await getProduct();

    if (Platform.isIOS) {
      //ios相关代码
      setState(() {
        link =
            "https://itunes.apple.com/cn/app/%E5%95%86%E7%A0%BCerp/id1460222587?mt=8&from=groupmessage";
      });
    } else if (Platform.isAndroid) {
      //android相关代码
      if (result['version'] == null) {
        // 如果没有版本号则终止执行
        link = "";
        return;
      }
      setState(() {
        link = "http://downloads.hntxrj.com/${result['version']}.apk";
      });
    }
  }

  /// 二维码视图
  _downView() {
    return Container(
        child: Column(children: <Widget>[
          Center(
            child: link == ""
                ? Text("未找到版本号")
                : QrImage(
              data: link,
              size: 200.0,
            ),
          ),
          Text("通过二维码分享给好友", style: TextStyle(color: Colors.grey)),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.0, 70.0, 20.0, 20.0),
        children: <Widget>[
          Image.asset(
            "images/logo@2x.png",
            width: 100.0 * 0.6,
            height: 145.0 * 0.6,
          ),
          _loginForm(),
          _loginBtn(context),
//          _downView()
        ],
      ),
    );
  }
}
