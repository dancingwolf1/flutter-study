import 'package:flutter/material.dart';

Widget noMore() {
  return Container(
    margin: EdgeInsets.only(top: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset("images/nomore.png", width: 200, height: 200),
        Text(
          "暂无数据",
          style: TextStyle(color: Colors.grey[300]),
        )
      ],
    ),
  );
}
