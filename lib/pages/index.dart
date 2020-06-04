import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Index extends StatelessWidget {
  static WebViewController webViewcontroller;
  final CookieManager cookieManager = CookieManager();

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Scaffold(
          body: SafeArea(
            top: true,
            child: WebView(
              initialUrl: "https://erp.hntxrj.com/v2/",
              onWebViewCreated: (_webViewcontroller) {
                _webViewcontroller.clearCache();
                webViewcontroller = _webViewcontroller;
              },
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
        ));
  }
}
