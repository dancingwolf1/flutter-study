import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/component/keyboard/board_widget.dart';
import 'package:flutter_spterp/component/keyboard/scroll_focus_node.dart';

class Login1Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Login1PageState();
  }
}

class _Login1PageState extends BoardWidget {
  final bool _useSystemKeyBoard = true;

  final TextStyle textStyle = TextStyle(
      fontFamily: "hwxw",
      fontSize: 20.0,
      letterSpacing: 1.0,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      color: Colors.black87);

  final TextStyle lableStyle = TextStyle(
      fontFamily: "hwxw",
      fontSize: 20.0,
      letterSpacing: 16.0,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal);

  final TextStyle helperStyle = TextStyle(
      fontFamily: "hwxw", fontSize: 12.0, fontStyle: FontStyle.normal);

  ScrollFocusNode _userNameFocusNode;
  ScrollFocusNode _passWordFocusNode;

  @override
  void initState() {
    super.initState();
    _userNameFocusNode = ScrollFocusNode(_useSystemKeyBoard, 120.0); // 第二个参数是向上滚动的距离
    _passWordFocusNode = ScrollFocusNode(_useSystemKeyBoard, 180.0); // 第二个参数是向上滚动的距离
  }

  @override
  List<Widget> initChild() {
    return <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 350.0, left: 50.0, right: 50.0),
        child: TextField(
          focusNode: _userNameFocusNode,
          autofocus: false,
          maxLength: 12,
          maxLines: 1,
          style: textStyle,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 16.0, bottom: 16.0),
            border: OutlineInputBorder(),
            labelText: "账号",
            labelStyle: lableStyle,
            helperStyle: helperStyle,
            prefixIcon: Icon(Icons.account_box, size: 24.0),
          ),
          onTap: () {
            // 点击时绑定当前focusNode
            bindNewInputer(_userNameFocusNode);
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0),
        child: TextField(
          obscureText: true,
          focusNode: _passWordFocusNode,
          autofocus: false,
          maxLength: 12,
          maxLines: 1,
          style: textStyle,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 16.0, bottom: 16.0),
            border: OutlineInputBorder(),
            labelText: "密码",
            labelStyle: lableStyle,
            helperStyle: helperStyle,
            prefixIcon: Icon(Icons.https, size: 24.0),
          ),
          onTap: () {
            // 点击时绑定当前focusNode
            bindNewInputer(_passWordFocusNode);
          },
        ),
      ),
      RaisedButton(
        onPressed: (){
          Navigator.pop(context);
        },
        child: Text("返回"),
      ),
    ];
  }
}