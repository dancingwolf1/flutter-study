import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:flutter_spterp/component/select_epp_add.dart';
import 'package:flutter_spterp/component/no_more.dart';
import 'package:flutter_spterp/component/appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
import 'package:flutter_spterp/component/input_filtrate/filtrate_body.dart';
import 'package:flutter_spterp/component/input_filtrate/filtrate_input.dart';

class SelectPumpTruckPage extends StatefulWidget {
  @override
  SelectPumpTruckPageState createState() => SelectPumpTruckPageState();
}

class SelectPumpTruckPageState extends State<SelectPumpTruckPage> {
  RefreshController _refreshController;
  List<Map<String, dynamic>> dataList = [];
  bool isloading = false;
  int page = 1;
  Map<String, dynamic> pageMap = {};
  String builderName = "";
  bool isSearch = false;
  TextEditingController textEditingController = new TextEditingController();
  TextEditingController controller = new TextEditingController();// 搜索框控制器

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
      appBar: getAppBar(context,"选择泵车类别",isRightButton: false) ,
     /* appBar: !isSearch
          ? AppBar(
        title: Text("选择泵车类别"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearch = true;
                textEditingController.text = builderName;
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
                  hintText: "搜索泵车类别",
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
      body: Stack(
        children: <Widget>[

          SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropHeader(),
            footer: getFooter(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child:Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setWidth(110)),
              child:  ListView(
                children: dataList
                    .map((builderDropDown) => _itemBuild(builderDropDown))
                    .toList(),
              ),
            ),
          ),
          filtrateInput(controller,"请输入工程名称",(v){print("开始搜索");})
        ],
      ),
    );
  }

  Widget _itemBuild(builderDropDown) {
    return filtrateBody(context,builderDropDown,"pumptypename", () {
      Navigator.pop(context, builderDropDown);
    });
    return Container(
      child: ListTile(
        title: Text(builderDropDown['pumptypename'].toString()),
//        subtitle: Text(builderDropDown['pumptype'].toString()),
        onTap: () {
          Navigator.pop(context, builderDropDown);
        },
      ),
    );
  }

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

        result = await selectPumpTruckList(page,10,
            builderName:builderName
        );


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
