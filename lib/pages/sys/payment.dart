import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:flutter_spterp/pages/file-upload.dart';
import 'package:flutter_spterp/util/user_util.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/loading.dart';

class PaymentPage extends StatefulWidget {
  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage>
    with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController _tabController;

  //  page代表当前页码(page1代表的是第一个table的当前页码,page2代表的是第二个table的当前页码......)
  int page1 = 1;
  int page2 = 1;


  int timeButton = 0;

  double total1 = 0;
  double total2 = 0;

  bool isLoading1 = false;
  bool isLoading2 = false;

  bool _loading1 = false;
  bool _loading2 = false;

  Map<String, dynamic> pageMap1 = {};
  Map<String, dynamic> pageMap2 = {};

  List<Map<String, dynamic>> dataList1 = [];
  List<Map<String, dynamic>> dataList2 = [];

  List tabs = ["支付宝", "微信"];
  List isLoadingList = [
    {"支付宝": true},
    {"微信": false}
  ];

  Map<String, dynamic> user = {};
  String token = "";
  int type =0;
  String fbPictures = ""; // 图片
  int eid;
  var imageUrl = "";
  List feedbackList = [];
  bool loadOk = true;
  List<NetworkImage> headers = [];
  NetworkImage headerWechat;
  NetworkImage headerAlipay;
  get feedback => FileUploadPage;
  Map<String, dynamic> selectedPayment = {}; // 选中的收款方式
  TextEditingController _selectedPaymentController; // 选中后收款方式控制器

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _tabController = TabController(length: tabs.length, vsync: this);
    setState(() {
      _wechatImage();
      __alipayImage();
      _loading1 = true;
      _loading2 = true;
    });

    _loadDate1();
    _loadDate2();

    setState(() {
      _selectedPaymentController = new TextEditingController();
    });
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("二维码支付"),
        bottom: TabBar(
            controller: _tabController,
            labelColor: Color.fromRGBO(50, 150, 250, 1),
            unselectedLabelColor: Color.fromRGBO(139, 137, 151, 1),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: tabs.map((e) => Tab(text: e)).toList()),
      ),
      body: Stack(
        children: <Widget>[
          TabBarView(controller: _tabController, children: [
            loading(
                _loading1,
                Stack(

                  children: <Widget>[
                    _shortcutZhifubaoMenu(),
                  ],
                )
            ),
            loading(
                _loading2,
                Stack(

                  children: <Widget>[
                    _shortcutWeixinMenu(),
                  ],
                )

            )
          ]),
        ],
      ),
    );
  }

  Future _loadDate1() async {
    if (!isLoading1) {
      setState(() {
        isLoading1 = true;
      });
      Map<String, dynamic> result = await getWeightByMat(
          page:page1,
          pageSize: 10
      );

      Map<String, dynamic> resultEnd = await getWeightClose(
      );

      setState(() {
        pageMap1 = result;

        if (resultEnd['arr'][0] == null) {
          total1 = 0;
        }

        if (resultEnd['arr'][0] != null) {
          total1 = resultEnd['arr'][0]['totalClWeight'];
        }

        if (result['arr'] != null) {
          for (var item in result['arr']) {
            dataList1.add(item);
          }
          pageMap1.remove("arr");
          page1++;
        }
        isLoading1 = false;
        _loading1 = false;
      });
    }
  }
  Future _loadDate2() async {

    if (!isLoading2) {
      setState(() {
        isLoading2 = true;
      });
      Map<String, dynamic> result = await getWeightByVechicId(page2
          );

      Map<String, dynamic> resultEnd = await getWeightClose(
          );

      setState(() {
        pageMap2 = result;

        if (resultEnd['arr'][0] == null) {
          total2 = 0;
        }

        if (resultEnd['arr'][0] != null) {
          total2 = resultEnd['arr'][0]['totalClWeight'];
        }

        if (result['arr'] != null) {
          for (var item in result['arr']) {
            dataList2.add(item);
          }
          pageMap2.remove("arr");
          page2++;
        }
        isLoading2 = false;
        _loading2 = false;
      });
    }
  }


//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('二维码支付'),
//        actions: <Widget>[
//          FlatButton(
//            child: Text(
//              "提交",
//              style: TextStyle(color: Colors.white),
//            ),
//            onPressed: () {
//              _update(context);
//            },
//          )
//        ],
//      ),
//      body: ListView(
//        children: <Widget>[
//          _shortcutMenu(),
//        ],
//      ),
//    );
//  }
//
  _shortcutZhifubaoMenu() {
    return Column(
      children: <Widget>[
//        headerAlipay ==null ?
      1==1 ?
        Card(
        child: Column(
          children: <Widget>[
            Column(
              children: [
                GridView.count(
                  crossAxisCount: 1,
                  primary: false,
                  shrinkWrap: true,
                  children: headers
                      .map((img) => GestureDetector(
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
//                       shape: BoxShape.circle,
                        image: DecorationImage(
//                         fit: BoxFit.fill,
                          image: img == null ? AssetImage("") : img,
                        ),
                      ),
                    ),
//                              onTap: () {
//                                setState(() {
//                                  headers.remove(img);
//                                  feedbackList =[];
//                                  loadOk=true;
//                                });
//                              },
                  ))
                      .toList(),
                ),
                OutlineButton(
                    onPressed: loadOk? () async {
                      try{
                        var image = await ImagePicker.pickImage(
                            source: ImageSource.gallery); // 选择文件
                        _uploadFile(image);
                      }catch(v){
                        Toast.show("请打开读取本地图片的权限！");
                      }

                    }:() async{
                      setState(() {
                        headers=[];
                        feedbackList =[];
                        loadOk=true;
                      });
                    },
                    child: Column(
                        children: <Widget>[
                          Card(
                            margin:EdgeInsets.fromLTRB(0.0, 55.0, 0, 50) ,
                            child: Icon(Icons.add),
                          ),
                          Card(
                            elevation:0,
                            shape:RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.white,
                                  width: 0,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(0))),
                            child: Text(loadOk? "请上传\n         您的支付宝收款码           \n\n\n\n\n":"重选",
                              textAlign: TextAlign.center,
                            ),
                          ),

                        ]
                    )
                ),
              ],
            ),
          ],
        ),
      ):
        Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding: new EdgeInsets.fromLTRB(65, 15, 65, 80),
                child: Column(
                  children: [
                    Container(
                      width: 240.0,
                      height: 360.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: headerAlipay
                        ),
                      ),
                    ),
