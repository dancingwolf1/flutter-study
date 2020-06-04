import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:flutter_spterp/component/loading.dart';

class RightsAddPage extends StatefulWidget {
  @override
  RightsAddPageState createState() => RightsAddPageState();
}

class RightsAddPageState extends State<RightsAddPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _formKey = GlobalKey<FormState>();
  bool isEnable = true;
  bool isLoading = false;
  String agName = "";
  String agStatus;

  TextEditingController _selectAgNameController;

  @override
  void initState() {
    super.initState();
    _selectAgNameController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("添加权限组"),
        ),
        body: loading(
            isLoading,
            Form(
                key: _formKey,
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ListView(
                      padding: EdgeInsets.only(right: 8.0, left: 8.0),
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: RichText(
                                  text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    color: Color(0xffff0000),
                                    fontSize: 20.0,
                                  ),
                                )
                              ])),
                              flex: 1,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _selectAgNameController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.list),
                                    labelText: "权限组名称",
                                    hintText: "请输入权限组名称"),
                                onChanged: (value) {
                                  setState(() {
                                    agName = value;
                                  });
                                },
                              ),
                              flex: 20,
                            )
                          ],
                        ),
                        /*              Row(
                      children: <Widget>[
                        Expanded(
                          child: RichText(
                              text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                color: Color(0xffff0000),
                                fontSize: 20.0,
                              ),
                            )
                          ])),
                          flex: 1,
                        ),
                        Expanded(
                          child: TextField(
//                          controller: _selectContractCodeController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            decoration: InputDecoration(
                                icon: Icon(Icons.compare),
                                labelText: "所属企业",
                                hintText: "请选择企业"),
                            onChanged: (value) {
                              setState(() {
//                              contractCode = value;
                              });
                            },
                          ),
                          flex: 20,
                        )
                      ],
                    ),*/
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      "状态:",
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                child: Container(
                                  child: CheckboxListTile(
                                      title:
                                          Text("启用", textAlign: TextAlign.left),
                                      value: isEnable,
                                      onChanged: (bool) {

                                        setState(() {
                                          isEnable = !isEnable;
                                        });

                                      }),
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                child: Container(
                                  child: CheckboxListTile(
                                      title: Text("停用"),
                                      value: !isEnable,
                                      onChanged: (bool) {
                                        setState(() {
                                          isEnable = !isEnable;
                                        });
                                      }),
                                ),
                                flex: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )))),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(top: 18.0, right: 10.0, left: 10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  child: Text(
                    "确定",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {

                    sendSave();
                  },
                  color: Colors.blueAccent,
                ),
              )
            ],
          ),
        ));
  }

  sendSave() async {
    if (agName.trim().length <= 0) {
      Toast.show("权限组名称不能为空");
      return;
    }
    if (isEnable) {
      agStatus = "0";
    } else if (!isEnable) {
      agStatus = "1";
    }
    setState(() {
      isLoading = true;
    });
    await editAuthGroupV2(
      agName: agName,
      agStatus: agStatus,
      project: "0",
    );
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
    Toast.show("添加权限组成功");
  }
}
