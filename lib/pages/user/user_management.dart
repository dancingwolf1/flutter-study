import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:flutter_spterp/component/no_more.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:flutter_spterp/pages/user/user_management_details.dart';
import 'package:flutter_spterp/pages/user/user_add.dart';
import 'package:flutter_spterp/component/list_info.dart';

class UserManagementPage extends StatefulWidget {
  @override
  ContractListPageState createState() => ContractListPageState();
}

class ContractListPageState extends State<UserManagementPage> {
  RefreshController _refreshController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Map<String, dynamic> pageMap = {};
  Map auth = {
    "添加": false,
    "详情": false,
    "绑定司机":false
  };

  List<Map<String, dynamic>> dataList = [];

  int page = 1;

  bool isLoading = false;
  bool _loading = false;

  String username = "";
  String phoneNum = "";
  String email = "";

  TextEditingController _selectUsernameController;
  TextEditingController _selectPhoneController;
  TextEditingController _selectEmailNameController;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
      _refreshController = RefreshController();
      _selectUsernameController = new TextEditingController();
      _selectPhoneController = new TextEditingController();
      _selectEmailNameController = new TextEditingController();
      _loading = true;
      getAuth();
     _loadDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("用户管理列表"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ],
        ),
        body: loading(
            _loading,
            Stack(
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
                          physics: BouncingScrollPhysics(),
                          children: dataList.length == 0
                              ? <Widget>[noMore()]
                              : dataList
                                  .map((contract) => _itemBuild(contract))
                                  .toList(),
                        )
                ),
              ],
            )),
        endDrawer: _searchDrawer(),
        floatingActionButton: !_loading && auth["添加"]
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () async {
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UseAddPage()));
                })
            : Container());
  }
  // 搜索侧边栏
  Widget _searchDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.fromLTRB(8.0, 38.0, 8.0, 0),
        children: <Widget>[
          Text(
            "搜索数据",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          TextField(
            controller: _selectUsernameController,
            decoration:
                InputDecoration(icon: Icon(Icons.person), hintText: "请输入用户名"),
            onChanged: (val) {
              setState(() {
                username = val;
              });
            },
          ),
          TextField(
            controller: _selectPhoneController,
            decoration: InputDecoration(
                icon: Icon(Icons.phone_iphone), hintText: "请输入手机号"),
            onChanged: (val) {
              setState(() {
                phoneNum = val;
              });
            },
          ),
          TextField(
            controller: _selectEmailNameController,
            decoration:
                InputDecoration(icon: Icon(Icons.email), hintText: "请输入邮箱"),
            onChanged: (val) {
              setState(() {
                email = val;
              });
            },
          ),
          RaisedButton(
            color: Colors.blue,
            child: Text(
              "搜索",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _onSearch();
            },
          ),
          RaisedButton(
            child: Text("重置"),
            onPressed: () {
              _onReset();
            },
          )
        ],
      ),
    );
  }

  void initSearch() {
    setState(() {
      _selectUsernameController = new TextEditingController();
      _selectPhoneController = new TextEditingController();
      _selectEmailNameController = new TextEditingController();

      username = ""; // 用户名
      phoneNum = ""; // 手机号
      email = ""; // 邮箱
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
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              contentRowViewPublic("用  户  名", contract['user']['username']),
              contentRowViewPublic("手  机  号", contract['user']['phone']),
              contentRowViewPublic("所属企业", contract['enterprise']['epShortName']),
              contentRowViewPublic("权  限  组", contract['authGroup']['agName']),
              contentRowViewPublic("状        态",
                  contract['user']['status'].toString() == "0" ? "启用" : "未启用"),
              contentRowViewPublic("邮        箱", contract['user']['email']),
              contentRowViewPublic("绑定司机",contract['driverName']==""?"未绑定":contract['driverName']),


            ],
          ),
        ),
      ),
      onTap: () async {
        if (auth["详情"]) {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => DetailPage(contract)));
          _onRefresh();
        }
      },
    );
  }

  Future _loadDate() async {
    if (!isLoading) {

      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> result = await userList(
        page: page,
        username: username,
        phoneNum: phoneNum,
        email: email,
      );

      setState(() {
        pageMap = result;
        if (result['arr'] != null) {
          for (var item in result['arr']) {
            dataList.add(item);
          }
          pageMap.remove("arr");
        }
        isLoading = false;
        _loading = false;
      });
    }
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

  Future _onLoading() async {
    if (pageMap['totalPage'] <= page) {
      _refreshController.loadNoData();
      return;
    }
    page++;
    await _loadDate();
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  getAuth() async {
    auth["添加"] = await getPermission("erpPhone_UserController_addUser");
    auth["详情"] = await getPermission("erpPhone_UserController_details");
    auth["绑定司机"] = await getPermission("erpPhone_UserController_getBindDriver");
  }
}
