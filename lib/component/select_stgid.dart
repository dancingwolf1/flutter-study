import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:flutter_spterp/component/no_more.dart';

class StgIdPage extends StatefulWidget {
  StgIdPage(this.contractUid, this.contractDetailCode);

  final String contractUid; // 主合同
  final String contractDetailCode; // 子合同

  @override
  StgIdState createState() => StgIdState();
}

class StgIdState extends State<StgIdPage> {
  RefreshController _refreshController;
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> searchList = [];
  bool isLoading = false;
  String stgId = "";
  bool isSearch = false;
  bool _loading = true;
  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshController = new RefreshController();
    _loadDate().then((v){
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();


    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: !isSearch
            ? AppBar(
          title: Text("选择砼标号"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearch = true;
                });
                //isSearch = true;
                textEditingController.text = stgId;
              },
            )
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
                    hintText: "搜索砼标号",
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  onSubmitted: (val) async {
                    isLoading=false;
                    await _loadDate();
                    for (var data in dataList) {
                      if(data["stgId"].toString().indexOf(val)!=-1) {
                        //说明包含用户输入的数据
                        searchList.add(data);
                      }
                    }
                    dataList=searchList;
                    searchList=[];
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
                      isLoading=false;
                      _loadDate();
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
          onLoading: () => {_refreshController.loadNoData()},
          child: loading(_loading, ListView(
            children:  dataList.length == 0
                ? <Widget>[noMore()]
                :dataList
                .map((stgidDropDown) => _itemBuild(stgidDropDown))
                .toList(),
          )),
        ));
  }

  Widget _itemBuild(stgidDropDown) {
    return Container(
      child: ListTile(
        title: Text(stgidDropDown['stgId']),
        onTap: () {
          Navigator.pop(context, stgidDropDown);
        },
      ),
    );
  }

  _onRefresh() {
    setState(() {
      _refreshController.resetNoData();
    });
    try {
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  _loadDate() async {
    dataList = [];
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var result = await getContractGradePrice(
          widget.contractUid, widget.contractDetailCode);
      setState(() {
        for (var item in result) {
          dataList.add(item);
        }
        result.remove('arr');
      });
    }
  }
}
