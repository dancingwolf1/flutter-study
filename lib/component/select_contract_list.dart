import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SelectContractPage extends StatefulWidget {
  @override
  SelectContractPageSate createState() => SelectContractPageSate();
}

class SelectContractPageSate extends State<SelectContractPage> {
  RefreshController _refreshController;
  List<Map<String, dynamic>> dataList = [];
  bool isloading = false;
  int page = 1;
  Map<String, dynamic> pageMap = {};

  @override
  void initState() {
    super.initState();
    _refreshController = new RefreshController();
    _loadDate();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("选择合同"),
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
              .map((contractDropDown) => _itemBuild(contractDropDown))
              .toList(),
        ),
      ),
    );
  }

  Widget _itemBuild(contractDropDown) {
    return GestureDetector(
        onTap: () => {
          Navigator.pop(context,contractDropDown)
        },
        child: Container(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(contractDropDown["contractId"]),
              ),
              ListTile(
                title: Text(contractDropDown["eppName"]),
                subtitle: Text(contractDropDown["eppCode"]),
              ),
              ListTile(
                title: Text(contractDropDown["builderName"]),
                subtitle: Text(contractDropDown["builderCode"]),
              ),
            ],
          ),
          decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: const Color(0xFFFFFFFF))),
        ));
  }

  // 下拉刷新
  _onRefresh() {
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

  // 上拉加载
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
      Map<String, dynamic> result = await contractList(page);
      var resultArr = result["arr"];
      setState(() {
        if (result['arr'] != null) {
          for (var item in resultArr) {
            dataList.add(item);
          }
          result.remove("arr");
          pageMap = result;
          page++;
          isloading = false;
        }
      });
    }
  }
}
