import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/pages/contract/contract_price_detail.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:flutter_spterp/api.dart';
import 'contract_upload.dart';
import 'package:flutter_spterp/component/list_info.dart';
import 'package:flutter_spterp/component/appbar.dart';
import 'package:flutter_spterp/util/adaptive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
import 'package:flutter_spterp/util/public_color.dart';


class ContractDetailPage extends StatefulWidget {
  ContractDetailPage(
      this.contractUid, this.contractDetailCode, this.contractList);

  final String contractUid;
  final String contractDetailCode;
  List contractList;

  @override
  ContractDetailState createState() => ContractDetailState();
}

class ContractDetailState extends State<ContractDetailPage> {
  bool isLoaded = false;
  Map<String, dynamic> contractDetailDate;

  TextStyle labelStyle = TextStyle(fontSize: 18.0, color: Colors.blueGrey);
  TextStyle valueStyle = TextStyle(fontSize: 18.0, color: Colors.black87);

  // 本页权限加载
  Map auth = {
    "审核": false,
    "纸质合同": false,
  };

  @override
  void initState() {
    super.initState();
    getAuth();
    _loadDate();
    // 加载权限
  }

  _loadDate() async {
    Map<String, dynamic> _contractDetailDate =
        await getContractDetail(widget.contractUid, widget.contractDetailCode);

    setState(() {
      contractDetailDate = _contractDetailDate;
      isLoaded = true;
    });
  }

  Widget _contractHeader() => Container(
        padding: EdgeInsets.all(15.0),
        color: Colors.black12,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "${contractDetailDate['contractCode']}",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 6.0, right: 6.0),
                alignment: Alignment.centerRight,
                child: Text(
                  "${contractDetailDate['verifyStatus'] == 0 ? "未审核" : "已审核"}",
                  style: TextStyle(
                      color: contractDetailDate['verifyStatus'] != 0
                          ? Colors.white
                          : Color.fromRGBO(254, 113, 95, 1)),
                ),
                decoration: BoxDecoration(
                    border: new Border.all(
                        width: 1.0,
                        color: contractDetailDate['verifyStatus'] == 0
                            ? Color.fromRGBO(254, 113, 95, 1)
                            : Color.fromRGBO(254, 113, 95, 1)),
                    color: contractDetailDate['verifyStatus'] != 0
                        ? Color.fromRGBO(254, 113, 95, 1)
                        : null,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)))),
          ],
        ),
      ); // 合同头部
  Widget _build() {
    adaptation(context);
    return GestureDetector(
      child: ListView(
        children: <Widget>[
          _contractDetailWidget(),
          SizedBox(
            height: ScreenUtil().setWidth(64),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
//          mainAxisAlignment: ,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: ScreenUtil().setWidth(222),
                  height: ScreenUtil().setWidth(96),
                  decoration: BoxDecoration(
                    color: usePublicColor(1),
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(8)),
                  ),
                  child: Center(
                      child: Text(
                    "价格明细",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => ContractPriceDetailPage(
                              contractUid: contractDetailDate['contractUid'],
                              contractDetailCode:
                                  contractDetailDate['contractDetailCode'])));
                },
              ),
              auth["纸质合同"]
                  ? GestureDetector(
                      child: Container(
                        width: ScreenUtil().setWidth(222),
                        height: ScreenUtil().setWidth(96),
                        decoration: BoxDecoration(
                          color: usePublicColor(1),
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(8)),
                        ),
                        child: Center(
                            child: Text(
                          "纸质合同",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ContractUploadPage(
                                  contractDetailDate['contractUid'],
                                  contractDetailDate['contractDetailCode']),
                            ));
                      },
                    )
                  : Container(),
              auth["审核"]
                  ? GestureDetector(
                      child: Container(
                        width: ScreenUtil().setWidth(222),
                        height: ScreenUtil().setWidth(96),
                        decoration: BoxDecoration(
                          color: contractDetailDate['verifyStatus'] == 0
                              ? Color.fromRGBO(242, 86, 68, 1)
                              : Color.fromRGBO(255, 160, 1, 1),
//                          rgba(255, 160, 1, 1)
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(8)),
                        ),
                        child: Center(
                            child: Text(
                          contractDetailDate['verifyStatus'] == 0
                              ? "审核"
                              : "取消审核",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                      onTap: ()async {
                        await verifyContract(
                            contractDetailDate['contractUid'],
                            (contractDetailDate['verifyStatus'] == 0
                                ? 1
                                : 0));
                        setState(() {
                          contractDetailDate['verifyStatus'] =
                          contractDetailDate['verifyStatus'] == 0
                              ? 1
                              : 0;
                        });

                        Navigator.of(context)
                            .pop(contractDetailDate['verifyStatus']);
                      },
                    )
                  : Container(),
            /*  Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: auth["审核"]
                      ? RaisedButton(
                          color: contractDetailDate['verifyStatus'] == 0
                              ? Colors.red
                              : Colors.amber,
                          child: Text(
                            contractDetailDate['verifyStatus'] == 0
                                ? "审核"
                                : "取消审核",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            await verifyContract(
                                contractDetailDate['contractUid'],
                                (contractDetailDate['verifyStatus'] == 0
                                    ? 1
                                    : 0));
                            setState(() {
                              contractDetailDate['verifyStatus'] =
                                  contractDetailDate['verifyStatus'] == 0
                                      ? 1
                                      : 0;
                            });

                            Navigator.of(context)
                                .pop(contractDetailDate['verifyStatus']);
                          })
                      : null,
                ),
              ),*/
            ],
          ),
    
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
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          contentRowViewPublic("合同编号", contractDetailDate['contractCode']),
          contentRowViewPublic("工程名称", contractDetailDate['eppName']),
          contentRowViewPublic("施工单位", contractDetailDate['builderName']),
          contentRowViewPublic("业 务 员", contractDetailDate['scaleName']),
          contentRowViewPublic("执行方式", contractDetailDate['priceStyleName']),
          contentRowViewPublic("合同类型", contractDetailDate['contractTypeName']),
          contentRowViewPublic("合同方量", contractDetailDate['preNum']),
          contentRowViewPublic("预计方量", contractDetailDate['contractNum']),
          contentRowViewPublic("收货地址", contractDetailDate['address']),
          contentRowViewPublic("签订时间", contractDetailDate['signDate']),
          contentRowViewPublic("到期时间", contractDetailDate['expiresDate']),
          contentRowViewPublic("备    注", contractDetailDate['remarks']),
        ],
      ),
      padding: EdgeInsets.only(top: 8.0, right: 15, left: 15, bottom: 8.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "简易合同", isRightButton: false),
      body: isLoaded ? _build() : loading(true, Container()),
    );
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
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => ContractDetailPage(
                    contract['contractUid'],
                    contract['contractDetailCode'],
                    widget.contractList)));
      },
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
                    style: valueStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  alignment: Alignment.centerLeft)),
          flex: 6,
        )
      ],
    );
  }

  getAuth() async {
    auth["审核"] = await getPermission("erpPhone_ContractApi_verifyContract");
    auth["纸质合同"] = await getPermission("erpPhone_ContractApi_getAdjunct");
//    auth["审核"]=await getPermission("102");
  }
}
