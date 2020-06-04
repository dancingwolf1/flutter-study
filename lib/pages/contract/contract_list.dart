import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:flutter_spterp/component/no_more.dart';
import 'package:flutter_spterp/component/select_builder.dart';
import 'package:flutter_spterp/component/select_epp.dart';
import 'package:flutter_spterp/component/select_salesman.dart';
import 'package:flutter_spterp/pages/contract/contract_add.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spterp/pages/contract/contract_detail.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:flutter_spterp/component/list_info.dart';
import 'package:flutter_spterp/util/operating_time.dart';
import 'package:flutter_spterp/util/adaptive.dart';
import 'package:flutter_spterp/util/public_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:flutter_spterp/component/appbar.dart';
import 'package:flutter_spterp/component/input_filtrate/sidebar_input.dart';

class ContractListPage extends StatefulWidget {
  @override
  ContractListPageState createState() => ContractListPageState();
}

class ContractListPageState extends State<ContractListPage> {
  RefreshController _refreshController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> dataList = [];
  int page = 1;
  int _beginTime = 0;
  int _endTime = 0;
  int timeButton = 0;
  int verifyStatus; // 审核状态码
  bool isLoading = false;
  bool _loading = false;
  String total = "0";
  Map auth = {"添加": false, "详情": false}; // 本页权限加载
  Map<String, dynamic> pageMap = {};
  Map<String, dynamic> selectedEpp = {}; //选中的工程名称对象
  Map<String, dynamic> selectBuilder = {}; // 选中的施工单位对象
  Map<String, dynamic> selectSalesman = {}; // 选中的销售员对象
  String contractCode = "";
  TextEditingController _selectedEppController; // 选中后的工程名称输入框控制器
  TextEditingController _selectedBuilderController; // 选中后的施工单位输入框控制器
  TextEditingController _selectedSalesmanController; // 选中后的业务员输入框控制器
  List<Map<String, dynamic>> dateFiltrate = [
    {"title": "今日", "id": 7},
    {"title": "昨日", "id": 4},
    {"title": "本周", "id": 2},
    {"title": "本月", "id": 1},
    {"title": "上月", "id": 5},
    {"title": "定义时间", "id": 3},
  ];
  // 日期状态数据
  // 任务单的审核状态数据,下拉标题数据
  List<Map<String, dynamic>> auditStatusFiltrate = [
    {"title": "全部审核", "id": 2},
    {"title": "已审核", "id": 1},
    {"title": "未审核", "id": 0},
  ];

  // 业务员筛选条件
  List<Map<String, dynamic>> salesmanFiltrate = [
    {"title": "业务员", "id": 0}
  ];

