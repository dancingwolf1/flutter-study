import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库


/**
 * 侧边栏的搜索框
 * 分为三类
 * 第一类是时间搜索框
 * 第二类是输入搜索框
 * 第三类是点击选择搜索框
 * */

/// 时间搜索框
/// [context] 上下文
/// [onTap]  点击确认时执行事件
/// [time] 要显示的时间值
/// [title] 标题
/// [dateLength]保留几位时间数

onTapSelectTime(var context,String title,Function onTap,int inputTime,{int dateLength = 10}){
  return Padding(child: Row(
    children: <Widget>[
      Text("$title ",style: TextStyle(fontSize: ScreenUtil().setSp(28),color: Color.fromRGBO(59, 57, 73, 1),fontWeight: FontWeight.w700)),
      SizedBox(width: ScreenUtil().setWidth(20),),
      GestureDetector(
        onTap:onTap,
        child:Container(
          width: ScreenUtil().setWidth(370),
          height: ScreenUtil().setWidth(64),
          decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.16)),
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(8)),
          ),
          child: Center(child: Text(DateTime.fromMillisecondsSinceEpoch(inputTime, isUtc: false)
              .toString()
              .substring(0, dateLength),style:TextStyle(color: Color.fromRGBO(139, 137, 151, 1)))),
        ),
      ),
    ],
  ),padding: EdgeInsets.only(right: ScreenUtil().setWidth(20),left: ScreenUtil().setWidth(20)));
}
/// 输入搜索框

/// 点击选择搜索框
/// [controller] 搜索框控制器
/// [title] 搜索框标题
/// [hint] 搜索框提示框文字
/// [selectTop] 点击回调函数
Widget onTapSelectInput(
  TextEditingController controller, // 选择输入框控制器
  String title,
  Function selectTop, {
  String hintText,
}) {
  String hintText;
  if (hintText == null) {
    hintText = "请选择$title";
  }
  return Stack(
    alignment: Alignment.center,
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(
            right: ScreenUtil().setWidth(20), left: ScreenUtil().setWidth(20)),
        child: TextField(
          maxLines: 1,
          controller: controller,
          enableInteractiveSelection: false,
          decoration: InputDecoration(
              border: InputBorder.none,
              icon: Text("$title",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: Color.fromRGBO(59, 57, 73, 1),
                      fontWeight: FontWeight.w700)),
              hintStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(26),
                  color: Color.fromRGBO(201, 199, 210, 1)),
              hintText: "$hintText",
              suffixIcon: Icon(Icons.chevron_right,
                  color: Color.fromRGBO(201, 199, 210, 1))),
        ),
        decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.16))),
        ),
      ),
      GestureDetector(
        child: Container(
          height: ScreenUtil().setWidth(40),
          width: double.infinity,
//          color: Colors.transparent,
          color: Colors.transparent,
        ),
        onTap: selectTop,
      ),
    ],
  );
}
