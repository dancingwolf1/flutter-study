import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PermissionDetailPage extends StatefulWidget {
  PermissionDetailPage(this.permissionObj);

  final Map permissionObj;

  List contractList;

  @override
  PermissionDetailState createState() => PermissionDetailState();
}

class PermissionDetailState extends State<PermissionDetailPage> {
  Map<String, dynamic> contractDetailDate;
  TextStyle labelStyle = TextStyle(fontSize: 18.0, color: Colors.blueGrey);
  TextStyle valueStyle = TextStyle(fontSize: 18.0, color: Colors.black87);

  @override
  void initState() {
    super.initState();
    _loadDate();
  }

  _loadDate() async {
    contractDetailDate = widget.permissionObj;
  }

  Widget _contractHeader() => Container(
        padding: EdgeInsets.all(15.0),
        color: Colors.black12,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "${contractDetailDate}",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ); // 合同头部

  Widget _rowItem(String title, String value) => Container(
        margin: EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text("$title", style: labelStyle),
              flex: 1,
            ),
            Expanded(
              child: Text("$value", style: valueStyle),
              flex: 3,
            ),
          ],
        ),
      );

  Widget _build() {
    return GestureDetector(
      child: ListView(
        children: <Widget>[
          _contractHeader(),
          _contractDetailWidget(),
//          Row(
//            children: <Widget>[
//              Expanded(
//                child: Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: RaisedButton(
//                      color: Colors.blue,
//                      child: Text(
//                        "价格信息明细",
//                        style: TextStyle(color: Colors.white),
//                      ),
//                      onPressed: () {
//                        Navigator.push(
//                            context,
//                            CupertinoPageRoute(
//                                builder: (context) => ContractPriceDetailPage(
//                                    contractUid:
//                                        contractDetailDate['contractUid'],
//                                    contractDetailCode: contractDetailDate[
//                                        'contractDetailCode'])));
//                      }),
//                ),
//              ),
//              Expanded(
//                child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: RaisedButton(
//                        color: Colors.blue,
//                        child: Text(
//                          "纸质合同",
//                          style: TextStyle(color: Colors.white),
//                        ),
//                        onPressed: () {
//                          Navigator.push(
//                              context,
//                              CupertinoPageRoute(
//                                builder: (context) => ContractUploadPage(
//                                    contractDetailDate['contractUid'],
//                                    contractDetailDate['contractDetailCode']),
//                              ));
//                        })),
//              ),
//            ],
//          ),
          Row(
            children: <Widget>[
              //把禁用合同按钮进行隐藏
              /*   Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      color: Colors.blue,
                      child: Text(
                        "禁用合同",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {}),
                ),
              ),*/
              /* Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: RaisedButton(
                      color: contractDetailDate['verifyStatus'] == 0
                          ? Colors.red
                          : Colors.amber,
                      child: Text(
                        contractDetailDate['verifyStatus'] == 0 ? "审核" : "取消审核",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        await verifyContract(contractDetailDate['contractUid'],
                            (contractDetailDate['verifyStatus'] == 0 ? 1 : 0));
                        setState(() {
                          contractDetailDate['verifyStatus'] =
                              contractDetailDate['verifyStatus'] == 0 ? 1 : 0;
                        });
                      }),
                ),
              ),*/
            ],
          ),
//          Container(
//            margin: EdgeInsets.only(bottom: 12),
//            color: Colors.grey[100],
//            child: _moreItem(),
//          ),
        ],
      ),
    );
  }

  Widget _moreItem() {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            "更多合同",
            style: TextStyle(fontSize: 14),
          ),
        ),
        Container(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: widget.contractList
                .map((item) => Container(
                      height: 160,
                      width: 250,
                      child: _itemBuild(item),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }

  Widget _contractDetailWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _rowItem(
              "权限组名称:", contractDetailDate["createTime"] == null ? "" : contractDetailDate["createTime"]),
          _rowItem(
              "权限组状态:", contractDetailDate["createTime"] == null ? "" : contractDetailDate["createTime"]),
          _rowItem(
              "所属企业:", contractDetailDate["createTime"] == null ? "" : contractDetailDate["createTime"]),
          _rowItem(
              "创建时间:", contractDetailDate["createTime"] == null ? "" : contractDetailDate["createTime"]),
          _rowItem(
              "更新时间:", contractDetailDate["createTime"] == null ? "" : contractDetailDate["createTime"]),
          /*   _rowItem(
              "销售员:",
              contractDetailDate  == null
                  ? ""
                  : contractDetailDate ),
          _rowItem(
              "签订时间:",
              contractDetailDate['createTime'] == null
                  ? ""
                  : contractDetailDate['createTime']),
          _rowItem(
              "工程名称:",
              contractDetailDate['createTime'] == null
                  ? ""
                  : contractDetailDate['createTime']),
          _rowItem(
              "施工单位:",
              contractDetailDate['createTime'] == null
                  ? ""
                  : contractDetailDate['createTime']),
          _rowItem(
              "到期时间:",
              contractDetailDate['createTime'] == null
                  ? ""
                  : contractDetailDate['createTime']),
          _rowItem(
              "合同类别:",
              contractDetailDate['createTime'] == null
                  ? ""
                  : contractDetailDate['createTime']),
          _rowItem(
              "收货地址:",
              contractDetailDate['createTime'] == null
                  ? ""
                  : contractDetailDate['createTime']),
          _rowItem(
              "执行方式:",
              contractDetailDate['createTime'] == null
                  ? ""
                  : contractDetailDate['createTime']),
          _rowItem(
              "备注:",
              contractDetailDate['createTime'] == null
                  ? ""
                  : contractDetailDate['createTime']),*/
        ],
      ),
      padding: EdgeInsets.only(top: 8.0, right: 15, left: 15, bottom: 8.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("权限详情"),
          actions: <Widget>[
            //先隐藏此功能
            /*  IconButton(
            onPressed: () {},
            icon: Icon(Icons.mode_edit),
            tooltip: "编辑合同",
          )*/
          ],
        ),
        body: _build());
  }

  Widget _itemBuild(contract) {
    var contractStatus = "";
    Color contractStatusColor = Colors.amber;
    if (contract['verifyStatus']) {
      contractStatus = "已审核";
      contractStatusColor = Colors.green;
    } else {
      contractStatus = "未审核";
      contractStatusColor = Colors.amber;
    }
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    contract['contractId'],
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(8.0, 5.0, 0, 0),
                    padding: EdgeInsets.fromLTRB(5.0, 0.0, 5, 0),
                    child: Text(
                      "$contractStatus",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
//                  color: contractStatusColor,
                    decoration: BoxDecoration(
                        color: contractStatusColor,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  )
                ],
              ),
              _contentRowView("业务员",
                  contract['scaleName'] == null ? "" : contract['scaleName']),
              _contentRowView(
                  "签订时间",
                  contract['signDate'] == null
                      ? ""
                      : contract['signDate'].toString().substring(0, 10)),
              _contentRowView(
                  "工程名称",
                  contract['eppName'] == null
                      ? ""
                      : contract['eppName'].toString()),
              _contentRowView(
                  "施工单位",
                  contract['builderName'] == null
                      ? ""
                      : contract['builderName']),
            ],
          ),
        ),
      ),
      onTap: () {},
    );
  }

  Widget _contentRowView(String title, String value) {
    TextStyle titleStyle = TextStyle(color: Colors.grey, fontSize: 12);
    TextStyle valueStyle = TextStyle(fontSize: 12);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
              height: 26,
              child: Align(
                  child: Text(
                    "$title",
                    style: titleStyle,
                  ),
                  alignment: Alignment.centerLeft)),
          flex: 2,
        ),
        Expanded(
          child: Container(
              height: 26,
              child: Align(
                  child: Text(
                    "$value",
                    overflow: TextOverflow.ellipsis,
                    style: valueStyle,
                  ),
                  alignment: Alignment.centerLeft)),
          flex: 6,
        )
      ],
    );
  }
}
