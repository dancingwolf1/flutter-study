import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spterp/util/adaptive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
import 'package:flutter_spterp/component/appbar.dart';

class ContractUploadPage extends StatefulWidget {
  final String contractDetailCode;

  final String contractUid;

  ContractUploadPage(this.contractUid, this.contractDetailCode);

  @override
  ContractUploadPageState createState() => ContractUploadPageState();
}

class ContractUploadPageState extends State<ContractUploadPage> {
  List<dynamic> images = [];
  List<Widget> lists = [];

  void initState() {
    super.initState();
    loadData();
  }

  Future loadData({data}) async {
    List<dynamic> result;
    if (data == null) {
      result = await getAdjunct(widget.contractUid, widget.contractDetailCode);
    } else {
      lists = [];
      result = data;
    }

    setState(() {
      images = result;
    });
    for (var i = 0; i < result.length; i++) {
      setState(() {
        lists.add(_pictureItem(i));
      });
    }
    setState(() {
      lists.add(_addItem());
    });
  }

  @override
  Widget build(BuildContext context) {
    adaptation(context);
    return Scaffold(
      appBar: getAppBar(context, "纸质合同",isRightButton: false),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          GridView.count(
            primary: false,
            shrinkWrap: true,
            crossAxisCount: 2,
            children: lists.map((Widget w) {
              return w;
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _image;
  int _i;

  getPage(i) => Scaffold(
        body: Material(
          color: Colors.black,
          shadowColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              ExtendedImageGesturePageView.builder(
                itemBuilder: (BuildContext context, int index) {
                  var item = contractModel['adjunct'] +
                      "/" +
                      images[index]['adjunctFileName'];

                  _image = ExtendedImage.network(
                    item,
                    fit: BoxFit.contain,
//                    mode: ExtendedImageMode.Gesture,
                  );
                  _image = Container(
                    child: _image,
                    padding: EdgeInsets.all(5.0),
                  );
                  if (i == index) {
                    return Hero(
                      tag: item + index.toString(),
                      child: _image,
                    );
                  } else {
                    return _image;
                  }
                },
                itemCount: images.length,
                onPageChanged: (int _index) {

                  setState(() {
                    _i = _index;
                  });
                },
                controller: PageController(
                  initialPage: i,
                ),
                scrollDirection: Axis.horizontal,
              )
            ],
          ),
        ),
      );

  Widget _pictureItem(i) {
    var item = contractModel['adjunct'] + "/" + images[i]['adjunctFileName'];
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
//                color: Colors.red,
                borderRadius:
                BorderRadius.circular(ScreenUtil().setWidth(12)),
                border: Border.all(
                  color: Colors.grey[200],
                  width: 1,
                ),
              ),
              child: Image.network(
                item,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              height: 20,
              width: 20,
              color: Colors.blue,
              child: Text(
                "${i + 1}",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child:Padding(
                padding: EdgeInsets.only(bottom: 10),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      child: Image.asset("images/paper_edit.png"),
                      onTap: (){
                        _updatePicture(i);
                      },
                    ),
                    GestureDetector(
                      child: Image.asset("images/paper_delete.png"),
                      onTap: (){
                        _delPicture(i);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            TransparentCupertinoPageRoute(
                builder: (BuildContext context) => getPage(i)));
      },
    );
  }

  _delPicture(index) async {
    try {

      var result = await delAdjunct(images[index]['adjunctFileName']);
      loadData(data: result);
    } catch (e) {

      Toast.show("修改图片失败");
    }
  }

  _updatePicture(index) async {
    File f = await ImagePicker.pickImage(source: ImageSource.camera);
    if (f == null) {

      return;
    }
    _delPicture(index);

    File f1 = await FlutterImageCompress.compressAndGetFile(
      f.absolute.path,
      f.absolute.path,
      quality: 80,
    );


    String fileName = f1.path.split("/")[f.path.split("/").length - 1];

    var result = await uploadAdjunct(
        widget.contractUid,
        widget.contractDetailCode,
        images[index]['adjunctNum'],
        UploadFileInfo(f, fileName));
    loadData(data: result);
  }

  _addPicture({int num}) async {
    File f = await ImagePicker.pickImage(source: ImageSource.camera);
    if (f == null) {

      return;
    }

    File f1 = await FlutterImageCompress.compressAndGetFile(
      f.absolute.path,
      f.absolute.path,
      quality: 80,
    );


    String fileName = f1.path.split("/")[f.path.split("/").length - 1];

    var result = await uploadAdjunct(
        widget.contractUid,
        widget.contractDetailCode,
        num == null ? images.length + 1 : num,
        UploadFileInfo(f, fileName));
    loadData(data: result);
  }

  _addItem() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: _addPicture,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue,
              width: 1,
            ),
          ),
          child: Icon(
            Icons.add,
            size: 20,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
