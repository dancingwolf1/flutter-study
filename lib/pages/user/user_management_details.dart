import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/pages/user/user_edit.dart';
import 'package:flutter_spterp/component/select_user_jurisdiction.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:flutter_spterp/component/list_info.dart';

class DetailPage extends StatefulWidget {
  DetailPage(this.details);

  final Map details;

  @override
  MixerWorkLoadState createState() => MixerWorkLoadState();
}

class MixerWorkLoadState extends State<DetailPage> {
  TextStyle labelStyle = TextStyle(fontSize: 18.0, color: Colors.blueGrey);
  TextStyle valueStyle = TextStyle(fontSize: 18.0, color: Colors.black87);

  TextEditingController _selectSignAmount;

  String password;
  
  Map user = {}; // 详情请求结果
  Map auth = {
    "编辑": false,
    "重置密码": false,
    "更改权限": false
  };

  @override
  void initState() {
    super.initState();
    _selectSignAmount = new TextEditingController();
    init();
  }

  init() async {
    Map result = await viewUser(widget.details['user']['uid'].toString());
    setState(() {
      user = result;
    });
    getAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("查看用户"),
      ),
      body: GestureDetector(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  contentRowViewPublic(
                      "用  户  名", user['username']),
                  contentRowViewPublic("手  机  号",user['phone']),
                  contentRowViewPublic(
                      "所属企业",user['epShortNamelist']),
                  contentRowViewPublic(
                      "权  限  组",user['agnamelist']),
                  contentRowViewPublic("邮        箱",user['email']),
                  Row(
                    children: <Widget>[
                      auth["编辑"]
                          ? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                    color: Colors.blue,
                                    child: Text(
                                      "编辑",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UseEditPage(user)));
                                      init();
                                    }),
                              ),
                            )
                          : Container(),
                      auth["重置密码"]
                          ? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                    color: Colors.blue,
                                    child: Text(
                                      "重置密码",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {

                                      getEject();
                                    }),
                              ),
                            )
                          : Container(),
                      auth["更改权限"]
                          ? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                    color: Colors.blue,
                                    child: Text(
                                      "更改权限",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SelectJurisdictionPage(
                                                      widget.details['user']
                                                          ['uid'],
                                                      uAid: widget
                                                          .details['uaid'])));
                                      init();
                                    }),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getEject() {
    return showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          contentPadding: EdgeInsets.all(8.0),
          title: new Text('输入密码'),
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _selectSignAmount,
              decoration: InputDecoration(
                  icon: Icon(Icons.vpn_key), hintText: "请输入新的密码"),
              onChanged: (val) async {
                setState(() {
                  password = val.toString();
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.blue,
                    child: Text("确认", style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if (password.trim() == "") {
                        Toast.show("密码不可以为空");
                        return;
                      }
                      if (!isLoginPassword(password)) {
                        Toast.show("密码格式不规范请重新输入");
                        return;
                      }
                      await initUser(
                        uid: widget.details['user']['uid'].toString(),
                        password: password,
                      );
                      Toast.show("修改成功");
                      Navigator.of(context).pop();
                    },
                  ),
                  RaisedButton(
                    color: Colors.blue,
                    child: Text("取消", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ).then((val) {});
  }

  // 重置密码验证
  // 新密码的验证
  static bool isLoginPassword(String input) {
    RegExp mobile = new RegExp(r"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$");
    return mobile.hasMatch(input);
  }
  // 本页权限
  getAuth() async {
    auth["编辑"] = await getPermission("erpPhone_UserController_editUser");
    auth["重置密码"] = await getPermission("erpPhone_UserController_initUser");
    auth["更改权限"] = await getPermission("erpPhone_UserController_setUserAuth");
  }
}
