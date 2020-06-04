import 'package:flutter/material.dart';
import 'package:flutter_spterp/main.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';


void route() {
//  AMap.init('20e6ca332a0a7580917312b16d948519');
  runApp(SptErpApp2());

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

class SptErpApp2 extends StatelessWidget {
  static Map<String, WidgetBuilder> routes;
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: '商品砼手机ERP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          platform: TargetPlatform.android, primaryColor: Colors.blue),
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

}
