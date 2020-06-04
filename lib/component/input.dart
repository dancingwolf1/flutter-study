import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
import 'package:flutter/services.dart';
import 'package:flutter_spterp/util/public_color.dart';

/**
 * 共有四种输入框
 * 分为两类
 * 第一类是添加编辑，添加
 * 点击选择，输入
 * 第二类筛选
 * 点击选择，输入
 * */

/// 第一类 (输入)
/// [input] 输入框标题
/// [inputHint] 输入框提示文字
/// [inputControl] 输入框控制器
/// [selectF] 输入时的回调方法
/// [mustFile] 是否为必填
Widget inputWrite(String input, Function selectF,
    {TextEditingController inputControl, String inputHint, bool mustFile =false}) {
  if (inputHint == null) {
    inputHint = "请输入$input";
  }
  return Container(
      height: ScreenUtil().setWidth(96),
      padding: EdgeInsets.only(
          right: ScreenUtil().setWidth(24), left: ScreenUtil().setWidth(24)),
      child: Center(
        child: TextField(
          controller: inputControl,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Text(
                    "$input  ",
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Color.fromRGBO(139, 137, 151, 1)),
                  ),
                  mustFile?Text(
                    "*",
                    style: TextStyle(color: Color.fromRGBO(240, 48, 93, 1)),
                  ):SizedBox()
                ]),
            hintStyle: TextStyle(
                fontSize: ScreenUtil().setSp(30),
                color: Color.fromRGBO(201, 199, 210, 1)),
            hintText: "$inputHint",
          ),
          onChanged: selectF,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom:
                BorderSide(width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.16))),
      ));
}

/// 第二类 (点击选择)
/// [control]输入抗控制器
/// [title]输入框标题
/// [hintText]输入框提示信息
/// [select] 点击时的回调事件
/// [isFill] 控制是否是必填选项

Widget inputSelect(
  TextEditingController control, // 选择输入框控制器
  String title,
  Function onTop,
    {
  bool isFill = true,
  String hintText,
}) {
  if (hintText == null) {
    hintText = "请选择$title";
  }
  return Stack(alignment: Alignment.center, children: <Widget>[
    Container(
      height: ScreenUtil().setWidth(96),
      padding: EdgeInsets.only(
          right: ScreenUtil().setWidth(20), left: ScreenUtil().setWidth(20)),
      child: Center(
        child: TextField(
          maxLines: 1,
          controller: control,
          enableInteractiveSelection: false,
          onTap: onTop,
          decoration: InputDecoration(
              border: InputBorder.none,
              icon: Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                Text(  "$title  ", style: TextStyle(
                      fontSize: ScreenUtil().setSp(30),
                      color: usePublicColor(2),
                      fontWeight: FontWeight.w500)),
                  isFill?Text('*' , style: TextStyle(color: Color.fromRGBO(240, 48, 93, 1))):SizedBox(),
                ],
              ),
              hintStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  color: Color.fromRGBO(201, 199, 210, 1)),
              hintText: "$hintText",
              suffixIcon: Icon(Icons.chevron_right,
                  color: Color.fromRGBO(201, 199, 210, 1))),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
//      border:Border.all(width: 1,color: Color.fromRGBO(0, 0, 0, 0.41)),
        border: Border(
            bottom:
                BorderSide(width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.16))),
      ),
    ),
    GestureDetector(
      child: Container(
        height: ScreenUtil().setWidth(40),
        width: double.infinity,
        color: Colors.transparent,
      ),
      onTap: onTop,
    ),
  ]);
}

/// 备注文本域
///[textAreaController] 文本域控制器
///[textAreaSelect] 文本域输入文本时的回调函数
///[textAreaMaxRow] 文本域的最大行数
///[textAreaFontValue] 文本域最多可以输入多少个文字
textArea(TextEditingController textAreaController, Function textAreaSelect,
    int textAreaMaxRow,
    {int textAreaFontValue}) {
  return Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(10),
              bottom: ScreenUtil().setWidth(10),
              left: ScreenUtil().setWidth(22)),
          child: Text(
            "备注",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                color: usePublicColor(2),
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.right,
          ),
        ),
        Container(
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(22),
              right: ScreenUtil().setWidth(22),
              bottom: ScreenUtil().setWidth(24)),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.41))),
          ),
          child: TextField(
            maxLength: textAreaFontValue,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "请输入不少于10个字的文字描述信息",
                hintStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                    color: Color.fromRGBO(201, 199, 210, 1))),
            controller: textAreaController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.send,
            maxLines: textAreaMaxRow,
            onChanged: textAreaSelect,
          ),
        ),
      ],
    ),
  );
}
