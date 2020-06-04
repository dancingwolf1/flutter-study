import 'package:flutter/material.dart';

bottomCollect(String value, context) {
  return Positioned(
    child: Container(
      width: MediaQuery.of(context).size.width,
      child: Text("$value", style: TextStyle(color: Colors.white)),
      padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0),
      decoration: new BoxDecoration(color: Colors.lightBlue), // 也可控件一边圆角大小
    ),
    bottom: 0,
  );
}
