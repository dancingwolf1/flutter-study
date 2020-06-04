import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
/// 获得对应的button按钮
/// [title] 按钮上所显示的文字
/// [onTap] 点击按钮所触发的事件
/// [buttonColor] 按钮的颜色
/// [borderRadius] 圆角大小
Widget getRaisedButton(String titleA,Function onTapA,Color buttonColorA,{
 double borderRadius = 4
}){
  String title = titleA; // 按钮文字
  Function onTap = onTapA;// 点击按钮所触发的事件
  Color buttonColor = buttonColorA;// 按钮的颜色
  RoundedRectangleBorder circular;// 按钮的圆角

  return RaisedButton(
    color: buttonColor,
    onPressed: onTap,
    elevation: 0,
    shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.blue,
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "$title",
            style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
  );
}