
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spterp/component/toast.dart';


class ScannerPage extends StatefulWidget {
  @override
  ScannerPageState createState() => ScannerPageState();
}

class ScannerPageState extends State<ScannerPage> {

  bool loadOk = true;
  var privacyHeight = 1.7;
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title:Text("Scanner"),
          ),
         body:loadOk
             ? SingleChildScrollView(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               GestureDetector(
                 onTap: () => scan(),
                 child: Icon(
                   Icons.crop_free,
                   color: Color.fromRGBO(139, 137, 151, 1),
                 ),
               ),
               Text("扫一扫",
                   style: TextStyle(
                       fontSize: ScreenUtil().setSp(20),
                       color: Color.fromRGBO(139, 137, 151, 1))),
             ],
           ),
         )
             : Container(),
        )
      ],
    );
  }


  /// 扫码
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      print(barcode);
    }  catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        Toast.show("只有为APP开启相机权限才能扫码");
        return;
      } else {
        Toast.show("扫码异常:" + e.message);
        return;
      }
    }
//    on FormatException {
//      Toast.show("获取内容失败");
//      return;
//    } catch (e) {
//      Toast.show("扫码异常: $e");
//      return;
//    }

  }



}

