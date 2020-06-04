import 'package:flutter/material.dart';
import 'package:flutter_spterp/pages/accessories_application_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// 控制本地的模块。
class QueryFunction with ChangeNotifier {
  bool _lockQuery = false; // 加载锁来控制是否要加载快捷方式。
  bool _lockAuth = false;

  List _localModule = [


    {
      "moduleName": "材料",
      "childs": [


        {
          "authValue": "erpPhone_PartsApi_getPartsList",
          "title": "仓库配件",
          "icon": FontAwesomeIcons.artstation,
          "router": AccessoriesListPage(),
          "image": 'images/index_22.png',
          "fastFunction": false,
          "isAuth": false,
          'link': '/accessories'
        },

      ]
    }
  ]; // 本地的模块控制器数组。

  // 控制权限与快捷方式。
  void controlAuth(List serverQ, List serverAuth) {
    serverQ = serverQ.map((value){
      return value.trim();
    }).toList();
    // 操作快捷方式。
    for (int j = 0; j < _localModule.length; j++) {
      for (int k = 0; k < _localModule[j]["childs"].length; k++) {
        if (serverQ.contains(_localModule[j]["childs"][k]["authValue"])) {

          _localModule[j]["childs"][k]["fastFunction"] = true;
        }else{
          _localModule[j]["childs"][k]["fastFunction"] = false;
        }
      }
    }
    // 操作权限。
    for (int j = 0; j < _localModule.length; j++) {
      for (int k = 0; k < _localModule[j]["childs"].length; k++) {
        if (serverAuth.contains(_localModule[j]["childs"][k]["authValue"])) {
          _localModule[j]["childs"][k]["isAuth"] = true;
        } else {
          _localModule[j]["childs"][k]["isAuth"] = false;
        }
      }
    }
//    notifyListeners();
  }


  //[auth]Value 传递过来的功能代号.
  //[type] type = 1;代表增加快捷方式.type = 0;代表删除快捷方式
  void reduceQ(String authValue,int type) {
    for (var i = 0; i < _localModule.length; ++i) {
      for (var j = 0; j < _localModule[i]["childs"].length; ++j) {
        if(authValue ==  _localModule[i]["childs"][j]["authValue"]){
          if(type == 1){
            _localModule[i]["childs"][j]["fastFunction"]= true;
          }else{
            _localModule[i]["childs"][j]["fastFunction"]= false;
          }
        }
      }
    }
//  不用通知其他使用数据的组件刷新.
//  notifyListeners();
  }

  // 增加快捷方式增加。
  void addQ() {}

  // 控制获得权限锁。
  void openAuth() {}

  // 控制获得快捷方式锁。
  void openQuery() {}

  // 得到模块数组。
  List  get getModule => _localModule;
  int _count = 0;

  incCount() {
    this._count++;
    notifyListeners(); // 更新状态
  }

  int get count => this._count;
}
