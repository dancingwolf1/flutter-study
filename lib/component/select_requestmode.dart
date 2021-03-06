import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 选择申请模式
class SelectRequestModePage extends StatefulWidget {
  @override
  SelectRequestModePageState createState() => SelectRequestModePageState();
}

class SelectRequestModePageState extends State<SelectRequestModePage> {
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
      Map<String, dynamic> result =
      await getDepartmentList(page);

      setState(() {
        for (Map<String, dynamic> item in result['arr']) {
          dataList.add(item);
        }

        result.remove("arr");
        pageMap = result;
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !isSearch
          ? AppBar(
        title: Text("选择申请部门"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearch = true;
                textEditingController.text = eppName;
              });
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
                  hintText: "搜索申请部门",
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
        child: ListView(
          children:
          dataList.map((eppDropDown) => _itemBuild(eppDropDown)).toList(),
        ),
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
    page ++;
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
      color: Colors.white,
      child: ListTile(
          title: Text(eppDropDown['name']),
          onTap: () {
            setState(() {
              selectEpp = eppDropDown;
              Navigator.pop(context, selectEpp);
            });
          }),
    );
  }
}
