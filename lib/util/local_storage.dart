import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spterp/util/user_util.dart';
import 'dart:ui';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
import 'package:flutter_spterp/pages/home/circular_graph.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spterp/pages/home/index_tool.dart';
import 'package:flutter_spterp/util/contorl_date.dart';
import 'package:flutter_spterp/pages/home/barView.dart';
import 'package:flutter_spterp/util/adaptive.dart';

// 操作本地数据读取删除的类

class LocalStorage {
  /// [title]  保存的key值
  /// [content] 保存的数据
  save(String title, String content) async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance(); // 我把权限存储到本地
    prefs.setString(title, content);
  }
  /// [title]  要读取的key值
  /// return 返回 数据
  read(String title) async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance(); // 我把权限存储到本地
    return prefs.getString(title);
  }
  /// [title]  要清除的key值
  remove(String title) async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance(); // 我把权限存储到本地
    prefs.remove(title);
  }
}
