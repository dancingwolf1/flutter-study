import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:flutter_spterp/component/no_more.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'value_perocessor.dart';
import 'package:flutter_spterp/component/select_epp.dart';
import 'package:flutter_spterp/component/select_builder.dart';
import 'package:flutter_spterp/component/list_info.dart';

class ContractListPage extends StatefulWidget {
  @override
  ContractListPageState createState() => ContractListPageState();
}

class ContractListPageState extends State<ContractListPage> {
  RefreshController _refreshController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map<String, dynamic> pageMap = {};
  List<Map<String, dynamic>> dataList = [];
  int page = 1;
  bool isloading = false;
  bool _loading = true;
  bool isSearch = false;

  // 查询条件
  Map<String, dynamic> selectedEpp = {}; //选中的工程名称对象
  Map<String, dynamic> selectBuilder = {}; // 选中的施工单位对象
  Map<String, dynamic> selectSalesman = {}; // 选中的销售员对象
  String contractCode = "";

  String eppName = "工程名称"; //以施工合同名称为单位的搜索条件
  String builderName = "施工单位"; //以施工单位为条件的搜索条件

  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    init();
  }

  init() async {
    await _loadDate();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("选择合同"),
      ),
      body: loading(
          _loading,
          SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropHeader(),
            footer: getFooter(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: ListView(

                children:[
                  Container(
                    color:Color.fromRGBO(230,230,230, 1),
                    child:   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          constraints:BoxConstraints(maxWidth: 100.0),
                          height: 30.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "$eppName",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onPressed: () async {
                              Map<String, dynamic> result = await Navigator.push(
                                  context,
                                  new CupertinoPageRoute(
                                      builder: (context) => SelectEppPage()));
                              if (result == null) {
                                return;
                              }
                              setState(() {
                                selectedEpp = result;
                                eppName = selectedEpp['eppName'].toString();
                              });
                            },
                          ),
                        ),
                        Container(
                          constraints:BoxConstraints(maxWidth: 100.0),
                          height: 30.0,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                "$builderName",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onPressed: () async {
                                Map<String, dynamic> _selectBuilder = await Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => SelectBuilderPage()));
                                if (_selectBuilder == null) {
                                  return;
                                }
                                setState(() {
                                  selectBuilder = _selectBuilder;
                                  builderName = selectBuilder['builderName'].toString();
                                });
                              }),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              child: RaisedButton(
                                child: Text(
                                  "搜索",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: _searchContract,
                                color: Colors.blue,
                              ),
                              margin: EdgeInsets.all(3.0),
                              width: 60.0,
                              height: 30.0,
                            ),
                            Container(
                              child: RaisedButton(
                                color: Colors.blue,
                                child: Text(
                                  "重置",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                onPressed: () {
                                  eppName = "工程名称";
                                  builderName = "施工单位";
                                  selectedEpp = {};
                                  selectBuilder = {};
                                  dataList = [];
                                  _loadDate();
                                },
                              ),
                              margin: EdgeInsets.all(2.0),
                              width: 60.0,
                              height: 30.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Column(children:  dataList.length == 0
                      ? <Widget>[noMore()]
                      : _itemListBuild(dataList),),
                ]

              /*children: <Widget>[],*/
            ),
          )),
    );
  }

  List<Widget> _itemListBuild(List list) {
    List<Widget> itemList = [];


    for (var value in list) {
      itemList.add(_itemBuild(value));
    }
    return itemList;
  }

  _searchContract() {
    setState(() {
      _loading = true;
    });
    _onRefresh().then((v) {
      setState(() {
        _loading = false;
      });
    });
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
                  Expanded(
                    child: Text(
                      contract['contractId'],
                      style: TextStyle(fontSize: 18, height: 1.5),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(8.0, 5.0, 0, 0),
                    padding: EdgeInsets.fromLTRB(5.0, 0.0, 5, 0),
                    child: Text(
                      "$contractStatus",
                      style: TextStyle(color: Colors.white),
                    ),
//                  color: contractStatusColor,
                    decoration: BoxDecoration(
                        color: contractStatusColor,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  )
                ],
              ),
              contentRowViewPublic("工程名称", contract['eppName']),
              contentRowViewPublic("施工单位", contract['builderName']),
              contentRowViewPublic("业  务  员", contract['scaleName']),
              contentRowViewPublic("签订时间", contract['signDate']),
            ],
          ),
        ),
      ),
      onTap: () => {Navigator.pop(context, contract)},
    );
  }

  Future _loadDate() async {
    if (!isloading) {
      // 判断是否加载完毕，如果未加载完毕就不加载。
      setState(() {
        isloading = true;
      });

      Map<String, dynamic> result = await contractList(page,
          eppCode: selectedEpp["eppCode"],
          buildCode: selectBuilder["builderCode"]);
      setState(() {
        pageMap = result;


        if (result['arr'] != null) {
          for (var item in result['arr']) {
            item["builderName"] = valueProcessor(item["builderName"]);
            dataList.add(item);
          }
          pageMap.remove("arr");
        }
        isloading = false;
      });
    }
  }

  Future _onRefresh() async {
    setState(() {
      page = 1;
      dataList = [];
      _refreshController.resetNoData();
    });
    try {
      await _loadDate();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  Future _onLoading() async {
    if (pageMap['totalPage'] <= page) {
      _refreshController.loadNoData();
      return;
    }
    page++;
    await _loadDate();
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}