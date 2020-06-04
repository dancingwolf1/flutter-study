import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spterp/util/public_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
/// 页面的头部
/// [context]  上下文
/// [breakFunction] 点击返回箭头执行的函数
/// [title]  页面标题
/// [funnel]  点击右边执行的函数
/// [isRightButton] 是否有右边的按钮
/// [bottom] 底部控件

getAppBar(var context,String title,{Function funnel,Function breakFunction,isRightButton=true,Widget bottomWidget,Widget actions}){

  List<Widget> actionsList = [
    isRightButton?IconButton(
        icon: Image.asset("images/conteract_funnel.png",width: ScreenUtil().setWidth(40),height: ScreenUtil().setWidth(40)),
        onPressed: funnel
    ):SizedBox(),
  ];// 右侧点击事件
  if(breakFunction == null){
    breakFunction = (){
      Navigator.of(context).pop();
    };
  }
  if(actions != null){
    actionsList.add(
        actions
    );
  }
  if(bottomWidget != null){
  }


  return AppBar(
    backgroundColor:Colors.white,
    centerTitle: true,
    bottom:bottomWidget,
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios,color:usePublicColor(2)),
      onPressed:breakFunction,
    ),
    elevation: 0.0,
    title: Text("$title",style: TextStyle(fontWeight: FontWeight.w600,fontSize: ScreenUtil().setSp(32),color: Colors.black),),
    actions: actionsList,
  );
}