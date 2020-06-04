import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
/// 筛选列表Item
/// [context] 上下文
/// [itemDate] 传递参数
/// [showContent] 要显示的内容
/// [onTap] 点击执行函数
Widget filtrateBody(var context,var itemDate,String showContent,Function onTap){
 return GestureDetector(
    onTap:onTap,
    child: Container(
      padding: EdgeInsets.only(left:ScreenUtil().setWidth(24),right:ScreenUtil().setWidth(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom:BorderSide(width:0.5,color: Color.fromRGBO(0, 0, 0, 0.16))),
      ),
      width: ScreenUtil().setWidth(750),

      constraints:BoxConstraints(
        minHeight: ScreenUtil().setWidth(96),
      ),

      child:Column(
        mainAxisAlignment:MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("${itemDate['$showContent']}",style: TextStyle(fontSize: ScreenUtil().setWidth(30),color: Color.fromRGBO(139, 137, 151, 1)),softWrap:true),
        ],
      ),
    ),
  );
}
