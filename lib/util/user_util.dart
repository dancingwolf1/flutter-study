import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> getUser() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String userStr = pref.getString("user");
  if (userStr == null || userStr == "") {
    return null;
  } else {
    return json.decode(userStr);
  }
}

Future<String> getToken() async {
  Map<String, dynamic> userMap = await getUser();
  return userMap['token'];
}

Future<Map<String, dynamic>> getEnterprise() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String enterpriseStr = pref.getString("selectedEnterprise");
  if (enterpriseStr == null || enterpriseStr == "") {
    ///  如果未选择就获取第一个
    Map<String, dynamic> userMap = await getUser();
    enterpriseStr = json.encode(userMap['enterprises'][0]);
  }
  return json.decode(enterpriseStr);
}
