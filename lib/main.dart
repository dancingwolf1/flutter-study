import 'package:flutter/material.dart';
import 'package:flutter_spterp/pages/contract/contract_list.dart';
import 'package:flutter_spterp/pages/menu.dart';
import 'package:flutter_spterp/pages/others/page_transfer2.dart';
import 'package:flutter_spterp/pages/sys/payment.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_spterp/pages/sys/bottom.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spterp/pages/index.dart';

import 'package:flutter_spterp/pages/sys/login.dart';
import 'package:flutter_spterp/pages/my.dart';
import 'package:flutter_spterp/pages/news.dart';
import 'package:flutter_spterp/pages/sys/problem_feedback.dart';
import 'package:flutter_spterp/pages/user/user_edit_password.dart';
import 'package:flutter_spterp/pages/user/user_info.dart';

import 'package:flutter_spterp/pages/user/user_management.dart';

import 'package:flutter_spterp/pages/accessories_application_list.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() {
//  AMap.init('20e6ca332a0a7580917312b16d948519');
  runApp(SptErpApp());

/*
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF000000),
    systemNavigationBarDividerColor: null,
    statusBarColor: null,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
*/

  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class SptErpApp extends StatelessWidget {
  static Map<String, WidgetBuilder> routes;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutterStudy1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        platform: TargetPlatform.android,
        primaryColor: Colors.white,
        scaffoldBackgroundColor:Color.fromRGBO(248, 248, 249, 1)
//        primarySwatch:Colors.white,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: Locale('zh'),
      supportedLocales: [
        const Locale('zh', 'CN'),
      ],
      routes: SptErpApp.initroutes(),
    );
  }
  List<charts.Series> seriesList ;
  static initroutes() {
    routes = {
      '/': (context) => LoginPage(),
      '/index': (context) => Index(),
      '/login': (context) => LoginPage(),
//        '/home': (context) => HomePage(),
      '/home': (context) => BottomNavigationWidget(),
      '/news': (context) => NewsPage(),
      '/my': (context) => MyPage(),
      '/contract-list': (context) => ContractListPage(),
      '/user-info': (context) => UserPage(),
      '/user-edit-password': (context) => UserPasswordPage(),
      '/problem-feedback': (context) => ProblemFeedbackPage(),
      '/payment': (context) => PaymentPage(),
      '/menu': (context) => MenuPage(),
      '/accessories': (context) => AccessoriesListPage(),
      '/user_list': (context) => UserManagementPage(),
      '/page_transfer': (context) => PageTransfPage2(),
    };
    return routes;
  }
}
