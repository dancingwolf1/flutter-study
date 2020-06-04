import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:flutter_spterp/component/select_ construction_add.dart';
import 'package:flutter_spterp/component/no_more.dart';
import 'package:flutter_spterp/component/appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
import 'package:flutter_spterp/component/input_filtrate/filtrate_body.dart';
import 'package:flutter_spterp/component/input_filtrate/filtrate_input.dart';


class SelectBuilderPage extends StatefulWidget {
  @override
  SelectBuilderPageState createState() => SelectBuilderPageState();
}

class SelectBuilderPageState extends State<SelectBuilderPage> {
  RefreshController _refreshController;
  List<Map<String, dynamic>> dataList = [];
  bool isLoading = false;
  int page = 1;
  Map<String, dynamic> pageMap = {};
  String builderName = "";
  bool isSearch = false;
  bool _loading = true;
  TextEditingController textEditingController = new TextEditingController();
  TextEditingController controller = new TextEditingController();// 搜索框控制器


  @override
  void initState() {
    super.initState();
    _refreshController = new RefreshController();
    init();
  }

  init() async {
    await _loadDate();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 /*     appBar: !isSearch
          ? AppBar(
        title: Text("选择施工单位"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearch = true;
                textEditingController.text = builderName;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectConstructionAdd()));
              _onRefresh();
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
                  hintText: "搜索施工单位",
                  hintStyle: TextStyle(color: Colors.white),
                ),
                onSubmitted: (val) {
                  setState(() {
                    builderName = val;
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
      ),*/
 appBar: getAppBar(context, "施工单位",actions:  IconButton(
   icon: Icon(Icons.add_circle,color: Colors.grey,),
   onPressed: () async {
     await Navigator.push(
         context,
         MaterialPageRoute(
             builder: (context) => SelectConstructionAdd()));
     _onRefresh();
   },
 ),isRightButton: false),
      body:Stack(children: <Widget>[
        loading(
            _loading,
            SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(),
              footer: getFooter(),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setWidth(110)),
                child: ListView(
                  children: dataList.length == 0
                      ? <Widget>[noMore()]
                      :dataList
                      .map((builderDropDown) => _itemBuild(builderDropDown))
                      .toList(),
                ),
              ),
            )),
        filtrateInput(controller,"请输入施工单位名称",(val){
          builderName = val;
          page = 1;
          dataList = [];
          _loadDate();
        })
      ],),
    );
  }

  Widget _itemBuild(builderDropDown) {
     return filtrateBody(context,builderDropDown,"builderName", () {
       Navigator.pop(context, builderDropDown);
     });
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
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> result;
      if (builderName != null && builderName != "") {
        result = await getBuilderDropDown(page,
            pageSize: 20, builderName: builderName);
      } else {
        result = await getBuilderDropDown(page, pageSize: 20);
      }

      var resultArr = result['arr'];
      setState(() {
        for (var item in resultArr) {
          dataList.add(item);
        }
        result.remove("arr");
        pageMap = result;
        page++;
        isLoading = false;
        _loading = false;
      });
    }
  }
}
