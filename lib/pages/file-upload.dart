import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

import 'package:flutter_spterp/api.dart';

class FileUploadPage extends StatefulWidget {
  @override
  FileUploadPageState createState() => FileUploadPageState();
}

class FileUploadPageState extends State<FileUploadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("图片上传"),
        ),
        body: ListView(
          children: <Widget>[
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
        ));
  }

  Future<String> _uploadFile(File image) async {
    FormData formData = FormData.from(
        {"image": UploadFileInfo(image, 'image.jpg')});
    String feedback = await feedbackHeader(formData);


    Toast.show("上传成功！");

  }
}
