import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


/// 公共的颜色
/// [type] 想要得到的颜色
/// type = 1，代表常用蓝色
/// type = 2，代表常用灰色
/// type = 3，代表常用文字黑色
/// type = 4, 淡红色背景
/// type = 5, 红色
/// type = 6, 黄色
/// type = 7, 淡黄色
/// type = 8, 淡蓝色
/// type = 9, 背景灰
Color usePublicColor(int type) {
  Color item;
  switch (type) {
    case 1:
      item = Color.fromRGBO(50, 150, 250, 1);
      break;
    case 2:
      item = Color.fromRGBO(139, 137, 151, 1);
      break;
    case 3:
      item = Color.fromRGBO(59, 57, 73, 1);
      break;
    case 4:
      item = Color.fromRGBO(254, 113, 95, 0.1);
      break;
    case 5:
      item = Color.fromRGBO(242, 86, 68, 1);
      break;
    case 6:
      item = Color.fromRGBO(255, 160, 1, 1);
      break;
    case 7:
      item = Color.fromRGBO(255, 160, 1, 0.1);
      break;
    case 8:
      item = Color.fromRGBO(53, 134, 249,0.1);
      break;
    case 9:
      item = Color.fromRGBO(248, 248, 249, 1);
      break;
//      Color.fromRGBO(248, 248, 249, 1)
    default:
      item = Colors.red;
  }
  return item;
}
