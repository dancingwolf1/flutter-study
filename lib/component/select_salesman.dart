import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:flutter_spterp/component/no_more.dart';
import 'package:flutter_spterp/component/appbar.dart';
import 'package:flutter_spterp/util/adaptive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
import 'package:flutter_spterp/component/input_filtrate/filtrate_body.dart';
import 'package:flutter_spterp/component/input_filtrate/filtrate_input.dart';


class SelectSalesmanPage extends StatefulWidget {
  @override
  SelectSalesmanPageState createState() => SelectSalesmanPageState();
}

class SelectSalesmanPageState extends State<SelectSalesmanPage> {
  int page = 1;
  List dataList = [];
  Map<String, dynamic> pageMap = {};
  bool isLoading = false;
  RefreshController _refreshController;
  bool _loading = true;
  TextEditingController controller = new TextEditingController();//搜索框控制器

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _loadDate();
  }

  @override
  Widget build(BuildContext context) {
    adaptation(context);

    return Scaffold(
      appBar: getAppBar(context, "业务员", isRightButton: false),
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
            child: loading(
                _loading,
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(0)),
                  child:ListView(
                    children: dataList.length == 0
                        ? <Widget>[noMore()]
                        : dataList
                        .map((builderDropDown) => _itemBuild(builderDropDown))
                        .toList(),
                  )
                ),

            ),
          ),
       /*   filtrateInput(controller,"请输入业务员名称",(v){print("开始搜索");
          }) ,*/
        ],
      ),
    );
  }

  Widget _itemBuild(var itemDate) {
    return filtrateBody(context, itemDate,"salesManName",(){
      Navigator.pop(context, itemDate);
    });

    /* return GestureDetector(
        onTap: () {
          Navigator.pop(context, itemDate);
        },
      child: Container(
        padding: EdgeInsets.only(left:ScreenUtil().setWidth(24)),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom:BorderSide(width:0.5,color: Color.fromRGBO(0, 0, 0, 0.16))),
        ),
        width: ScreenUtil().setWidth(750),
        height: ScreenUtil().setWidth(96),

        */ /*    child: ListTile(
//        dense: false,
          title: Text(itemDate['salesManName']),
//          subtitle: Text(itemDate['salesCode']),
          onTap: () {
            Navigator.pop(context, itemDate);
          }),*/ /*
        child:Row(
          children: <Widget>[
            Text("${itemDate['salesManName']}",style: TextStyle(fontSize: ScreenUtil().setWidth(30),color: Color.fromRGBO(139, 137, 151, 1)),),
          ],
        ),
      ),
    );*/
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
      Map<String, dynamic> result = await getSalesDropDown(page, pageSize: 20);

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
