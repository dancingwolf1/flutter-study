import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SelectOverWeightPage extends StatefulWidget {
  @override
  SelectOverWeightPageState createState() => SelectOverWeightPageState();
}

class SelectOverWeightPageState extends State<SelectOverWeightPage> {
  int page = 1;
  List dataList = [];
  Map<String, dynamic> pageMap = {};
  bool isloading = false;
  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _loadDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("选择业务员"),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: getFooter(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView(
          children: dataList
              .map((builderDropDown) => _itemBuild(builderDropDown))
              .toList(),
        ),
      ),
    );
  }

  Widget _itemBuild(var itemDate) {

    return Container(
      color: Colors.white,
      child: ListTile(
//        dense: false,
          title: Text(itemDate['salesManName']),
          subtitle: Text(itemDate['salesCode']),
          onTap: () {
            Navigator.pop(context, itemDate);
          }),
    );
  }

  _onRefresh() {
    setState(() {
      page = 1;
      dataList = [];
      _refreshController.resetNoData();
    });
    try {
      _loadDate();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  _onLoading() async {
    if (pageMap['totalPage'] <= page) {
      _refreshController.loadNoData();
      return;
    }
    await _loadDate();
    _refreshController.loadComplete();
  }

  _loadDate() async {
    if (!isloading) {
      setState(() {
        isloading = true;
      });
      Map<String, dynamic> result = await getSalesDropDown(page, pageSize: 20);

      var resultArr = result['arr'];
      setState(() {
        for (var item in resultArr) {
          dataList.add(item);
        }
        result.remove("arr");
        pageMap = result;
        page++;
        isloading = false;
      });
    }
  }
}
