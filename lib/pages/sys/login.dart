import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/module/bottom_bar.dart';
import 'package:flutter_spterp/util/user_util.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
import 'package:flutter_spterp/util/adaptive.dart';
import 'package:flutter_spterp/component/different_input.dart';
import 'package:flutter_spterp/component/button/raised_button.dart';
import 'package:flutter_spterp/util/public_color.dart';
import 'package:flutter_spterp/util/local_storage.dart';
import 'package:flutter_spterp/component/pop_page/index.dart';

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
  bool isRememberPassword = true; // 是否记住密码
  String link = ""; // 下载链接
  TextEditingController _selectedAccountController; // 账号控制器
  TextEditingController _selectedPasswordController; // 密码控制器

  @override
  void initState() {
    super.initState();
    init();
    _isSave(); // 判断之前是否记录过账号信息
    _isLogin();
    _downLink();
  }

  init() {
    _selectedAccountController = new TextEditingController();
    _selectedPasswordController = new TextEditingController();
  }

  _isLogin() async {
    if (await getUser() != null) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', (router) => router == null);
    }
  }

  _loginForm() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setWidth(104)),
      child: Form(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(53, 134, 249, 0.05),
                borderRadius: BorderRadius.all(
                  //圆角
                  Radius.circular(4),
                ),
              ),
              width: ScreenUtil().setWidth(622),
              height: ScreenUtil().setWidth(96),
              child: loginInput(
                  "输入手机号",
                  "images/login_pro.png",
                  "images/login_err.png",
                  _getAccount,
                  _deleteAccount,
                  _selectedAccountController),
            ),
            SizedBox(height: ScreenUtil().setWidth(20)),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(53, 134, 249, 0.05),
                borderRadius: BorderRadius.all(
                  //圆角
                  Radius.circular(4),
                ),
              ),
              width: ScreenUtil().setWidth(622),
              height: ScreenUtil().setWidth(96),
              child: loginInput(
                  "请输入密码",
                  "images/index_lock.png",
                  !isShowPwd
                      ? "images/index_eye.png"
                      : "images/login_eye_offer.png",
                  _getPassword,
                  _switcher,
                  _selectedPasswordController,
                  isShowPwd: isShowPwd),
            ),
          ],
        ),
      ),
    );
  }

  /// 手机号赋值方法
  _getAccount(String value) {
    print("输出11");
    setState(() {
      phone = value;
    });
  }

  /// 密码赋值方法
  _getPassword(String value) {
    print("输出二");
    setState(() {
      password = value;
    });
  }

  _loginBtn(context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 8.0),
      child: Container(width: ScreenUtil().setWidth(622),height: ScreenUtil().setWidth(96),child: getRaisedButton("登 录", _onTopLogin, usePublicColor(1),borderRadius: ScreenUtil().setWidth(4))),
    );
  }

  /// 点击登录所执行的事件
  _onTopLogin() {
    if (phone.length <= 0 && password.length <= 0) {
      Toast.show("用户名或密码不能为空");
      return;
    }
    _login(context);
  }

  _login(context) async {
    Map<String, dynamic> respData = await login(phone, password);

    /// 是否记住密码
    if (isRememberPassword) {
      print("我记住密码了");
      _recordLoginInformation(phone, password);
    } else {
      print("未记住密码清除之前的密码和账户信息");
      LocalStorage().remove('account');
      LocalStorage().remove('password');
    }
    Navigator.pushNamedAndRemoveUntil(
        context, '/home', (router) => router == null);
    // 处理跳转后底部导航选中index变量未修改导致无法打开我的
    setNowIndex(0);
  }

  /// 获得下载的链接
  _downLink() async {
//    Map result = await getProduct();
    Map result = {};
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
        link = "模拟登陆地址";
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

  /// 控制显示密码还是隐藏密码的切换方法
  _switcher() {
    setState(() {
      isShowPwd = !isShowPwd;
    });
  }

  ///  分享app
  _share() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.share, color: Color.fromRGBO(112, 112, 112, 1)),
            onPressed: () {
              print("分享");
            }),
        SizedBox(width: ScreenUtil().setWidth(32)),
      ],
    );
  }

  /// 清除账号
  _deleteAccount() {
    print("清除账号");
    setState(() {
      _selectedAccountController.text = "";
      phone = "";
    });
  }

  /// 保留账号信息和密码信息
  _recordLoginInformation(String account, String password) {
    LocalStorage().save('account', account);
    LocalStorage().save('password', password);
  }

  ///  下载二维码和记住密码视图
  _loginCenter() {
    return Padding(
        padding: EdgeInsets.only(
            right: ScreenUtil().setWidth(30), left: ScreenUtil().setWidth(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
                child: imageTitle(Image.asset("images/login_er.png"), "下载二维码",
                    ScreenUtil().setWidth(16)),
                onTap: () {
                  print("弹出层");
                  popPage(
                      context,
                      Container(child: _downView(), width: 200, height: 260),
                      "下载二维码");
                }),
            imageTitle(
                Checkbox(
                  value: isRememberPassword,
                  activeColor: usePublicColor(1), //选中时的颜色
                  onChanged: (value) {
                    setState(() {
                      isRememberPassword = !isRememberPassword;
                    });
                  },
                ),
                "记住密码",
                0),
          ],
        ));
  }

  ///  判断之前是否进行的过账号录入
  ///  如果本地有用户信息就将之前的用户名回显
  _isSave() async {
    String account = await LocalStorage().read('account');
    String result = await LocalStorage().read('password');
    if (result != null && result != "") {
      setState(() {
        phone = account;
        password = result;
        _selectedAccountController.text = account;
        _selectedPasswordController.text = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    adaptation(context);
    return Scaffold(
      body: ListView(
        children: <Widget>[
          _share(), // 分享
          Padding(
              padding: EdgeInsets.fromLTRB(20.0, ScreenUtil().setWidth(184),
                  20.0, ScreenUtil().setWidth(104)),
              child: Column(children: <Widget>[
                Image.asset(
                  "images/ERP_logo.png",
                  width: ScreenUtil().setWidth(240),
                  height: ScreenUtil().setWidth(206),
                ),
                _loginForm(),
                _loginCenter(),
                _loginBtn(context),
              ])),
        ],
      ),
    );
  }
}


/// 左边Widget，右边提示文字组件
/// [right] 左边的控件
/// [title] 右边的提示文字
/// [distance] 文字与控件的距离
Widget imageTitle(Widget right,String title,double distance){
  return Row(children: <Widget>[
    right,
    Padding(
      padding: EdgeInsets.only(left: distance),
      child:Text(title,style: TextStyle(color: Color.fromRGBO(139, 137, 151, 1),fontSize: ScreenUtil().setSp(24))),
    ),
  ]);
}