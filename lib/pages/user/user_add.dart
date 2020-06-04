import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:flutter_spterp/component/select_user_jurisdiction.dart';
import 'package:flutter_spterp/component/toast.dart';

class UseAddPage extends StatefulWidget {
  @override
  ContractAddPageState createState() => ContractAddPageState();
}

class ContractAddPageState extends State<UseAddPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _selectedSignTimeController;
  TextEditingController _selectedEndTimeController;
  TextEditingController _selectedUserNameCodeController; // 用户名
  TextEditingController _selectedUserPhoneController; // 手机号
  TextEditingController _selectedPassWordCodeController; // 密码
  TextEditingController _selectedEmailCodeController; // 用户邮箱
  TextEditingController _selectedBindSaleManNameController; // 销售员名称

  String userName = ""; // 用户名
  String phone = ""; // 手机号
  String password = ""; // 密码
  String confirmPassword = ""; // 确认密码
  String email = ""; // 用户邮箱
  String erpType = "±"; // 用户类型
  String status = "0"; // 用户状态
  String symbolGrade = "其他"; // 下拉框
  String bindSaleManName = ""; // 销售员名称
  GlobalKey _formKey = GlobalKey<FormState>();

  Map<String, dynamic> selectedEpp = {};
  Map<String, dynamic> selectBuilder = {};
  Map<String, dynamic> selectSalesman = {};
  Map<String, dynamic> selectContractType = {}; // 选中的合同类型
  Map<String, dynamic> selectPriceType = {}; // 选中的价格执行方式类型

  List priceTypeDropDown = [];
  List contractTypeDropDown = [];

  double contractNum = 0;
  double preNum = 0;
  double preMoney = 0;
  bool statusSwitch = true;
  bool isShowPwd = true;

  int _endTime = DateTime.now().millisecondsSinceEpoch;
  int _signTime = DateTime.now().millisecondsSinceEpoch;

  String remark;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _selectedSignTimeController = new TextEditingController();
    _selectedEndTimeController = new TextEditingController();
    _selectedUserNameCodeController = new TextEditingController(); // 用户名
    _selectedUserPhoneController = new TextEditingController(); // 手机号
    _selectedPassWordCodeController = new TextEditingController(); // 密码
    _selectedEmailCodeController = new TextEditingController(); // 用户邮箱
    _selectedSignTimeController.text =
        DateTime.fromMillisecondsSinceEpoch(_signTime, isUtc: false)
            .toString()
            .substring(0, 16);
    _selectedEndTimeController.text =
        DateTime.fromMillisecondsSinceEpoch(_endTime, isUtc: false)
            .toString()
            .substring(0, 16);

    _getPriceTypeDropDown();
    _getContractTypeDropDown();
  }

  _getPriceTypeDropDown() async {
    List dropDown = await getPriceTypeDropDown();
    setState(() {
      priceTypeDropDown = dropDown;
    });
  }

  _getContractTypeDropDown() async {
    List dropDown = await getContractTypeDropDown();
    setState(() {
      contractTypeDropDown = dropDown;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("添加用户"),
        ),
        body: loading(
            isLoading,
            Form(
              key: _formKey,
              autovalidate: true,
              child: ListView(
                padding: EdgeInsets.all(8.0),
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RichText(
                            text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Color(0xffff0000),
                              fontSize: 20.0,
                            ),
                          )
                        ])),
                        flex: 1,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _selectedUserNameCodeController,
                          textInputAction: TextInputAction.send,
                          maxLines: 1,
                          decoration: InputDecoration(
                              icon: Icon(Icons.person),
                              labelText: "用户名",
                              hintText: "请输入用户名"),
                          onChanged: (val) {
                            setState(() {
                              userName = val;
                            });
                          },
                        ),
                        flex: 20,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RichText(
                            text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Color(0xffff0000),
                              fontSize: 20.0,
                            ),
                          )
                        ])),
                        flex: 1,
                      ),
                      Expanded(
                          child: TextField(
                            controller: _selectedUserPhoneController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.send,
                            maxLines: 1,
                            decoration: InputDecoration(
                                icon: Icon(Icons.phone_iphone),
                                labelText: "手机号",
                                hintText: "请输入手机号"),
                            onChanged: (val) {
                              setState(() {
                                phone = val;
                              });
                            },
                          ),
                          flex: 20),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RichText(
                            text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Color(0xffff0000),
                              fontSize: 20.0,
                            ),
                          )
                        ])),
                        flex: 1,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _selectedPassWordCodeController,
                          textInputAction: TextInputAction.send,
                          maxLines: 1,
                          obscureText: isShowPwd,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon((isShowPwd)
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    isShowPwd = !isShowPwd;
                                  });
                                },
                              ),
                              icon: Icon(Icons.vpn_key),
                              labelText: "用户密码",
                              hintText: "请输入密码"),
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        flex: 20,
                      ),
                    ],
                  ),
                  /*     Row(
                    children: <Widget>[
                      Expanded(
                        child: RichText(
                            text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Color(0xffff0000),
                              fontSize: 20.0,
                            ),
                          )
                        ])),
                        flex: 1,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _selectedConfirmPasswordCodeController,
                          textInputAction: TextInputAction.send,
                          maxLines: 1,
                          obscureText: true,
                          decoration: InputDecoration(
                              icon: Icon(Icons.vpn_key),
                              labelText: "确认密码",
                              hintText: "请输入再次输入密码"),
                          onChanged: (val) {
                            setState(() {
                              confirmPassword = val;
                            });
                          },
                        ),
                        flex: 20,
                      ),
                    ],
                  ),*/
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RichText(
                            text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: '',
                            style: TextStyle(
                              color: Color(0xffff0000),
                              fontSize: 20.0,
                            ),
                          )
                        ])),
                        flex: 1,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _selectedEmailCodeController,
