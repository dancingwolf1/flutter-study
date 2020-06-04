import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/util/user_util.dart';





class AlipayPage extends StatefulWidget {
  @override
  AlipayPageState createState() => AlipayPageState();
}

class AlipayPageState extends State<AlipayPage> {
  var imageUrl = "";
  NetworkImage header;
  bool isloading = false;
  Map<String, dynamic> pageMap = {};
  List<Map<String, dynamic>> dataList = [];
  var collectionCode;
  int eid;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {
      _image();
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text("支付宝收款"),
        ),
        body: Center(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image:  header == null
                        ? AssetImage("images/Alipay.png")
                        : header,
                    fit: BoxFit.cover,
                  )),
            )
        ));
  }

  _image() async {
    String token = await getToken();
    var enterprise =await getEnterprise();
    int eid =enterprise['eid'].hashCode;
    setState(() {
      imageUrl = baseUrl + "/enterprise/getFeedboackPicture?token=$token&eid=$eid&type=2&t=${new DateTime.now()
          .millisecondsSinceEpoch}"; //拼接图片请求地址

      header = NetworkImage(imageUrl);
    });
  }
}




