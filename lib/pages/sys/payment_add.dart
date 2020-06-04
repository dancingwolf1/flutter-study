import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spterp/component/payment_method.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:flutter_spterp/pages/file-upload.dart';
import 'package:flutter_spterp/util/user_util.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_spterp/api.dart';

class PaymentaddPage extends StatefulWidget {
  @override
  PaymentaddPageState createState() => PaymentaddPageState();
}

class PaymentaddPageState extends State<PaymentaddPage> {
  Map<String, dynamic> user = {};
  String token = "";
  int type =0;
  String fbPictures = ""; // 图片
  int eid;
  var imageUrl = "";
  List feedbackList = [];
  bool loadOk = true;
  List<NetworkImage> headers = [];

  get feedback => FileUploadPage;
  Map<String, dynamic> selectedPayment = {}; // 选中的收款方式
  TextEditingController _selectedPaymentController; // 选中后收款方式控制器

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() {
      _selectedPaymentController = new TextEditingController();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加收款码'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "提交",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _update(context);
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          _shortcutMenu(),
//          _loginBtn(context),
        ],
      ),
    );
  }

  _shortcutMenu() {


    return Column(
      children: <Widget>[
        Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _selectedPaymentController,
                      enableInteractiveSelection: false,
                      decoration: InputDecoration(
                          icon: Icon(Icons.attach_money), hintText: "请选择收款方式"),
                      onTap: () async {
                        Map<String, dynamic> _selectSalesman =
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentMethodPage()));
                        if (_selectSalesman == null) {
                          return;
                        }
                        setState(() {
                          selectedPayment = _selectSalesman;
                          _selectedPaymentController.text =
                              selectedPayment['name'].toString();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  ListTile(
                    title: new Text("请上传相应的收款码"),
                    contentPadding: EdgeInsets.only(left: 40.0),
                    enabled: false,
                  ),
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
                  RaisedButton(
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
                    child: Text(loadOk? "上传付款码(相册上传)":"重选"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
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

  Future _update(context) async {

    if ((selectedPayment['code'] == ""|| selectedPayment['code'] ==null )) {
      Toast.show("请选择收款方式");
      return;
    }

    if ((feedbackList.length ==0)) {
      Toast.show("请上传收款码");
      return;
    }
    fbPictures = feedbackList.toString();
    type = selectedPayment['code'];
    var enterprise =await getEnterprise();
    eid =enterprise['eid'].hashCode;

    Map<String, dynamic> userMap =
        await saveCollectionCode(eid, fbPictures, type);

    Toast.show("提交成功！");
    Navigator.pop(context);
  }
}
