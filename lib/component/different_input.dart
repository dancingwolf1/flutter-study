import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库

/// 登录页的输入框   第一种输入框的类型
/// [hinText]   输入框所提示文字
/// [beforeImage]  输入框头部展示图片路径
/// [afterImage] 输入框尾部的展示图片路径
/// [onChanged] 输入完成赋值方法  该方法主要用于输入框的赋值
/// [clickImage] 点击输入框尾部图片执行的方法
/// [inputController] 输入框中的控制器
/// [isShowPwd]  是否为密码的输入框类型
loginInput(String hinText,String beforeImage,String afterImage,Function onChanged,Function clickImage,TextEditingController controller,{bool isShowPwd = false}) {
return TextField(
  controller: controller,
  decoration: InputDecoration(
    border: InputBorder.none,
    hintText: hinText,
    hintStyle: TextStyle(
      fontSize: ScreenUtil().setSp(30),
    ),
    prefixIcon: Image.asset(
      beforeImage,
      width: ScreenUtil().setWidth(38),
      height: ScreenUtil().setWidth(38),
    ),
    suffixIcon: IconButton(
      icon: Image.asset(
        afterImage,
        width: ScreenUtil().setWidth(34),
        height: ScreenUtil().setWidth(34),
      ),
      onPressed:clickImage,
    ),
  ),
  maxLines: 1,
  obscureText: isShowPwd,
  onChanged: onChanged,
);
}