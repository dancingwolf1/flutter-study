import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库

/// 搜索框
/// [searchController]  搜索框控制器
/// [hintText] 搜索框提示文字
/// [searchF] 搜索框输入文字时触发的回调函数
filtrateInput(TextEditingController searchController,String hintText,Function searchF,){
  return Container(
    padding: EdgeInsets.all(8),
    color: Color.fromRGBO(248, 248, 249, 1),
    child: Container(
        color: Color.fromRGBO(248, 248, 249, 1),
        height: ScreenUtil().setWidth(80),
        child: new Card(
            elevation: 0,
            child: new Container(
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 5.0,
                  ),
                  Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: TextField(
                        onChanged:searchF,
                        controller: searchController,
                        decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(top: 0.0),
                            hintText: '$hintText',
                            hintStyle:  TextStyle(
                                color: Color.fromRGBO(201, 199, 210, 1)
                            ),
                            border: InputBorder.none
                        ),
                        // onChanged: onSearchTextChanged,
                      ),
                    ),
                  ),
                  new IconButton(
                    icon: new Icon(Icons.clear),
                    color: Colors.grey,
                    iconSize: 18.0,
                    onPressed: () {
                      searchController.clear();
                      // onSearchTextChanged('');
                    },
                  ),
                ],
              ),
            ))),
  );
}
