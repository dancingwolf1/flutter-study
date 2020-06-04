import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/toast.dart';

class UseEditPage extends StatefulWidget {
  UseEditPage(this.user);

  final user;

  @override
  ContractAddPageState createState() => ContractAddPageState();
}

class ContractAddPageState extends State<UseEditPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  /// 输入框控制器 输入条件

  TextEditingController _selectedUserNameCodeController; // 用户名
  TextEditingController _selectedUserPhoneController; // 手机号
  TextEditingController _selectedMailCodeController; // 用户邮箱
  TextEditingController _selectedBindSaleManNameController; // 销售员名称

  String username = ""; // 用户名
  String phone = ""; // 手机号
  String email = ""; // 用户邮箱
  String erpType = ""; // 用户类型
  String status = "0"; // 用户状态
  String symbolGrade = "其他"; // 下拉框
  String bindSaleManName = ""; // 销售员名称

  GlobalKey _formKey = GlobalKey<FormState>();

  Map<String, dynamic> selectedEpp = {};
  Map<String, dynamic> selectBuilder = {};
  Map<String, dynamic> selectSalesman = {};
  Map<String, dynamic> selectContractType = {}; // 选中的合同类型
  Map<String, dynamic> selectPriceType = {}; // 选中的价格执行方式类型

  bool isLoading = true;
  bool statusSwitch = true;
  bool isShowPwd = true;

  @override
  void initState() {
    super.initState();

    _selectedUserNameCodeController = new TextEditingController(); // 用户名
    _selectedUserPhoneController = new TextEditingController(); // 手机号
    _selectedMailCodeController = new TextEditingController(); // 用户邮箱
    _selectedBindSaleManNameController = new TextEditingController();

    init();
  }

  init() {
    setState(() {
      _selectedUserNameCodeController.text = widget.user['username'];
      username = widget.user['username'];
      _selectedUserPhoneController.text = widget.user['phone'];
      phone = widget.user['phone'];
      _selectedMailCodeController.text = widget.user['email'];
      email = widget.user['email'];



      switch (widget.user['erpType'].toString()) {
        case "0":
          symbolGrade = "其他";
          break;
        case "1":
          symbolGrade = "销售员";
          break;
        case "2":
          symbolGrade = "司机";
          break;
      }
      _selectedBindSaleManNameController.text = widget.user['bindSaleManName'];
      bindSaleManName = widget.user['bindSaleManName'];
      status = widget.user['status'].toString();
      if (status == "0") {
        statusSwitch = true;
      } else if (status == "1") {
        statusSwitch = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("编辑用户"),
        ),
        body: Form(
          key: _formKey,
          autovalidate: true,
          child: ListView(
            padding: EdgeInsets.all(8.0),
            children: <Widget>[
              TextField(
                controller: _selectedUserNameCodeController,
                textInputAction: TextInputAction.send,
                maxLines: 1,
                decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: "用户名",
                    hintText: "请输入用户名"),
                onChanged: (val) {
                  setState(() {
                    username = val;
                  });
                },
              ),
              TextField(
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
              TextField(
                controller: _selectedMailCodeController,
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
              symbolGrade == "销售员"
                  ? TextField(
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
                          "确定",
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
        ));
  }

  Future _submitAddContract() async {
    String _username = ""; // 用户名
    String _phone = ""; // 手机号
    String _email = ""; // 用户邮箱
    String _erpType = ""; // 用户类型
    String _status = ""; // 用户状态
    String _bindSaleManName = bindSaleManName;

    _username = username; // 用户名
    _phone = phone; // 手机号
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
//    如果不是销售员就变成就把销售员名称置为空
    if (_erpType != "1") {
      _bindSaleManName = "";
    }
 /*   print(
        "用户名${_username}手机号${_phone}用户邮箱${_email}用户类型${_erpType}用户状态${_status}下拉框${_symbolGrade}销售名称${_bindSaleManName}");
*/

    //    验证用户名
    if (ltrim(_username).length < 2) {
      Toast.show("用户名长度必须大于2");
      return;
    }
//    验证手机号
    if (!isChinaPhoneLegal(_phone)) {
      Toast.show("手机号不规范请重新输入");
      return;
    }
//   验证邮箱
    if (_email != "") {
      if (!RegExp(r"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$")
          .hasMatch(_email)) {
        Toast.show("邮箱格式不规范");
        return;
      }
    }

    await editUser(
      uid: widget.user['uid'].toString(),
      username: _username,
      phone: _phone,
      email: _email,
      bindSaleManName: _bindSaleManName,
      erpType: _erpType,
      status: _status,
    );
    Toast.show("修改成功");
    Navigator.pop(context);
    /* Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserManagementPage()));*/
  }

// 首位去空格
  String ltrim(String str) {
    return str.replaceFirst(new RegExp(r"^\s+"), "");
  }

// 手机号码验证
  bool isChinaPhoneLegal(String str) {

    print(RegExp(
            '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
        .hasMatch(str));
    return new RegExp(
            '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
        .hasMatch(str);
  }
}
