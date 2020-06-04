import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:flutter_spterp/component/no_more.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:flutter_spterp/pages/menu_list.dart';
import 'package:flutter_spterp/pages/sys/auth_groups_add.dart';
import 'package:flutter_spterp/component/list_info.dart';

class AuthGroupPage extends StatefulWidget {
  @override
  AuthGroupPageState createState() => AuthGroupPageState();
}

class AuthGroupPageState extends State<AuthGroupPage> {
  RefreshController _refreshController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int page = 1;

  Map<String, dynamic> pageMap = {};
  Map auth = {
    "添加": false,
    "编辑权限": false,
    "编辑": false,
  };

  bool isLoading = false;
  bool _loading = false;

  String authName = ""; // 权限组名称
  String selectItemState; // 选择的状态

  List<DropdownMenuItem> isEnable;
  List<Map<String, dynamic>> dataList = [];

  TextEditingController _selectedAuthNameControl; // 权限组控制器
  TextEditingController _selectedJurisdictionControl;
  TextEditingController _selectEnterpriseControl;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
      _refreshController = RefreshController();
      _selectedAuthNameControl = new TextEditingController();
      selectItemState = "0";
      isEnable = [
        DropdownMenuItem(value: '0', child: new Text('启用')),
        DropdownMenuItem(value: '1', child: new Text('禁用')),
      ];
      _loading = true;
      getAuth();
    _loadDate();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("权限组管理"),
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
                  child:  ListView(
                          // 处理手势过快 回弹越界。
                          physics: BouncingScrollPhysics(),
                          children: dataList.length == 0
                              ? <Widget>[noMore()]
                              : dataList
                                  .map((contract) => _itemBuild(contract))
                                  .toList(),
                        )
                ), //列表
              ],
            )),
        endDrawer: _searchDrawer(),
        floatingActionButton: !_loading && auth["添加"]
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () async {
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RightsAddPage()));
                  // 返回刷新
                  _onRefresh();
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
            controller: _selectedAuthNameControl,
            enableInteractiveSelection: false,
            decoration: InputDecoration(
                icon: Icon(Icons.indeterminate_check_box), hintText: "请输入权限名称"),
            onChanged: (val) async {
              setState(() {
                authName = val;
              });
            },
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.turned_in,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: DropdownButtonHideUnderline(
                  child: new DropdownButton(
                    hint: new Text('请选择状态'),
                    //设置这个value之后,选中对应位置的item，
                    //再次呼出下拉菜单，会自动定位item位置在当前按钮显示的位置处
                    value: selectItemState,
                    items: isEnable,
                    onChanged: (T) {
                      setState(() {
                        selectItemState = T;
                      });
                    },
                  ),
                ),
              ),
            ],
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
      authName = "";
      selectItemState = "0"; // 选择的状态
      _selectedAuthNameControl = new TextEditingController();
    });
  }

  _onReset() {
    initSearch();
  }

  _onSearch() {
    setState(() {
      _loading = true;
    });
    _onRefresh();

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
            contentRowViewPublic(
                "权限组名称", contract['agName']),
            contentRowViewPublic("状       态", contract['agStatus'] == 0 ? "启用" : "未启用"),
            contentRowViewPublic(
                "所属企业",
                contract['enterpriseName'] ),
            contentRowViewPublic("创建时间",
                contract['createTime']),
            contentRowViewPublic("更新时间",
                contract['updateTime']),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                auth["编辑"]
                    ? RaisedButton(
                        child: Text("编辑"),
                        onPressed: () {
                          getEject(contract);
                        },
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.all(20),
                ),
                auth["编辑权限"]
                    ? RaisedButton(
                        child: Text("编辑权限"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MenuListDemo(
                                      contract["agid"].toString())));
                        },
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  Future _loadDate() async {
    if (!isLoading) {
      // 判断是否加载完毕，如果未加载完毕就不加载。
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> result = await getAuthGroup(page, 20,
          agName: authName, agStatus: int.parse(selectItemState));

      setState(() {
        pageMap = result;

        if (result['arr'] != null) {
          for (var item in result['arr']) {
            dataList.add(item);
          }
          pageMap.remove("arr");
          // page++;
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

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  getEject(Map obj) {
    showDialog(
        context: context,
        builder: (context) {
          bool selected;
          if (obj["agStatus"].toString() == "0") {
            selected = false;
          } else if (obj["agStatus"].toString() == "1") {
            selected = true;
          }

          String name;
          String status;
          name = obj["agName"];
          _selectedJurisdictionControl = new TextEditingController();
          _selectEnterpriseControl = new TextEditingController();
          _selectedJurisdictionControl.text = obj["agName"];
          _selectEnterpriseControl.text = obj["enterprise"].toString();
          return new AlertDialog(
            title: new Text("编辑权限组"),
            content:
                new StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                  height: 220,
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: _selectedJurisdictionControl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            icon: Icon(Icons.golf_course), hintText: "权限组"),
                        onChanged: (val) async {
                          setState(() {
                            name = val;
                          });
                        },
                      ),
                      TextField(
                        enabled: false,
                        keyboardType: TextInputType.number,
                        controller: _selectEnterpriseControl,
                        decoration: InputDecoration(
                            icon: Icon(Icons.compare), hintText: "所属企业"),
                        onChanged: (val) async {
                          setState(() {});
                        },
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: new CheckboxListTile(
                                title: new Text(
                                  "停用",
                                  softWrap: false,
                                  style: TextStyle(fontSize: 14),
                                ),
                                value: selected,
                                onChanged: (bool) {
                                  setState(() {
                                    selected = !selected;
                                  });
                                }),
                          ),
                          Expanded(
                            child: new CheckboxListTile(
                                title: new Text(
                                  "启用",
                                  softWrap: false,
                                  style: TextStyle(fontSize: 14),
                                ),
                                value: !selected,
                                onChanged: (bool) {
                                  setState(() {
                                    selected = !selected;
                                  });
                                }),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RaisedButton(
                            child: Text("确定"),
                            onPressed: () async {
//                    确认 赋值并回退
                              if (name.trim().length <= 0) {
                                Toast.show("企业名称不能为空");
                                return;
                              }
                              if (selected) {
                                status = "1";
                              } else if (!selected) {
                                status = "0";
                              }

                              await editAuthGroup(
                                agName: name.toString(),
                                agStatus: status.toString(),
                                agid: obj["agid"].toString(),
                                createTime: obj["createTime"].toString(),
                                enterprise: obj["enterprise"].toString(),
                                enterpriseName:
                                    obj["enterpriseName"].toString(),
                                project: obj["project"].toString(),
                                updateTime: obj["updateTime"].toString(),
                                updateUser: obj["updateUser"].toString(),
                              );
                              Toast.show("编辑成功");
                              _onRefresh();
                              Navigator.of(context).pop();
                            },
                          ),
                          RaisedButton(
                            child: Text("取消"),
                            onPressed: () {
                              // 取消回退
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ],
                  ));
            }),
          );
        });
  }

  getAuth() async {
    auth["添加"] = await getPermission("erpPhone_AuthGroupController_editAuthGroup");
    auth["编辑权限"] = await getPermission("erpPhone_AuthGroupController_saveAuthValue");
    auth["编辑"] = await getPermission("erpPhone_AuthGroupController_editAuthGroup");
  }
}