//                    Container(
//                      margin: EdgeInsets.fromLTRB(5.0,5.0, 5.0, 5.0),
//                      child:new Container(
//                        child: new Image.asset('images/zhifubao.png'),
//                      ),
//                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  _shortcutWeixinMenu() {
    return Column(
      children: <Widget>[
//        headerWechat== null ?
      1==1?
        Card(
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  GridView.count(
                    crossAxisCount: 1,
                    primary: false,
                    shrinkWrap: true,
                    children: headers
                        .map((img) => GestureDetector(
                      child: Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
//                       shape: BoxShape.circle,
                          image: DecorationImage(
//                         fit: BoxFit.fill,
                            image: img == null ? AssetImage("") : img,
                          ),
                        ),
                      ),
//                              onTap: () {
//                                setState(() {
//                                  headers.remove(img);
//                                  feedbackList =[];
//                                  loadOk=true;
//                                });
//                              },
                    ))
                        .toList(),
                  ),
                  OutlineButton(
                    onPressed: loadOk? () async {
                      try{
                        var image = await ImagePicker.pickImage(
                            source: ImageSource.gallery); // 选择文件
                        _uploadFile(image);
                      }catch(v){
                        Toast.show("请打开读取本地图片的权限！");
                      }

                    }:() async{
                      setState(() {
                        headers=[];
                        feedbackList =[];
                        loadOk=true;
                      });
                    },
                    child: Column(
                        children: <Widget>[
                          Card(
                            margin:EdgeInsets.fromLTRB(0.0, 55.0, 0, 50) ,
                            child: Icon(Icons.add),
                          ),
                          Card(
                            elevation:0,
                            shape:RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.white,
                                  width: 0,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(0))),
                            child: Text(loadOk? "请上传\n         您的微信收款码           \n\n\n\n\n":"重选",
                      textAlign: TextAlign.center,
                    ),
                          ),

                        ]
                    )
                  ),
                ],
              ),
            ],
          ),
        ):
        Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding: new EdgeInsets.fromLTRB(65, 45, 65, 50),
                child: Column(
                  children: [
                    Container(
                      width: 240.0,
                      height: 360.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: headerWechat
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _wechatImage() async {
    String token = await getToken();
    var enterprise =await getEnterprise();
    int eid =enterprise['eid'].hashCode;
    setState(() {
      imageUrl = baseUrl + "/enterprise/getFeedboackPicture?token=$token&eid=$eid&type=1&t=${new DateTime.now()
          .millisecondsSinceEpoch}"; //拼接图片请求地址
      headerWechat = NetworkImage(imageUrl);
    });
  }
  __alipayImage() async {
    String token = await getToken();
    var enterprise =await getEnterprise();
    int eid =enterprise['eid'].hashCode;
    setState(() {
      imageUrl = baseUrl + "/enterprise/getFeedboackPicture?token=$token&eid=$eid&type=2&t=${new DateTime.now()
          .millisecondsSinceEpoch}"; //拼接图片请求地址

      headerAlipay = NetworkImage(imageUrl);
    });
  }
  void _uploadFile(File image) async {
    FormData formData =
    FormData.from({"image": UploadFileInfo(image, 'image.jpg')});
    String feedback = await uploadPicture(formData);

    Toast.show("上传成功！");
    String token = await getToken();
    setState(() {

      feedbackList.add(feedback);
      if(feedbackList.length==0){
        loadOk=true;
      }else{
        loadOk=false;
      }
      imageUrl = baseUrl + "/enterprise/getimage?fileName=$feedback&token=$token"; //拼接图片请求地址

      NetworkImage header = NetworkImage(imageUrl);
      headers.add(header);
    });
  }

//  Future _update(context) async {
//
//    if ((selectedPayment['code'] == ""|| selectedPayment['code'] ==null )) {
//      Toast.show("请选择收款方式");
//      return;
//    }
//
//    if ((feedbackList.length ==0)) {
//      Toast.show("请上传收款码");
//      return;
//    }
//    fbPictures = feedbackList.toString();
//    type = selectedPayment['code'];
//    var enterprise =await getEnterprise();
//    eid =enterprise['eid'].hashCode;
//
//    Map<String, dynamic> userMap =
//        await saveCollectionCode(eid, fbPictures, type);
//
//    Toast.show("提交成功！");
//    Navigator.pop(context);
//  }

}