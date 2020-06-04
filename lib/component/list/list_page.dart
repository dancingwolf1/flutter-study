import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spterp/util/public_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库

/// card 的头部
/// [contract] 标题要显示的文字
/// [leftWidget] 右侧的控件
Widget _getCardTop(var contract, {Widget leftWidget}) {
  return Row(
    children: <Widget>[
      Container(
        width: ScreenUtil().setWidth(4),
        height: ScreenUtil().setWidth(32),
        color: usePublicColor(1),
        margin: EdgeInsets.only(right: ScreenUtil().setWidth(26)),
      ),

      Row(children: <Widget>[
        Text(
          contract == null ? "" : contract,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(30),
              height: 1,
              color: usePublicColor(3),
              fontWeight: FontWeight.w800),
        ),
        leftWidget
      ]),

    ],
  );
}

/// card
/// [cardTitle] 卡片头部
/// [leftWidget] 卡片头部右边的控件
/// [content] 接收的对象
/// [onTapFunction] 点击卡片执行的函数
/// [cardContent] 卡片中所要显示的控件

listCard(String cardTitle,Function onTapFunction,Widget cardContent,{
 Widget leftWidget
}){
  if(leftWidget == null){
    leftWidget = SizedBox();
  }
  return GestureDetector(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((ScreenUtil().setWidth(8))),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(
          right: ScreenUtil().setWidth(24),
          left: ScreenUtil().setWidth(24),
          top: ScreenUtil().setWidth(20)),
      child:Column(
        children: <Widget>[
          SizedBox(
            height: ScreenUtil().setWidth(24),
          ),
          _getCardTop(cardTitle,leftWidget:leftWidget),
          SizedBox(
            height: ScreenUtil().setWidth(16),
          ),
          cardContent,
          SizedBox(
            height: ScreenUtil().setWidth(24),
          ),

        ],
      ),
    ),
    onTap: onTapFunction,
  );
}