  int auditTypeIndex = 0; // 审核状态选中的索引值
  int dateFiltrateIndex = 0; // 日期选中的索引值
  int salesman = 0; // 业务员选中的索引值

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() {
      _beginTime = DateTime.parse(
              DateTime.now().toLocal().toString().substring(0, 10) + " 00:00")
          .millisecondsSinceEpoch;

      _endTime = DateTime.parse(
              DateTime.now().toLocal().toString().substring(0, 10) + " 23:59")
          .millisecondsSinceEpoch;
      _refreshController = RefreshController();
      _selectedEppController = new TextEditingController();
      _selectedBuilderController = new TextEditingController();
      _selectedSalesmanController = new TextEditingController();
      _loading = true;
      // 加载权限
      getAuth();
    });
    filtrate(); // 获取筛选条件
    await _loadDate();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    adaptation(context);
    return Scaffold(
//      backgroundColor:Colors.white,
      key: _scaffoldKey,
      appBar: getAppBar(context, "简易合同", funnel: () {
        _scaffoldKey.currentState.openEndDrawer();
      }),
      body: DefaultDropdownMenuController(
        onSelected: ({int menuIndex, int index, int subIndex, dynamic data}) {
          topFiltrate(menuIndex, data);
       /*   print("筛选条件$menuIndex");
          print("筛选条件$index");
          print("筛选条件$subIndex");
          print("筛选条件$data");
          print("任务单对象:$selectSalesman");*/
        },
        child: loading(
            _loading,
            Column(
              children: <Widget>[
                Theme(
                  data: ThemeData(
//                    unselectedWidgetColor:Colors.red,
                    primaryColor: Colors.blue,
                  ),
                  child: Container(
                    color: Colors.white,
                    child: buildDropdownHeader(),
                  ),
                ),
//                SizedBox(height: ScreenUtil().setWidth(20)),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: true,
                        header: WaterDropHeader(),
                        footer: getFooter(),
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        onLoading: _onLoading,

                        child: ListView(
                          // 处理手势过快 回弹越界。
                          physics: BouncingScrollPhysics(),
                          children: dataList.length == 0
                              ? <Widget>[noMore()]
                              : dataList
                                  .map((contract) => _itemBuild(contract))
                                  .toList(),
                        ),
                      ), //列表
                      buildDropdownMenu(),
                    ],
                  ),
                ),
              ],
            )),
      ),
      endDrawer: _searchDrawer(),
      floatingActionButton: auth["添加"]
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.add,
                color: Colors.blue,
              ),
              onPressed: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContractAddPage()));
                // 返回刷新
                _onRefresh();
              })
          : null,
    );
  }

  // 顶部筛选条件赋值
  filtrateData(int type, var value) {
    switch (type) {
    }
  }

  // 搜索侧边栏
  Widget _searchDrawer() {
    return Drawer(
      child: Stack(children: <Widget>[
        MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: Column(children: <Widget>[
                    SizedBox(
                      height: ScreenUtil().setWidth(102),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            child: Text(
                              "签订日期查询",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  color: usePublicColor(3),
                                  fontWeight: FontWeight.w700),
                            ),
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(20)),
                          ),
                        ]),
                    SizedBox(height: ScreenUtil().setWidth(30)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        getTimeButton("昨天", 4),
                        getTimeButton("今天", 7),
                        getTimeButton("本周", 2),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setWidth(20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        getTimeButton("上周", 6),
                        getTimeButton("本月", 1),
                        getTimeButton("上月", 5),
                      ],
                    ),

                    SizedBox(height: ScreenUtil().setWidth(40)),
                    onTapSelectTime(context, "开始时间", () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          onChanged: (date) {}, onConfirm: (date) {
                        setState(() {
                          _beginTime = date.millisecondsSinceEpoch;
                        });
                      },
                          currentTime: DateTime.fromMillisecondsSinceEpoch(
                              _beginTime,
                              isUtc: false),
                          locale: LocaleType.zh);
                    }, _beginTime),
                    SizedBox(
                      height: ScreenUtil().setWidth(20),
                    ),
                    onTapSelectTime(context, "结束时间", () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          onChanged: (date) {}, onConfirm: (date) {
                        setState(() {
                          _endTime = date.millisecondsSinceEpoch;
                        });
                      },
                          currentTime: DateTime.fromMillisecondsSinceEpoch(
                              _endTime,
                              isUtc: false),
                          locale: LocaleType.zh);
                    }, _endTime),

                    SizedBox(height: ScreenUtil().setWidth(40)),
                    onTapSelectInput(_selectedEppController, "工程名称", () async {
                      Map<String, dynamic> result = await Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => SelectEppPage()));
                      if (result == null) {
                        return;
                      }
                      setState(() {
                        selectedEpp = result;
                        _selectedEppController.text =
                            selectedEpp['eppName'].toString();
                      });
                    }),
                    onTapSelectInput(_selectedBuilderController, "施工单位",
                        () async {
                      Map<String, dynamic> _selectBuilder =
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectBuilderPage()));
                      if (_selectBuilder == null) {
                        return;
                      }
                      setState(() {
                        selectBuilder = _selectBuilder;
                        _selectedBuilderController.text =
                            selectBuilder['builderName'].toString();
                      });
                    }),
                    onTapSelectInput(_selectedSalesmanController, "业务员    ",
                        () async {
                      Map<String, dynamic> _selectSalesman =
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectSalesmanPage()));
                      if (_selectSalesman == null) {
                        return;
                      }
                      setState(() {
                        selectSalesman = _selectSalesman;
                        _selectedSalesmanController.text =
                            selectSalesman['salesManName'].toString();
                      });
                    }),
                  ])),
            ],
          ),
        ),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Padding(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _onReset();
                    },
                    child: Container(
                      width: ScreenUtil().setWidth(256),
                      height: ScreenUtil().setWidth(96),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(50, 150, 250, 0.1),
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(8)),
                      ),
                      child: Center(
                          child: Text(
                        "重置",
                        style:
                            TextStyle(color: Color.fromRGBO(50, 150, 250, 1)),
                      )),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(18),
                  ),
                  GestureDetector(
                    onTap: () {
                      _onSearch();
                    },
                    child: Container(
                      width: ScreenUtil().setWidth(256),
                      height: ScreenUtil().setWidth(96),
                      decoration: BoxDecoration(
                        color: usePublicColor(1),
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(8)),
                      ),
                      child: Center(
                          child: Text("确定",
                              style: TextStyle(color: Colors.white))),
                    ),
                  ),
                ]),
            padding: EdgeInsets.only(bottom: 20),
          ),
        ),
      ]),
    );
  }

  ///选择输入框
  /// [control]输入抗控制器
  /// [title]输入框标题
  /// [hintText]输入框提示信息
  /// [select] 点击选择执行事件
  Widget selectInputBox(
    TextEditingController control, // 选择输入框控制器
    String title,
    String hintText,
    Function selectTop,
  ) {
    return Container(
      padding: EdgeInsets.only(
          right: ScreenUtil().setWidth(20), left: ScreenUtil().setWidth(20)),
      child: TextField(
        maxLines: 1,
        controller: control,
        enableInteractiveSelection: false,
        onTap: selectTop,
        decoration: InputDecoration(
            border: InputBorder.none,
            icon: Text("$title",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                    color: Color.fromRGBO(59, 57, 73, 1),
                    fontWeight: FontWeight.w700)),
            hintStyle: TextStyle(
                fontSize: ScreenUtil().setSp(26),
                color: Color.fromRGBO(201, 199, 210, 1)),
            hintText: "$hintText",
            suffixIcon: Icon(Icons.chevron_right,
                color: Color.fromRGBO(201, 199, 210, 1), size: 32)),
      ),
      decoration: BoxDecoration(
//      border:Border.all(width: 1,color: Color.fromRGBO(0, 0, 0, 0.41)),
        border: Border(
            bottom:
                BorderSide(width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.16))),
      ),
    );
  }

  /// 加载筛选条件
  filtrate() async {
    Map<String, dynamic> result = await getSalesDropDown(page, pageSize: 20);
    var resultArr = result['arr'];
    for (var item in resultArr) {
      setState(() {
        salesmanFiltrate
            .add({"title": item["salesManName"], "id": item["salesCode"]});
      });
    }
  }

  /// 顶部筛菜单
  DropdownMenu buildDropdownMenu() {
    return new DropdownMenu(
      // 下拉菜单
      maxMenuHeight: kDropdownMenuItemHeight * 10,
      menus: [
        new DropdownMenuBuilder(
            builder: (BuildContext context) {
              return new Theme(
                data: new ThemeData(),
                child: Container(
                  color: Colors.white,
                  child: DropdownListMenu(
                    selectedIndex: dateFiltrateIndex,
                    data: dateFiltrate,
                    itemBuilder: buildCheckItem,
                  ),
                ),
              );
            },
            height: kDropdownMenuItemHeight * dateFiltrate.length),
        new DropdownMenuBuilder(
            builder: (BuildContext context) {
              return new Theme(
                  data: new ThemeData(),
                  child: Container(
                    color: Colors.white,
                    child: DropdownListMenu(
                      selectedIndex: auditTypeIndex,
                      data: auditStatusFiltrate,
                      itemBuilder: buildCheckItem,
                    ),
                  ));
            },
            height: kDropdownMenuItemHeight * auditStatusFiltrate.length),
        new DropdownMenuBuilder(
            builder: (BuildContext context) {
              return new Theme(
                  data: new ThemeData(),
                  child: new Container(
                    color: Colors.white,
                    child: DropdownListMenu(
                      selectedIndex: salesman,
                      data: salesmanFiltrate,
                      itemBuilder: buildCheckItem,
                    ),
                  ));
            },
            height: kDropdownMenuItemHeight * salesmanFiltrate.length),
      ],
    );
  }
  /// 顶部筛选标题
  DropdownHeader buildDropdownHeader({DropdownMenuHeadTapCallback onTap}) {
    return new DropdownHeader(
      onTap: onTap,
      titles: [
        dateFiltrate[dateFiltrateIndex],
        auditStatusFiltrate[dateFiltrateIndex],
        salesmanFiltrate[salesman]
      ],
    );
  }

  void initSearch() {
    setState(() {
      _beginTime = DateTime.parse(
              DateTime.now().toLocal().toString().substring(0, 10) + " 00:00")
          .millisecondsSinceEpoch;
      _endTime = DateTime.parse(
              DateTime.now().toLocal().toString().substring(0, 10) + " 23:59")
          .millisecondsSinceEpoch;
      selectedEpp = {}; //选中的工程名称对象
      selectBuilder = {}; // 选中的施工单位对象
      selectSalesman = {}; // 选中的销售员对象
      contractCode = "";
      _selectedEppController = new TextEditingController();
      _selectedBuilderController = new TextEditingController();
      _selectedSalesmanController = new TextEditingController();
      timeButton = 0;
    });
  }

  _onReset() {
    initSearch();
  }

  _onSearch() {
    setState(() {
      _loading = true;
    });
    _onRefresh().then((v) {
      setState(() {
        _loading = false;
      });
    });

    Navigator.pop(context);
  }

  Widget _itemBuild(contract) {
    var contractStatus = "";
    Color contractStatusColor = Color.fromRGBO(255, 160, 1, 0.5);
    if (contract['verifyStatus']) {
      contractStatus = "已审核";
      contractStatusColor = Color.fromRGBO(254, 113, 95, 1);
    } else {
      contractStatus = "未审核";
      contractStatusColor = Color.fromRGBO(255, 160, 1, 0.5);
    }
    Map<String, dynamic> param = {};
    Widget dateText = Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
        child: Text("签订日期:   ${contract['signDate'].substring(0, 10)}",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(20), color: usePublicColor(2))));
    param['title'] =
        contract['contractId'] == null ? "" : contract['contractId'];
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((ScreenUtil().setWidth(8))),
          color: Colors.white,
        ),
        margin: EdgeInsets.only(
            right: ScreenUtil().setWidth(24),
            left: ScreenUtil().setWidth(24),
            top: ScreenUtil().setWidth(20)),
        child: Column(children: <Widget>[
          SizedBox(height: ScreenUtil().setWidth(20)),
          _getCardTop(contract, contractStatus, contractStatusColor),
          Padding(
              padding: EdgeInsets.only(
                  right: ScreenUtil().setWidth(30),
                  left: ScreenUtil().setWidth(30),
                  bottom: ScreenUtil().setWidth(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  contentRowViewPublic("施工单位", contract['builderName'],
                      fontSize: ScreenUtil().setSp(26), textHeight: 4),
                  contentRowViewPublic("工程名称", contract['eppName'],
                      fontSize: ScreenUtil().setSp(26), textHeight: 4),
                  contentRowViewPublic("业  务  员", contract['scaleName'],
                      endWidget: dateText,
                      fontSize: ScreenUtil().setSp(26),
                      textHeight: 4),
                ],
              ))
        ]),
      ),
      onTap: () async {
        if (auth["详情"]) {
          int result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ContractDetailPage(
                      contract['contractUid'],
                      contract['contractDetailCode'],
                      dataList)));
          if (result == null) {
            return;
          }
          if (result == 1) {
            contract['verifyStatus'] = true;
          } else if (result == 0) {
            contract['verifyStatus'] = false;
          }
        }
      },
    );
  }

  // card 卡片的头部
  _getCardTop(var contract, String contractStatus, Color contractStatusColor) {
    return Row(
      children: <Widget>[
        Container(
          width: ScreenUtil().setWidth(4),
          height: ScreenUtil().setWidth(32),
          color: usePublicColor(1),
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(26)),
        ),
        Expanded(
          child: Text(
            contract['contractId'] == null ? "" : contract['contractId'],
            style: TextStyle(
                fontSize: ScreenUtil().setSp(30),
                height: 1,
                color: usePublicColor(3),
                fontWeight: FontWeight.w800),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(22)),
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(16),
              ScreenUtil().setWidth(6),
              ScreenUtil().setWidth(16),
              ScreenUtil().setWidth(6)),
          child: Text(
            "$contractStatus",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(20),
                fontWeight: FontWeight.w700,
                color: contractStatus != "未审核"
                    ? usePublicColor(5)
                    : usePublicColor(6)),
          ),
          decoration: BoxDecoration(
              color: contractStatus != "未审核"
                  ? usePublicColor(4)
                  : usePublicColor(7),
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().setWidth(8)))),
        )
      ],
    );
  }

  Future _loadDate() async {
    if (!isLoading) {
      // 判断是否加载完毕，如果未加载完毕就不加载。
      setState(() {
//        _loading = true;
        isLoading = true;
      });
      Map<String, dynamic> result = await contractList(page,
          contractCode: contractCode,
          eppCode: selectedEpp['eppCode'],
          buildCode: selectBuilder['builderCode'],
          startTime: _beginTime.toString(),
          endTime: _endTime.toString(),
          salesMan: selectSalesman['salesCode']);

      setState(() {
        pageMap = result;
        if (result['arr'] != null) {
          for (var item in result['arr']) {
            dataList.add(item);
          }
          pageMap.remove("arr");
          // page++;
        }
        total = result['totalCount'].toString();
        isLoading = false;
//        _loading = false;
      });
    }
  }

  Future _onRefresh() async {
    setState(() {
      page = 1;
      dataList = [];
      // 重新设置NoData （没有更多数据）
      _refreshController.resetNoData();
    });
    try {
      await _loadDate();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  Future _onLoading() async {
    if (pageMap['totalPage'] <= page) {
      _refreshController.loadNoData();
      return;
    }
    page++;
    await _loadDate();
    _refreshController.loadComplete();
  }

  void changeTime(int type) {
    /**
     * 1代表本月
     * 2代表本周
     * 3代表三天内
     * 4代表昨天
     * 5代表上月
     * 6代表上周
     * 7代表今天
     */
    var operationTime = new OperationTime();
    int a = type;
    setState(() {
      timeButton = a;
    });
    switch (a) {
      case 1:
        setState(() {
          _beginTime =
              DateTime.parse(operationTime.month()["beginTime"].toString())
                  .millisecondsSinceEpoch;
          _endTime = DateTime.parse(operationTime.month()["endTime"].toString())
              .millisecondsSinceEpoch;
        });
        break;
      case 2:
        setState(() {
          _beginTime =
              DateTime.parse(operationTime.date()["beginTime"].toString())
                  .millisecondsSinceEpoch;
          _endTime = DateTime.parse(operationTime.date()["endTime"].toString())
              .millisecondsSinceEpoch;
        });
        break;
      case 3:
        setState(() {
          _beginTime =
              DateTime.parse(operationTime.threeDays()["beginTime"].toString())
                  .millisecondsSinceEpoch;
          _endTime =
              DateTime.parse(operationTime.threeDays()["endTime"].toString())
                  .millisecondsSinceEpoch;
        });
        break;
      case 4:
        setState(() {
          _beginTime =
              DateTime.parse(operationTime.yesterday()["beginTime"].toString())
                  .millisecondsSinceEpoch;
          _endTime =
              DateTime.parse(operationTime.yesterday()["endTime"].toString())
                  .millisecondsSinceEpoch;
        });
        break;
      case 5:
        setState(() {
          _beginTime =
              DateTime.parse(operationTime.lastMonth()["beginTime"].toString())
                  .millisecondsSinceEpoch;
          _endTime =
              DateTime.parse(operationTime.lastMonth()["endTime"].toString())
                  .millisecondsSinceEpoch;
        });
        break;
      case 6:
        setState(() {
          _beginTime =
              DateTime.parse(operationTime.lastWeek()["beginTime"].toString())
                  .millisecondsSinceEpoch;
          _endTime =
              DateTime.parse(operationTime.lastWeek()["endTime"].toString())
                  .millisecondsSinceEpoch;
        });
        break;
      case 7:
        setState(() {
          _beginTime =
              DateTime.parse(operationTime.toDay()["beginTime"].toString())
                  .millisecondsSinceEpoch;
          _endTime = DateTime.parse(operationTime.toDay()["endTime"].toString())
              .millisecondsSinceEpoch;
        });
        break;
    }
  }

  Widget getTimeButton(String title, int type) {
    return GestureDetector(
      onTap: () {
        changeTime(type);
      },
      child: Container(
        width: ScreenUtil().setWidth(168),
        height: ScreenUtil().setWidth(72),
        child: Center(
            child: Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: timeButton == type
                        ? usePublicColor(1)
                        : Colors.black))),
        decoration: BoxDecoration(
          color: timeButton == type
              ? Color.fromRGBO(50, 150, 250, 0.1)
              : usePublicColor(9),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(8)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  getAuth() async {
    auth["添加"] = await getPermission("erpPhone_ContractApi_addContract");
    auth["详情"] = await getPermission("erpPhone_ContractApi_getContractDetail");
  } // 本页权限

  topFiltrate(int type, dynamic data) async{

    if (type == 0) {
      // 日期筛选
     if( data["id"] != 3){
       changeTime(data["id"]);
     }
    } else if (type == 1) {
      // 审核状态筛选
      if (data["id"] == 2) {
        verifyStatus = null;
      }
      if (data["id"] != 2) {
        verifyStatus = data["id"];
      }
      print("合同状态$verifyStatus");
    } else if (type == 2) {
      // 业务员筛选
      if (data["id"] != 0) {
        selectSalesman["salesManName"] = data["title"];
        selectSalesman["salesCode"] = data["id"];
      } else if (data["id"] == 0) {
        selectSalesman = {};
      }
    }
   dataList = [];
   await _loadDate();
  }
}