//                    keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.send,
                          maxLines: 1,
                          decoration: InputDecoration(
                              icon: Icon(Icons.email),
                              labelText: "用户邮箱",
                              hintText: "请输入邮箱"),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                        ),
                        flex: 20,
                      ),
                    ],
                  ),
                  symbolGrade == "销售员"
                      ? Row(
                          children: <Widget>[
                            Expanded(
                              child: RichText(
                                  text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                  text: '',
                                  style: TextStyle(
                                    color: Color(0xffff0000),
                                    fontSize: 20.0,
                                  ),
                                )
                              ])),
                              flex: 1,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _selectedBindSaleManNameController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.send,
                                maxLines: 1,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.chrome_reader_mode),
                                    labelText: "销售名称",
                                    hintText: "请输入销售名称"),
                                onChanged: (val) {
                                  setState(() {
                                    bindSaleManName = val;
                                  });
                                },
                              ),
                              flex: 20,
                            ),
                          ],
                        )
                      : Container(),
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                      Text("用户类型:",
                          style: TextStyle(fontSize: 17, color: Colors.grey)),
                      SizedBox(
                        width: 20,
                      ),
                      DropdownButton<String>(
                        value: symbolGrade,
                        onChanged: (String newValue) {
                          setState(() {
                            symbolGrade = newValue;
                          });
                        },
                        items: <String>["其他", '销售员', '司机']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("用户状态:",
                          style: TextStyle(fontSize: 17, color: Colors.grey)),
                      CupertinoSwitch(
                          value: statusSwitch,
                          activeColor: Colors.blue,
                          onChanged: (bool val) {
                            setState(() {
                              statusSwitch = !statusSwitch;
                            });
                            if (statusSwitch) {
                              status = "0";
                            } else {
                              status = "1";
                            }

                          })
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            child: Text(
                              "下一步",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              _submitAddContract();
                            },
                            color: Colors.blueAccent,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )));
  }

  Future _submitAddContract() async {
    String _username = ""; // 用户名
    String _phone = ""; // 手机号
    String _password = ""; // 密码
    String _confirmPassword = ""; // 确认密码
    String _email = ""; // 用户邮箱
    String _erpType = ""; // 用户类型
    String _status = ""; // 用户状态
    String _bindSaleManName = bindSaleManName;

    _username = userName; // 用户名
    _phone = phone; // 手机号
    _password = password; // 密码
    _confirmPassword = confirmPassword; // 确认密码
    _email = email; // 用户邮箱
    switch (symbolGrade) {
      case "其他":
        _erpType = "0";
        break;
      case "销售员":
        _erpType = "1";
        break;
      case "司机":
        _erpType = "2";
        break;
    }
    _status = status; // 用户状态

// 验证用户名
    if (goEmpty(_username).length < 2) {
      Toast.show("用户名长度必须大于2");
      return;
    }
// 验证手机号
    if (!isChinaPhoneLegal(_phone)) {
      Toast.show("手机号不规范请重新输入");
      return;
    }
// 验证密码
    if (goEmpty(_password).length < 6) {
      Toast.show("密码长度小于6位请重新输入");
      return;
    }
// 验证第二次密码
/*    if (_password != _confirmPassword) {
      Toast.show("两次输入密码不一致");
      return;
    }*/
// 验证邮箱
    if (_email != "") {
      if (!RegExp(r"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$")
          .hasMatch(_email)) {
        Toast.show("邮箱格式不规范");
        return;
      }
    }

    Map result = await addUsers(
      username: _username,
      phone: _phone,
      password: _password,
      bindSaleManName: _bindSaleManName,
      confirmPassword: _confirmPassword,
      email: _email,
      erpType: _erpType,
      status: _status,
    );
    String uid = result['uid'].toString();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SelectJurisdictionPage(uid)));
  }

// 首位去空格
  String goEmpty(String str) {
    return str.replaceFirst(new RegExp(r"^\s+"), "");
  }

// 手机号码验证
  bool isChinaPhoneLegal(String str) {
    return new RegExp(
            '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
        .hasMatch(str);
  }
}
