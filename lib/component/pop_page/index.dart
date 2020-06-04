import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// 公共的弹出层
/// [context]  上下文
/// [content] 弹出层所展示的内容
/// [title] 弹出层的标题
/// [radio] 圆角效果的大小
popPage(var context,Widget content,String title,{double radio = 20.0}){
  showDialog(
      context: context,
      builder: (context) {
        return new AlertDialog(
            backgroundColor:Colors.white,
          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(radio)) ,
          title: new Text(title),
          content:
          new StatefulBuilder(builder: (context, StateSetter setState) {
            return content;
          }),
        );
      });
}