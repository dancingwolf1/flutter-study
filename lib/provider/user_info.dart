import 'package:flutter/cupertino.dart';


class UserInfo extends ChangeNotifier{
  Map _userInfo =  {
    "headerImageUrl":"",// 头像路径.
    "userName":"",// 用户名.
    "epName":"",// 企业名称.
  };

  Map get userData => _userInfo;// 获得用户信息.

  void setUserInfo(String key,String value){
    _userInfo["$key"] = value;
  }
}