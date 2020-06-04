import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/pages/user/user_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_spterp/util/user_util.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库

class MyPage extends StatefulWidget {
  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  var imageUrl = "";

  Map<String, dynamic> user = {};
  Map<String, dynamic> selectedEnterprise = {};

  bool loadOk = false;

  NetworkImage header;


  List jurisdiction = [
    {'name': '二维码支付', 'mid': 'erpPhone_Nomethed_payment', 'isContain': false},
    {'name': '权限组管理', 'mid':"erpPhone_noMethod_authGroupManage", 'isContain': false},
    {'name': '用户管理', 'mid': 'erpPhone_UserController_userList', 'isContain': false},
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _getUser();
    await _image();
    setState(() {
      loadOk = true;
    });
    await getJurisdiction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(title: Text(''),),
      body: loadOk
          ? SizedBox(
          height: ScreenUtil().setHeight(900.0),
          child:ListView(
//        padding: EdgeInsets.only(top: 30.0, bottom: 0.0),
            children: <Widget>[

              Column(
                children: <Widget>[
                  _shortcutMenu(),
                  Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0),
                    child: RaisedButton(
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "退出登录",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color.fromRGBO(240, 48, 93, 1)),
                              ),
                            )
                          ],
                        ),
                      ),
                      onPressed: _onReset,
                    ),
                  ),
                ],
              )
            ],
          )
      )

          : Container(),

    );

  }

  _shortcutMenu() {
    return Column(
      children: <Widget>[

        Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 11.0),
                child: Align(
                  alignment:Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: header == null
                                    ? AssetImage("images/logo@2x.png")
                                    : header,
                              ),
                            ),
                            child: ListTile(
                              onTap: () async {
                                await Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (router) => UserHeaderPage()));
                                init();
                              },
                            ),
                          ),

                          Row(

                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "${user['username']}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    margin: EdgeInsets.only(top: 10),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "   ${selectedEnterprise['epName']}",
                                      style: TextStyle(fontSize:12.0,color: Color.fromRGBO(139, 137, 151, 1)),
                                    ),
                                    margin: EdgeInsets.only(bottom: 20.0),
                                  ),

                                ],
                              ),

                            ],
                          ),
                        ],
                      ),

                      IconButton(
                        onPressed: (){
                          print("开始跳转");
                        },
                        icon: Icon(Icons.keyboard_arrow_right),

                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    border:
                    Border(bottom: BorderSide(color: Colors.grey[200]))),
                child: ListTile(
                  title: Text("修改密码"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.pushNamed(context, "/user-edit-password");
                  },
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            children: <Widget>[
              jurisdiction[0]['isContain']
                  ? Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey[200]))),
                child: ListTile(
                  title: Text("二维码支付"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.pushNamed(context, "/payment");
                  },
                ),
              )
                  : Container(),


            ],
          ),
        ),
        Card(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    border:
                    Border(bottom: BorderSide(color: Colors.grey[200]))),
                child: ListTile(
                  title: Text("问题反馈"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.pushNamed(context, "/problem-feedback");
                  },
                ),
              ),


            ],
          ),
        )
      ],
    );

  }

  _onReset() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("user");
    pref.remove("agid");
    pref.remove("selectedEnterprise");
    pref.remove("authValue");

    Navigator.pushNamedAndRemoveUntil(
        context, '/login', (router) => router == null);

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
      user = json.decode(str);      // 把用户信息赋值到user;
      selectedEnterprise = json.decode(enterpriseStr);   //   把企业信息赋值到selectedEnterprise;
    });

  }

  _image() async {
    String token = await getToken();
    setState(() {
      imageUrl = baseUrl +
          "/user/header.png?token=$token&t=${new DateTime.now().millisecondsSinceEpoch}"; //拼接图片请求地址
      header = NetworkImage(imageUrl);
    });
  }

  Future getJurisdiction() async {
    for (int i = 0; i < jurisdiction.length; i++) {
      jurisdiction[i]['isContain'] =
      await getPermission(jurisdiction[i]['mid'].toString());
    }
  }
}