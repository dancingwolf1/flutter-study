import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:flutter_spterp/util/public_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库


Widget contentRowViewPublic(String title, var value, {bool ell = false,double fontSize,Widget endWidget,double textHeight = 6}) {

  if(fontSize == null){
    fontSize = ScreenUtil().setSp(26);
  }

  TextStyle titleStyle = TextStyle(fontSize: fontSize, color: Color.fromRGBO(139, 137, 151, 1));
  TextStyle valueStyle = TextStyle(color:usePublicColor(3),fontSize: fontSize);
  if (value == null || value == "null") {
    value = "";
  }

  return Padding(
      padding: EdgeInsets.only(top: textHeight, bottom: textHeight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            "${title.toString()}:  ",
            style: titleStyle,
          ),
          title.toString() == '邀请码'
              ? Expanded(
                  child: RaisedButton(
                    child: Container(
                      constraints: BoxConstraints(minHeight: 24.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child:
                              Text("${value.toString()}", style: valueStyle)),
                    ),
                    onPressed: () {
                      ClipboardData data =
                          new ClipboardData(text: value.toString());
                      Clipboard.setData(data);
                      Toast.show("复制成功");
                    },
                  ),
                )
              : Expanded(
                  child: Container(
//                    constraints: BoxConstraints(minHeight: 24.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("${value.toString()}", style: valueStyle,softWrap: false,overflow: TextOverflow.ellipsis,)),
                  ),
                ),
          Container(
              child: ell ? Icon(Icons.more_horiz, color: Colors.grey) : null),
          endWidget == null?SizedBox():endWidget
        ],
      ));
}
