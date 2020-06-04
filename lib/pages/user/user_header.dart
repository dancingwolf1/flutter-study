import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

import 'package:flutter_spterp/api.dart';

class UserHeaderPage extends StatefulWidget {
  @override
  UserHeaderPageState createState() => UserHeaderPageState();
}

class UserHeaderPageState extends State<UserHeaderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("头像上传"),
        ),
        body: ListView(
          children: <Widget>[
            RaisedButton(
              onPressed: () async {
                var image = await ImagePicker.pickImage(
                    source: ImageSource.camera); // 选择文件

                _uploadFile(image);
              },
              child: Text("上传头像(拍照上传)"),
            ),
            RaisedButton(
              onPressed: () async {
                var image = await ImagePicker.pickImage(
                    source: ImageSource.gallery); // 选择文件
                _uploadFile(image);
              },
              child: Text("上传头像(相册上传)"),
            ),
          ],
        ));
  }

  Future<Map<String, dynamic>> _uploadFile(File image) async {
    FormData formData = FormData.from(
        {"file": UploadFileInfo(image, 'file.jpg')});
    Map<String, dynamic> userMap =await userHeader(formData);


    Toast.show("上传成功！");
    Navigator.pushNamed(context, "/my");
  }
}
