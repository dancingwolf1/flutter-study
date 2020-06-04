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

class ProblemFeedbackPage extends StatefulWidget {
  @override
  ProblemFeedbackPageState createState() => ProblemFeedbackPageState();
}

class ProblemFeedbackPageState extends State<ProblemFeedbackPage> {
  Map<String, dynamic> user = {};
  String token = "";
  String fbIssue = ""; //问题描述
  String fbPictures = ""; // 图片
  String linkTel = ""; //联系方式
  bool isLoading = false;//上传状态
  var imageUrl = "";
  List feedbackList = [];

  List<NetworkImage> headers = [];

  get feedback => FileUploadPage;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('问题反馈'),
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
                      decoration: InputDecoration(
                          hintText: "请输入不少于10个字的描述。", labelText: "问题描述"),
                      maxLines: 1,
                      onChanged: (String value) {
                        setState(() {
                          fbIssue = value;
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
                    title: new Text("请提供相关问题的截图的照片"),
                    contentPadding: EdgeInsets.all(0.0),
                    enabled: false,
                  ),
                 loading(isLoading,  GridView.count(
                   crossAxisCount: 3,
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
                     onTap: () {
                       setState(() {
                         headers.remove(img);
                       });
                     },
                   ))
                       .toList(),
                 ),text: "图片上传中..."),
                  RaisedButton(
                    onPressed: () async {
                      var image = await ImagePicker.pickImage(
                          source: ImageSource.camera); // 选择文件

                      _uploadFile(image);
                    },
                    child: Text("上传文件(拍照上传)"),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      var image = await ImagePicker.pickImage(
                          source: ImageSource.gallery); // 选择文件
                      _uploadFile(image);
                    },
                    child: Text("上传文件(相册上传)"),
                  ),
                ],
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      keyboardType:TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "请输入手机号。", labelText: "联系方式"),
                      maxLines: 1,
                      onChanged: (String value) {
                        setState(() {
                          linkTel = value;
                        });
                      },
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

  void _uploadFile(File image) async {
    setState(() {
      isLoading = true;
    });
    FormData formData =
        FormData.from({"image": UploadFileInfo(image, 'image.jpg')});
    String feedback = await feedbackHeader(formData);

    Toast.show("上传成功！");
    setState(() {
      isLoading = false;
    });
    String token = await getToken();
    setState(() {

      feedbackList.add(feedback);
      imageUrl = baseUrl + "/feedback/getFeedboackPicture?token=$token&fileName=$feedback"; //拼接图片请求地址

      NetworkImage header = NetworkImage(imageUrl);
      headers.add(header);
    });
  }

  Future _update(context) async {

    fbPictures =feedbackList.toString();
    Map<String, dynamic> userMap = await addFeedback(fbIssue,fbPictures,linkTel);

    Toast.show("提交成功！");
    Navigator.pushNamedAndRemoveUntil(
        context, '/my', (router) => router == null);
  }
}
