import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spterp/component/no_more.dart';

/// 工程名称选择
class SelectCarPage extends StatefulWidget {
  @override
  SelectCarPageState createState() => SelectCarPageState();
}

class SelectCarPageState extends State<SelectCarPage> {
  RefreshController _refreshController;

  // 是否正在加载
  bool isloading = false;

  // 数据列表
  List<Map<String, dynamic>> dataList = [];

  // 分页数据
  Map<String, dynamic> pageMap = {};

  // 查询条件
  String eppName = ""; // 工程名称
  int page = 1;

  bool isSearch = false;

  // 被选中的工程对象
  Map<String, dynamic> selectEpp = {};

  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _loadDate();
  }

  _loadDate() async {
    if (!isloading) {
      setState(() {
        isloading = true;
      });
      Map<String, dynamic> result = await getVehicleId();

      setState(() {
        for (Map<String, dynamic> item in result['arr']) {
          dataList.add(item);
        }

        getTypeName();
        result.remove("arr");
        pageMap = result;
        page++;
        isloading = false;
      });
    }
  }

  /// 按照车辆类型进行分组
  getTypeName() {
    List groupingArr = [];
    Map groupingObj = {};
    for (int i = 0; i < dataList.length; i++) {
      groupingObj[dataList[i]['typeName']] = groupingObj[dataList[i]['typeName']] == null
          ? []
          : groupingObj[dataList[i]['typeName']];
      groupingObj[dataList[i]['typeName']].add(dataList[i]);
    }
    groupingObj.forEach((index, value) {
      groupingArr.add({'key': index, 'value': value});
    });

    return groupingArr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !isSearch
          ? AppBar(
              title: Text("选择车号"),
              actions: <Widget>[
                //暂时没有搜索
                /*       IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearch = true;
                textEditingController.text = eppName;
              });
            },
          )*/
              ],
            )
          : AppBar(
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      textInputAction: TextInputAction.search,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "搜索车号",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      onSubmitted: (val) {
                        setState(() {
                          eppName = val;
                          page = 1;
                          dataList = [];
                          _loadDate();
                        });
                      },
                    ),
                    flex: 4,
                  ),
                  Expanded(
                    child: FlatButton(
                        onPressed: () {
                          setState(() {
                            isSearch = false;
                          });
                        },
                        child: Text(
                          "取消",
                          style: TextStyle(color: Colors.white),
                        )),
                  )
                ],
              ),
            ),
      body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(),
          footer: getFooter(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child:  ListView(
            children: dataList.length == 0
                ? [noMore()]
                :getTypeName()
                .map<Widget>((contract) => _itemBuild(contract))
                .toList(),
          )
      ),
    );
  }

  void _onRefresh() {
    setState(() {
      page = 1;
      dataList = [];
    });
    try {
      _loadDate();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  void _onLoading() {
    if (pageMap['totalPage'] <= page) {
      _refreshController.loadNoData();
      return;
    }
    _loadDate();
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Widget _itemBuild(eppDropDown) {

    return Container(
        child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                 Padding(
                   padding: EdgeInsets.only(left: 8.0),
                   child:  Text("${eppDropDown['key']==null?'':eppDropDown['key']}",
                       style: TextStyle(color: Colors.red,fontSize: 18, height: 1.5,fontWeight:FontWeight.bold),
                       textAlign: TextAlign.right),
                 ),
                ],
              ),
              Column(children: [
                Column(
                  children: buildName(eppDropDown),
                )
              ])
            ],
        ),
      color: Colors.white,

    );
  }

  List<Widget> buildName(eppDropDown) {
    // 这里是最终小组件
    List<Widget> list = [];
    for (int i = 0; i < eppDropDown['value'].length; i++) {
      list.add(Container(
        color: Colors.white,
        child: ListTile(
            title: Text(eppDropDown['value'][i]['vehicleId']),
            onTap: () {
              setState(() {
                selectEpp = eppDropDown['value'][i];
                Navigator.pop(context, selectEpp);
              });
            }),));
    }
    return list;
  }
}
