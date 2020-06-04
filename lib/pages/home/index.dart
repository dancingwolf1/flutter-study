import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spterp/util/user_util.dart';
import 'dart:ui';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
import 'package:flutter_spterp/pages/home/circular_graph.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spterp/pages/home/index_tool.dart';
import 'package:flutter_spterp/util/contorl_date.dart';
import 'package:flutter_spterp/pages/home/barView.dart';
import 'package:flutter_spterp/util/adaptive.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String serverVersion = ""; // 服务器版本
  String logoImageSrc = ""; // 砼鑫logo图片路径
  String textImageSrc = ""; // "砼鑫软件"图片路径
  String selectEnterpriseImageSrc = ""; // 选择企业图片路径
  double producedRatioActual; // 环形图真实的比值
  double producedRatioDisplay; // 环形图要显示的比值 百分比
  double producedUnProduction; // 环形图未生产的值

  String salesToday; // 销售方量今日生产值
  String salesYesterday; // 销售方量昨日生产值
  String salesMonth; // 销售方量本月生产值

  String producedToday; // 生产方量今日生产值
  String producedYesterday; // 生产方量昨日生产值
  String producedMonth; // 生产方量本月生产值

  List stockDate = []; // 未经过处理的库存数据数组
  List stockStirIdsList = []; // 楼号数组

  bool isShowSales; // 控制销售方量的显示
  bool isShowProduced; // 控制生产方量的显示
  bool isShowMaterial; // 控制原材料采购的显示
  bool isShowStock; // 控制实时库存的显示
  bool isShowErrorPan; // 控制超差盘数的显示

  double tabViewMinHeight; //  中tabView中最小的高度

  List autoList = []; // 权限数组
  List quickData = []; // 快捷方式数据数组
  List quickLocalData = []; // 本地的权限数组列表

  List<Widget> quickView = []; // 视图中所要的显示的快捷方式数组

  bool tabIsShow; // 控制 置顶tab的显示与隐藏
  double tabViewHeight = 0; //  tabView的高度
  List tabs = []; // 实时库存中的tab数组
  List production = []; // 预计生产数据数组
  int dataIndex; // 原材料所选中按钮的索引值
  Color enterpriseName; // 企业名称的字体颜色
  double topTransparent; // 控制顶部导航栏的透明度

  bool isLoadSales = true; // 控制销售方量的加载状态
  bool isLoadProduced = true; // 控制今日生产的加载状态
  bool isLoadingStock = true; // 控制实时库存的加载状态
  bool isLoadRawMaterial = true; // 控制原材料的加载状态
  double recordHeight = 0; // 实时库存切换tabView时，记录的tabView与最顶端的距离

  var topSateTextColor = SystemUiOverlayStyle.light; // 状态栏的文字的颜色
  int errorPan; // 超差盘数值

  Map<String, dynamic> selectedEnterprise = {}; // 所选中的企业对象

  ScrollController _controller = new ScrollController(); //滚动视图控制器
  TabController tabController; // 实时库存切换tabView的控制器
  GlobalKey anchorKey = GlobalKey(); // 实时库存tab的控制器(使用了一个静态常量Map来保存它对应的Element)

  @override
  void initState() {
    super.initState();
    _initDate(); // 初始化数据和加载部分方法
    //_checkUpdate(); // 项目更新(可异步,不影响视图)
    // _onScroll(); // 滚动监听
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    tabController.dispose();
  }

  /// 根据所滚动的距离，更改appBar中的文字颜色，图片颜色，还有状态栏的颜色
  ///[distance]  页面滚动高度
  _changeStatus(double distance) {
    if (distance == 0) {
      setState(() {
        logoImageSrc = "images/index_logo.png";
        textImageSrc = "images/index_title_white.png";
        enterpriseName = Colors.white;
        selectEnterpriseImageSrc = "images/jianzhu.png";
        topSateTextColor = SystemUiOverlayStyle.light;
      });
    } else if (distance > 0 && distance < 30) {
      setState(() {
        logoImageSrc = "images/index_logo.png";
        textImageSrc = "images/index_title.png";
        enterpriseName = Colors.black;
        selectEnterpriseImageSrc = "images/index_p.png";
        topSateTextColor = SystemUiOverlayStyle.dark;
      });
    }
  }

  /// 根据滚动的距离控制appBar的背景透明度
  ///[distance]  页面滚动高度
  _changeBgTransparent(double distance) {
    if (0 <= distance && distance <= 100) {
      setState(() {
        topTransparent = (distance) / 100;
      });
    }

    if (distance > 100 && distance < 130) {
      topTransparent = 1;
    }
  }

  /// 根据滚动的距离控制实时库存顶部tab的隐藏与显示
  _controlTabShow() {
    RenderBox renderBox = anchorKey.currentContext.findRenderObject();
    var offset = renderBox.localToGlobal(Offset.zero); // 获取控件的坐标

    if (offset.dy < 80) {
      _recordHeightTabView();
      setState(() {
        tabIsShow = false;
      });
    } else if (!tabIsShow) {
      setState(() {
        tabIsShow = true;
      });
    }
  }

  /// 记录实时库存当前tabView的高度
  _recordHeightTabView() {
    if (tabIsShow == true) {
      recordHeight = _controller.offset; // 记录实时库存当前tabView的高度
    }
  }

  /// 初始化数据
  _initDate() async {
    serverVersion = ""; //服务器版本
    logoImageSrc = "images/index_logo.png";
    textImageSrc = "images/index_title_white.png";
    selectEnterpriseImageSrc = "images/jianzhu.png";
    dataIndex = 0;
    enterpriseName = Colors.white;
    topTransparent = 0;
    tabController = TabController(length: 0, vsync: this);
    tabs = [];
    tabViewHeight = 0; // 该值为153的倍数
    tabIsShow = true;
    production = [
      {"pre_num": 0, "produce_num": 0}
    ]; //预计生产数据数组的数据模板防止后台传production=[null]
    producedRatioActual = 0; // 环形图真实的比值
    producedRatioDisplay = 0; // 环形图要显示的比值 百分比
    producedUnProduction = 0;

    salesToday = "0";
    salesYesterday = "0";
    salesMonth = "0";

    producedToday = "0";
    producedYesterday = "0";
    producedMonth = "0";

    stockDate = [];
    stockStirIdsList = [];

    isShowSales = true;
    isShowProduced = true;
    isShowMaterial = true;
    isShowStock = true;
    isShowErrorPan = true;
    errorPan = 0;

    quickLocalData = [
      {
        'name': '配件购置',
        'auth': "erpPhone_PartsApi_getPartsList",
        'judge': false,
        'src': 'images/index_22.png',
        'link': '/accessories'
      },

    ];

    await _getSelectedEnterprise().then((v) {
      _setAgId();
    }); // 企业切换(危险异步可能会影响视图),切换企业时需权限组(这个需要同步很多数据必须根据权限来加载不可异步)
    await _loadPermission(); // 不可异步,数据要根据权限来加载

    _loadQuick(); // 加载快捷图标

  }

  /// 切换企业要初始化的值和所要执行的方法
  _switchingCompanyInitDate() async {
    dataIndex = 0;
    tabController = TabController(length: 0, vsync: this);
    tabs = [];
    tabViewHeight = 0; // 基数153
    production = [];
    stockDate = [];
    stockStirIdsList = [];
    production = [
      {"pre_num": 0, "produce_num": 0}
    ];
    producedRatioActual = 0;
    producedRatioDisplay = 0;
    producedUnProduction = 0;

    salesToday = "0";
    salesYesterday = "0";
    salesMonth = "0";

    producedToday = "0";
    producedYesterday = "0";
    producedMonth = "0";

    isShowSales = true;
    isShowProduced = true;
    isShowMaterial = true;
    isShowStock = true;
    isShowErrorPan = true;
    errorPan = 0;

    /// 不可异步,权限的加载要根据权限组id来加载

    /// 不可异步,数据要根据权限来加载
    await _loadPermission();

    /// 企业切换(危险异步可能会影响视图),切换企业时需权限组(这个需要同步很多数据必须根据权限来加载不可异步)
    await _getSelectedEnterprise();

    /// 不可异步,数据要根据权限来加载

  }

  /// 加载超差盘数的值
  _loadGetErrorPan() async {
    int result = await getErroPan(
        DateTime
            .parse(
            DateTime.now().toLocal().toString().substring(0, 10) + " 00:00")
            .millisecondsSinceEpoch,
        DateTime
            .parse(
            DateTime.now().toLocal().toString().substring(0, 10) + " 23:59")
            .millisecondsSinceEpoch);
    setState(() {
      errorPan = result;
    });
  }

  /// 获得超差盘数的视图组件
  Widget _errorPanView({String sum}) {
    if (errorPan.toString() == "0" || !isShowErrorPan) {
      return SizedBox();
    }

    return MaterialButton(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      onPressed: () => {},
      child: Text("${errorPan < 100 ? errorPan : "99+"}盘",
          style:
          TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(32))),
      color: Color.fromRGBO(242, 86, 68, 1),
      shape: StadiumBorder(),
      height: ScreenUtil().setWidth(32),
    );
  }

  /// 加载快捷方式数组
  _loadQuick() async {
    List result = await getUserFavorite();
    if (result == null) {
      result = [];
    }
    print("我的快捷方式数组:$result");
    // 兼容老版本mid快捷方式数组
    clearOldShortcuts(result);

    setState(() {
      quickData = result;
    });
  }

  /// 图表的title部分
  /// [title]  标题
  /// [link]  所要跳转的链接
  /// [unit]  单位值
  _titleModuleView(String title, String link, {String unit}) {
    String isUnit = "";

    if (unit != null) {
      isUnit = "单位:  $unit";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(children: <Widget>[
          Text("$title",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: ScreenUtil().setSp(32),
                  color: Color.fromRGBO(59, 57, 73, 1))),
          Text(
            "${isUnit == "" ? "" : "（"}",
            style: TextStyle(
                color: Color.fromRGBO(139, 137, 151, 1),
                fontSize: ScreenUtil().setSp(20)),
          ),
          Text(
            "$isUnit",
            style: TextStyle(
                color: Color.fromRGBO(139, 137, 151, 1),
                fontSize: ScreenUtil().setSp(28)),
          ),
          Text(
            "${isUnit == "" ? "" : "）"}",
            style: TextStyle(
                color: Color.fromRGBO(139, 137, 151, 1),
                fontSize: ScreenUtil().setSp(20)),
          ),
        ]),
        GestureDetector(
            onTap: () async {
              await Navigator.pushNamed(context, "$link");
            },
            child: Stack(
              children: <Widget>[
                Container(
                  width: 80,
                  height: 20,
                  color: Colors.transparent,
                ),
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "详情",
                          style: TextStyle(
                              color: Color.fromRGBO(201, 199, 210, 1),
                              height: ScreenUtil().setWidth(1.4),
                              fontSize: ScreenUtil().setSp(24)),
                        ),
                        Icon(Icons.chevron_right,
                            color: Color.fromRGBO(201, 199, 210, 1),
                            size: ScreenUtil().setSp(24)),
                      ],
                    )),
              ],
            )),
      ],
    );
  }

  /// 更新版本
  Future _checkUpdate() async {
    if (Platform.isAndroid) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      print("当前版本:$version+$buildNumber");
      Map<String, dynamic> result = await checkUpdate();
      serverVersion = result['version'];
      if (serverVersion != "$version+$buildNumber") {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('有新版本'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("最新版本:$serverVersion"),
                    Text('更新内容:${result['updateContent'][serverVersion]}'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('前往更新'),
                  onPressed: _openLaunch,
                ),
                FlatButton(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  /// 获取更新版本的路径
  _openLaunch() async {
    String url = 'http://downloads.hntxrj.com/$serverVersion.apk';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Toast.show("无法打开浏览器，请授予应用权限");
      Navigator.of(context).pop();
    }
  }

  /// 选择企业
  _showSelectEnterprise() async {
    Map<String, dynamic> userMap = await getUser();
    List enterprises = userMap['enterprises'];
    List<Widget> eList = new List();
    for (var enterprise in enterprises) {
      eList.add(_enterpriseItem(enterprise));
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("选择企业"),
          content: SingleChildScrollView(
            child: ListBody(
              children: eList,
            ),
          ),
        );
      },
    );
    setState(() {
      _switchingCompanyInitDate();
    });
  }

  /// 初次进入app加载默认的企业
  Future _getSelectedEnterprise() async {
    /// 获取当前选中企业
    SharedPreferences pref = await SharedPreferences.getInstance();
    String enterpriseStr = pref.getString("selectedEnterprise");
    if (enterpriseStr == null || enterpriseStr == "") {
      ///  如果未选择就获取第一个
      Map<String, dynamic> userMap = await getUser();
      enterpriseStr = json.encode(userMap['enterprises'][0]);
    }
    setState(() {
      selectedEnterprise = json.decode(enterpriseStr);
    });
  }

  /// 获得并存储权限组代号agid的值
  _setAgId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user = json.decode(pref.getString("user"));

    for (var authItem in user['userAuths']) {
      if (selectedEnterprise['eid'] == authItem['enterprise']['eid']) {
        pref.setInt("agid", authItem['authGroup']['agid']);
      }
    }
  }

  /// 快捷方式视图列表中的item
  ///[item]  生成item依赖的对象
  Widget _getQuickViewItem(Map item) {
    return GestureDetector(
        onTap: () async {
          await Navigator.pushNamed(context, item["link"]);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage(item['src']),
              width: ScreenUtil().setWidth(96),
              height: ScreenUtil().setWidth(96),
            ),
            SizedBox(
              height: ScreenUtil().setWidth(12),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(100),
              child: Text(
                "${item["name"]}",
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(fontSize: ScreenUtil().setSp(24)),
              ),
            ),
          ],
        ));
  }

  /// 选择一个企业后所执行方法
  ///[enterprise]  选中的enterprise对象
  _enterpriseItem(enterprise) {
    return RadioListTile<String>(
      value: '${enterprise['eid']}',
      title: Text('${enterprise['epShortName']}'),
      selected: selectedEnterprise['eid'] == enterprise['eid'],
      groupValue: "selecedEnterprise",
      onChanged: (value) async {
        /// 设置企业
        SharedPreferences pref = await SharedPreferences.getInstance();
        setState(() {
          selectedEnterprise = enterprise;
          pref.setString("selectedEnterprise", json.encode(enterprise));
          Navigator.of(context).pop();
        });
        await _switchingCompanyInitDate();
      },
    );
  }

  /// 加载权限并储存
  _loadPermission() async {
    String auth = ""; //返回处理好的赋值
    List authList1 = [];
    var result = await getAuthValue();
    auth = result['openAuth'].replaceAll('[', ''); // 我会返回数组
    auth = auth.replaceAll(']', '');
    auth = auth.replaceAll('"', '');
    SharedPreferences prefs =
    await SharedPreferences.getInstance(); // 我把权限存储到本地
    prefs.setString('authValue', auth); // 我存储起来了，用的时候切割一下
    authList1 = auth.split(',');
    autoList = authList1;
    return authList1;
  }

  /// 加载今日预计产量
  Future _loadProductionToday() async {
    List<dynamic> result = await getProductionToday();
    setState(() {
      production = result;
      if (production.length != 0) {
        // 如果production数组长度为0的操作
      } else {
        production.add({"produce_num": 0, "pre_num": 0});
      }
      producedUnProduction = double.parse(
          (production[0]["pre_num"] - production[0]["produce_num"])
              .toString()); // 未完成
      if (producedUnProduction < 0) {
        producedUnProduction = 0;
      }
    });
  }

  /// 加载销售数据
  Future _loadSales() async {
    setState(() {
      isLoadSales = true;
      isLoadProduced = true;
    });

    getSquareQuantitySum(
        beginTime: new DateTime.now()
            .subtract(new Duration(days: 0))
            .toString()
            .substring(0, 10),
        endTime: new DateTime.now()
            .add(new Duration(days: 0))
            .toString()
            .substring(0, 10),
        type: 1)
        .then((resultEnd) {
      setState(() {
        if (resultEnd != null && resultEnd['sale_num'] != null) {
          salesToday = resultEnd['sale_num'].toString();
          producedToday = resultEnd['produce_num'].toString();
        }
      });
    });
    getSquareQuantitySum(
        beginTime: new DateTime.now()
            .subtract(new Duration(days: 0))
            .toString()
            .substring(0, 10), // 减 1 天
        endTime: new DateTime.now()
            .subtract(new Duration(days: 0))
            .toString()
            .substring(0, 10),
        type: 2)
        .then((resultYesterday) {
      setState(() {
        if (resultYesterday != null && resultYesterday['sale_num'] != null) {
          salesYesterday = resultYesterday['sale_num'].toString();
          producedYesterday = resultYesterday['produce_num'].toString();
        }
      });
    });
    var now = DateTime.now();
    getSquareQuantitySum(
        beginTime:
        "${now.year}-${now.month < 10 ? '0' + (now.month).toString() : now
            .month}-01",
        endTime:
        "${now.year}-${now.month + 1 < 10
            ? '0' + (now.month + 1).toString()
            : now.month + 1}-01",
        type: 3)
        .then((resultMonth) {
      setState(() {
        if (resultMonth != null && resultMonth['sale_num'] != null) {
          salesMonth = resultMonth['sale_num'].toString();
          producedMonth = resultMonth['produce_num'].toString();
        }
      });
    }).then((v) =>
    {
      setState(() {
        isLoadSales = false;
        isLoadProduced = false;
      })
    });
  }

  /// 根据时间来加载原材料采购的数据
  ///[dateTypeNumber]   日期代号（比如5，代表今天）
  ///[buttonNumber]  当前所点击的按钮代号


  /// 当页面滚动所执行的事件
  _onScroll() {
    _changeStatus(
        _controller.offset); // 根据所滚动的距离，更改appBar中的文字颜色，图片颜色，还有状态栏的颜色
    _changeBgTransparent(_controller.offset); // 根据滚动的距离控制appBar的背景透明度
    _controlTabShow(); // 根据滚动的距离控制实时库存顶部tab的隐藏与显示

    topTransparent = 1;
    setState(() {
      logoImageSrc = "images/index_logo.png";
      textImageSrc = "images/index_title.png";
      enterpriseName = Colors.black;
      selectEnterpriseImageSrc = "images/index_p.png";
      topSateTextColor = SystemUiOverlayStyle.dark;
    });
  }


  /// 获得显示的快捷方式列表
  _quickView() {
    quickView = []; // 因为该方法是在build内执行所以在每次执行前都要将quickView置为空
    quickData.remove(""); // 除去异常的权限值
    if (quickData.length != 0) {
// 当快捷数组里面有值，则依照快捷数组加载快捷方式列表
      _quickViewSelect(quickData, true);
    } else if (quickData.length == 0) {
// 当快捷数组里面没有值，则依照用户所拥有的权限加载快捷方式列表
      _quickViewSelect(autoList, false);
    }
// 增加“更多”图标
    setState(() {
      quickView.add(GestureDetector(
          onTap: () async {
            await Navigator.pushNamed(context, "/menu");
            _initDate();
            _onScroll();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('images/index_05.png'),
                width: ScreenUtil().setWidth(96),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(12),
              ),
              Text(
                "更多",
                style: TextStyle(fontSize: ScreenUtil().setSp(24)),
              ),
            ],
          )));
    });

    return quickView;
  }

  /// 根据所得到数组list加载快捷方式数组
  ///[list]  生成快捷数组所依赖的数组
  ///[select]  判断用户是否有选择的快捷方式
  _quickViewSelect(List list, bool select) {
    quickLocalData.forEach((item) {
      if ((list.contains(item["auth"]) || list.contains(" ${item["auth"]}")) &&
          quickView.length < 4) {
        setState(() {
          quickView.add(_getQuickViewItem(item));
        });
      }
    });
  }


  /// 置于顶部的实时库存tab
  Widget _topTab() {
    return Positioned(
      top: 80,
      child: Offstage(
          offstage: tabIsShow, //这里控制
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 40,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                color: Colors.white,
                child: TabBar(
                    isScrollable: false,
                    labelStyle: TextStyle(fontSize: ScreenUtil().setSp(26)),
                    labelColor: Color.fromRGBO(50, 150, 250, 1),
                    unselectedLabelColor: Color.fromRGBO(51, 51, 51, 1),
                    labelPadding: EdgeInsets.only(top: 0),
                    indicatorPadding: EdgeInsets.only(),
                    indicatorSize: TabBarIndicatorSize.label,
                    //生成Tab菜单
                    controller: tabController,
                    //构造Tab集合
                    tabs: tabs.map((e) => Tab(text: e)).toList()),
              ),
            ],
          )),
    );
  }

  /// 主视图的顶部，包括环形图和快捷方式列表
  Widget _mainViewTop() {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        Container(
          width: double.infinity,
          color: Colors.white,
          height: ScreenUtil().setWidth(800),
        ),
        Container(
            height: ScreenUtil().setWidth(684),
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/index_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 60,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Color.fromRGBO(255, 255, 255, 0.1),
                        minRadius: ScreenUtil().setWidth(147),
                      ),
                      CircleAvatar(
                        backgroundColor: Color.fromRGBO(255, 255, 255, 0.18),
                        minRadius: ScreenUtil().setWidth(123),
                      ),
                      GradientCircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                        colors: [
                          Color.fromRGBO(1, 255, 186, 1),
                          Color.fromRGBO(252, 113, 97, 1),
                        ],
                        radius: ScreenUtil().setWidth(137),
                        stokeWidth: ScreenUtil().setWidth(24),
                        strokeCapRound: true,
                        value: double.parse(producedRatioActual.toString()),
                      ),
                      Column(
                        children: <Widget>[
                          Text("${producedRatioDisplay.toStringAsFixed(0)}%",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(60))),
                          Text("已完成",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setWidth(28))),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setWidth(40)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Text("${production[0]["produce_num"]}",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(40),
                                      color: Colors.white)),
                              SizedBox(
                                height: ScreenUtil().setWidth(6),
                              ),
                              Text("已完成",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(28),
                                      color: Colors.white))
                            ],
                          ),
                        ),
                        //今日计划
                        GestureDetector(
                          onTap: () async {
                            await Navigator.pushNamed(
                                context, "/production_planning");
                          },
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Text("${production[0]["pre_num"]}",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(40),
                                        color: Colors.white)),
                                SizedBox(
                                  height: ScreenUtil().setWidth(6),
                                ),
                                Text("今日计划",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(28),
                                        color: Colors.white))
                              ],
                            ),
                          ),
                        ),

                        Container(
                          child: Column(
                            children: <Widget>[
                              Text("${producedUnProduction.toStringAsFixed(0)}",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(40),
                                      color: Colors.white)),
                              SizedBox(
                                height: ScreenUtil().setWidth(6),
                              ),
                              Text("未完成",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(28),
                                      color: Colors.white))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*     Container(
                                height: 100,
                                width: 100,
                                color: Colors.red,
                              ),*/
                ],
              ),
            )),
        Positioned(
          bottom: 0,
          child: Container(
            padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(32),
                right: ScreenUtil().setWidth(32),
                left: ScreenUtil().setWidth(32)),
            width: ScreenUtil().setWidth(702),
            height: ScreenUtil().setWidth(234),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.vertical(
                  top: Radius.elliptical(
                      ScreenUtil().setWidth(44), ScreenUtil().setWidth(44))),
            ),
            child: Wrap(
                spacing: ScreenUtil().setWidth(35), children: _quickView()),
          ),
        ),
      ],
    );
  }

  /// 主视图的底部
  Widget _mainViewBottom() {
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setWidth(48)),
      height: ScreenUtil().setWidth(268),
      color: Color.fromRGBO(248, 248, 248, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(
                height: ScreenUtil().setWidth(1),
                width: ScreenUtil().setWidth(136),
                decoration: new BoxDecoration(
                  border: new Border.all(
                      color: Color.fromRGBO(207, 207, 210, 1),
                      width: ScreenUtil().setWidth(136)),
                  color: Color(0xFF9E9E9E),
                  borderRadius:
                  new BorderRadius.vertical(top: Radius.elliptical(20, 50)),
                )),
            SizedBox(width: ScreenUtil().setWidth(20)),
            Text("已经到底部了",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(26),
                    color: Color.fromRGBO(207, 207, 210, 1)),
                textAlign: TextAlign.center),
            SizedBox(width: ScreenUtil().setWidth(20)),
            Container(
                height: ScreenUtil().setWidth(1),
                width: ScreenUtil().setWidth(136),
                decoration: new BoxDecoration(
                  border: new Border.all(
                      color: Color.fromRGBO(207, 207, 210, 1),
                      width: ScreenUtil().setWidth(136)),
                  // 边色与边宽度
                  color: Color(0xFF9E9E9E),
                  borderRadius:
                  new BorderRadius.vertical(top: Radius.elliptical(20, 50)),
                )),
          ])
        ],
      ),
    );
  }


  Widget _mainView() {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            // MediaQuery.removePadding是为了去除ListView默认的顶部的Padding
            MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: NotificationListener(
                    child: ListView(
                      controller: _controller,
                      children: <Widget>[
                        _mainViewTop(),
                        _mainViewBottom() // 主视图底部
                      ],
                    ),
                    onNotification: (scrollNotification) { // 监听页面滚动
                      if (scrollNotification is ScrollUpdateNotification &&
                          scrollNotification.depth == 0) {
                        _changeStatus(scrollNotification.metrics
                            .pixels); // 根据所滚动的距离，更改appBar中的文字颜色，图片颜色，还有状态栏的颜色
                        _changeBgTransparent(scrollNotification.metrics
                            .pixels); // 根据滚动的距离控制appBar的背景透明度
                        _controlTabShow();
                      }
                      return true; // 取消事件冒泡
                    })),
            _myAppBar(),
            _topTab(),
          ],
        ));
  }

  /// 快捷键兼容问题
  clearOldShortcuts(List queryList) async {
    for (int i = 0; i < queryList.length; i++) {
      try {
        // 如果我有旧版的mid将权限列表初始化
        if (double.parse(queryList[i]) is double) {
          await setUserFavorite(config: "[]"); // 如果我有旧版的mid那么我就把权限数组初始化
          await _loadQuick(); // 并重新加载数组列表
          break;
        }
      } catch (v) {

      }
    }
  }

  /// 自定义的appBar
  Widget _myAppBar() {
    return Container(
      decoration: new BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, topTransparent),
        border: new Border(
          bottom: BorderSide(
              color: Color.fromRGBO(238, 238, 238, topTransparent), width: 1),
        ),
      ),
      padding: EdgeInsets.only(
          top: MediaQuery
              .of(context)
              .padding
              .top,
          left: ScreenUtil().setWidth(32),
          right: ScreenUtil().setWidth(32)),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image(
                  image: AssetImage(logoImageSrc),
                  height: ScreenUtil().setWidth(32)),
              SizedBox(width: ScreenUtil().setWidth(20)),
              Image(
                  image: AssetImage(textImageSrc),
                  height: ScreenUtil().setWidth(32)),
            ],
          ),
          FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              _showSelectEnterprise();
            },
            child: Row(
              children: <Widget>[
                Text(
                  "${selectedEnterprise['epShortName'] == null
                      ? "未选择"
                      : selectedEnterprise['epShortName']}",
                  style: TextStyle(
                    color: enterpriseName,
                    fontSize: ScreenUtil().setSp(24),
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(18)),
                Container(
                  margin: EdgeInsets.only(right: 5.0),
                  child: Image(
                    image: AssetImage(selectEnterpriseImageSrc),
                    height: ScreenUtil().setWidth(36),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 获取对应材料的数值如果没有该材料则返回0;
  materialData(List arr, String name) {
    for (int j = 0; j < arr.length; j++) {
      if (arr[j]["matName"] == name) {
        return arr[j]["tlWeight"];
      }
    }
    return 0;
  }


  @override
  Widget build(BuildContext context) {
    adaptation(context); //适配
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: topSateTextColor,
        child: Material(
            child: Stack(
              children: <Widget>[
                //_statesBg(), // 状态栏背景
                _mainView() // 主视图
              ],
            )));
  }

}
/// 原材料采购构建柱状图，每个柱子的类
class BarSales {
  String name;
  int sale;
  BarSales(this.name, this.sale);
}