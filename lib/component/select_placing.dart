import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:flutter_spterp/component/select_ construction_add.dart';

class SelectPlacingPage extends StatefulWidget {
  @override
  SelectPlacingPageState createState() => SelectPlacingPageState();
}

class SelectPlacingPageState extends State<SelectPlacingPage> {
  RefreshController _refreshController;
  List<Map<String, dynamic>> dataList = [];
  bool isloading = false;
  int page = 1;
  Map<String, dynamic> pageMap = {};
  String placing = "";
  bool isSearch = false;
  bool _loading = false;
  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshController = new RefreshController();
    init();
  }

  init() async {
    await _loadDate();
    setState(() {
      _loading = false;
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
        title: Text("选择浇灌部位"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearch = true;
                textEditingController.text = placing;
              });
            },
          ),
          /*IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectConstructionAdd()));
              _onRefresh();
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
                  hintText: "搜索浇灌部位",
                  hintStyle: TextStyle(color: Colors.white),
                ),
                onSubmitted: (val) {
                  setState(() {
                    placing = val;
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
              children: dataList
                  .map((placingDropDown) => _itemBuild(placingDropDown))
                  .toList(),
            ),
          )),
    );
  }

  Widget _itemBuild(placingDropDown) {
    return Container(
      child: placingDropDown['placing'] != null
          ? ListTile(
        title: Text(placingDropDown['placing']),
        // subtitle: Text(placingDropDown['builderCode']),
        onTap: () {
          Navigator.pop(context, placingDropDown);
        },
      )
          : Container(),
    );
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
      Map<String, dynamic> result;
      if (placing != null && placing != "") {
        result = await getPlacingDropDown(page,
            pageSize: 20, placing: placing);
      } else {
        result = await getPlacingDropDown(page, pageSize: 20);
      }

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
