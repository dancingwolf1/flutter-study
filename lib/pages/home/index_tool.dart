import 'package:flutter/material.dart';

/// 该方法科技将传入的值,转换为string,int,double输出来,并可以选择保留几位小数
///[accept]传入的值
///[digit]保留小数点多少位
///[returnType]转成什么样的格式输出

approximateValue(var accept,int digit,{String returnType:"String"}){
  double number = double.parse(accept.toString());
  var endNumber;
  switch(returnType){
   case "String":
     endNumber = number.toStringAsFixed(digit).toString();
   break;
    case "int":
     endNumber = int.parse(number.toStringAsFixed(digit));
   break;
    case "double":
     endNumber = double.parse(number.toStringAsFixed(digit));
   break;

  }
  return endNumber;
}