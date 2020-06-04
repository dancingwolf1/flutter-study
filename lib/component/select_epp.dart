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


/// 工程名称选择
class SelectEppPage extends StatefulWidget {
  @override
  SelectEppPageState createState() => SelectEppPageState();
}

class SelectEppPageState extends State<SelectEppPage> {
  RefreshController _refreshController;

  // 是否正在加载
  bool isloading = false;
  bool _loading = true;

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
  TextEditingController controller = new TextEditingController();// 搜索框控制器

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    init();
  }

  init() async {
    await _loadDate();
  }

  _loadDate() async {
    if (!isloading) {
      setState(() {
        isloading = true;
      });
      Map<String, dynamic> result =
      await getEppDropDown(page, eppName: eppName, pageSize: 20);

      setState(() {
        for (Map<String, dynamic> item in result['arr']) {
          dataList.add(item);
        }

        result.remove("arr");
        pageMap = result;
        page++;
        isloading = false;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   /*   appBar: !isSearch
          ? AppBar(
        title: Text("选择工程名称"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearch = true;
                textEditingController.text = eppName;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectEppAdd()));
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
                      page = 1;
                      dataList = [];
                      eppName="";
                      _loadDate();
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
   appBar: getAppBar(context,"工程名称",actions: IconButton(
     icon: Icon(Icons.add_circle,color: Colors.grey,),
     onPressed: () async {
       await Navigator.push(
           context,
           MaterialPageRoute(
               builder: (context) => SelectEppAdd()));
       _onRefresh();
     },
   ),isRightButton: false),
      body: Stack(
        children: <Widget>[
          loading(_loading,
              SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(),
                controller: _refreshController,
                footer: getFooter(),
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child:  Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(110)),child: ListView(
                  children: dataList.length == 0
                      ? <Widget>[noMore()]
                      :dataList
                      .map((eppDropDown) => _itemBuild(eppDropDown))
                      .toList(),
                ),),
              )),
        filtrateInput(controller,"请输入工程名称",(val){
          setState(() {
            eppName = val;
            page = 1;
            dataList = [];
            _loadDate();
          });
        })

          ],
      ),
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
    return filtrateBody(context,eppDropDown,"eppName",() {
      setState(() {
        selectEpp = eppDropDown;
        Navigator.pop(context, selectEpp);
      });
    });
    return Container(
      color: Colors.white,
      child: ListTile(
          title: Text(eppDropDown['eppName']),
          // subtitle: Text(eppDropDown['eppCode']),
          onTap: () {
            setState(() {
              selectEpp = eppDropDown;
              Navigator.pop(context, selectEpp);
            });
          }),
    );
  }
}
