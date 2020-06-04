import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// 加载状态组件
/// [isLoading]  加载的状态
/// [component]  需要加载状态的组件
/// [text] 要提醒的文字
loading(bool isLoading, Widget component, {String text}) {
  String myText; // 提示文字
  if(text == null){
    myText = '正在加载中，莫着急哦~';
  }else{
    myText =text;
  }
  return isLoading
      ? Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 35.0),
              child: new Center(
                child: SpinKitFadingCircle(
                  color: Colors.blueAccent,
                  size: 30,
                ),
              ),
            ),
            Padding(
              padding: new EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
              child: new Center(
                child: new Text(
                  myText,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        )
      : component;
}
