import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:flutter_spterp/component/select_requestStatuscode.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:flutter_spterp/component/update_requestStatuscode.dart';
import 'accessories_edit.dart';
import 'package:flutter_spterp/component/list_info.dart';

class AccessoriesDetailsPage extends StatefulWidget {
  AccessoriesDetailsPage(this.details);

  final Map details;

  @override
  AccessoriesDetailsPageState createState() => AccessoriesDetailsPageState();
}

class AccessoriesDetailsPageState extends State<AccessoriesDetailsPage> {
  TextStyle labelStyle = TextStyle(fontSize: 17.0, color: Colors.blueGrey);
  TextStyle valueStyle = TextStyle(fontSize: 16.0, color: Colors.black87);

  Map<String, dynamic> taskDetailDate;
  Map<String, dynamic> selectRequestStatus = {};

  TextEditingController _selectRequestStatusController;

  bool isLoaded = false;

  String isReview = "";
  String requestStatusCode = "";

  Map auth = {
    "审核": false,
    "编辑": false,
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() {
    _selectRequestStatusController = new TextEditingController();
    getAuth();
    _loadDate();
  }

  _loadDate() async {
    Map<String, dynamic> _detailsDate =
        await getRequestNumberDetail(widget.details['requestNumber']);

    setState(() {
      taskDetailDate = _detailsDate;

      isReview = taskDetailDate['verifyStatusOne'];
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("配件申请单详情"),
      ),
      body: isLoaded
          ? GestureDetector(
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(15.0),
                    color: Colors.black12,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "${taskDetailDate['requestNumber']}",
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        contentRowViewPublic(
                            "申请模式", taskDetailDate['requestMode']),
                        contentRowViewPublic(
                            "申请单状态", taskDetailDate['requestStatus']),
                        contentRowViewPublic("申请部门", taskDetailDate['name']),
                        contentRowViewPublic(
                            "申  请  人", taskDetailDate['buyer']),
                        contentRowViewPublic(
                            "配件名称", taskDetailDate['goodsName'].toString()),
                        contentRowViewPublic(
                            "配件规格", taskDetailDate['specification'].toString()),
                        contentRowViewPublic(
                            "数        量", taskDetailDate['num'].toString()),
                        contentRowViewPublic(
                            "申请描述", taskDetailDate['requestDep'].toString()),
                        contentRowViewPublic(
                            "备        注", taskDetailDate['remarks'].toString()),
                        contentRowViewPublic(
                            "创建时间", taskDetailDate['createTime'].toString()),
                        contentRowViewPublic(
                            "审核时间", taskDetailDate['verifyTimeOne'].toString()),
                        contentRowViewPublic("审  核  人",
                            taskDetailDate['verifyIdOne'].toString()),
                        contentRowViewPublic(
                            "审核状态",
                            taskDetailDate['verifyStatusOne'].toString() == "0"
                                ? "未  审  核"
                                : "已  审  核"),
                        contentRowViewPublic("审核结果",
                            taskDetailDate['auditResultOne'].toString()),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: auth["审核"]
                              ? RaisedButton(
                                  color: isReview.toString() == "0"
                                      ? Colors.blue
                                      : Color.fromRGBO(255, 160, 1, 1),
                                  child: Text(
                                    isReview.toString() == "0" ? "审核" : "取消审核",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    // 弹出层
                                    if (isReview == "0") {
                                      getEject();
                                    } else {
                                      editEject();
                                    }
                                  })
                              : null,
                        ),
                      ),
                      isReview.toString() == "0"
                          ? Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: auth["编辑"]
                                      ? RaisedButton(
                                          color: Colors.blue,
                                          child: Text(
                                            "编辑",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () async {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AccessoriesEditPage(
                                                            taskDetailDate)));
                                            setState(() {
                                              _loadDate();
                                            });
                                          })
                                      : Container()),
                            )
                          : Container(),
                    ],
                  )
                ],
              ),
            )
          : loading(!isLoaded, Container()),
    );
  }

  // 借用一下

  getEject() {
    return showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          title: new Text('申请审核'),
          children: <Widget>[
            TextField(
              controller: _selectRequestStatusController,
              maxLines: 1,
              decoration: InputDecoration(
                icon: Icon(Icons.assessment),
                hintText: "请选择审核状态",
                suffixIcon: Icon(Icons.chevron_right),
              ),
              onTap: () async {
                Map<String, dynamic> result = await Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => SelectRequestStatusCodePage()));
                if (result == null) {
                  return;
                }
                setState(() {
                  selectRequestStatus = result;
                });
                _selectRequestStatusController.text =
                    selectRequestStatus['name'];
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text("审核"),
                  onPressed: () async {
                    setState(() {
                      isReview = "1";
                    });
                    await editRequestStatus(
                      requestNumber: taskDetailDate['requestNumber'],
                      requestStatus: selectRequestStatus['code'],
                    );
                    Toast.show("审核成功");
                    setState(() {
                      _selectRequestStatusController =
                          new TextEditingController();
                    });
                    Navigator.of(context).pop();
                    _loadDate();
                  },
                ),
                RaisedButton(
                  child: Text("取消"),
                  onPressed: () {
                    // 取消回退
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    ).then((val) {

    });
  }

  editEject() {
    return showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          title: new Text('取消审核'),
          children: <Widget>[
            TextField(
              controller: _selectRequestStatusController,
              maxLines: 1,
              decoration: InputDecoration(
                icon: Icon(Icons.assessment),
                hintText: "请选择审核状态",
                suffixIcon: Icon(Icons.chevron_right),
              ),
              onTap: () async {
                Map<String, dynamic> result = await Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => UpdateRequestStatusCodePage()));
                if (result == null) {
                  return;
                }
                setState(() {
                  selectRequestStatus = result;
                });
                _selectRequestStatusController.text =
                    selectRequestStatus['name'];
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text("审核"),
                  onPressed: () async {
                    setState(() {
                      isReview = "1";
                    });
                    await cancelRequestStatus(
                      requestNumber: taskDetailDate['requestNumber'],
                      requestStatus: selectRequestStatus['code'],
                    );

                    Toast.show("审核成功");
                    setState(() {
                      _selectRequestStatusController =
                          new TextEditingController();
                    });
                    Navigator.of(context).pop();
                    _loadDate();
                  },
                ),
                RaisedButton(
                  child: Text("取消"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    ).then((val) {

    });
  }

  getAuth() async {
    bool review = await getPermission("erpPhone_PartsApi_editRequestStatus");
    bool edit = await getPermission("erpPhone_PartsApi_editWmConFigureApply");
    print("我的报错");
    print(edit);
    setState(() {
      auth["审核"] = review;
      auth["编辑"] = edit;
    });
  }
}
