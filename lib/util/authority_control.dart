import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 根据isShow参数的值来决定是否要显示该视图
/// [isShow] 是否显示
/// [view] 显示的视图
Widget authorityControl(bool isShow,Widget view){
  return Offstage(
    offstage: !isShow,
    child: view,
  );
}

