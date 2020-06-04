import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/util/user_util.dart';

class WeChatPage extends StatefulWidget {
  @override
  WeChatPageState createState() => WeChatPageState();
}

class WeChatPageState extends State<WeChatPage> {
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
  Container build(BuildContext context) {
    return   Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image:  header == null
                ? AssetImage("images/WeCat.png")
                : header,
            fit: BoxFit.cover,
          )),
    );
  }

  _image() async {
    String token = await getToken();
    var enterprise =await getEnterprise();
    int eid =enterprise['eid'].hashCode;
      setState(() {
        imageUrl = baseUrl + "/enterprise/getFeedboackPicture?token=$token&eid=$eid&type=1&t=${new DateTime.now()
            .millisecondsSinceEpoch}"; //拼接图片请求地址

        header = NetworkImage(imageUrl);
      });
  }
}
