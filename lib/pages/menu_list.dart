import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:flutter_spterp/component/toast.dart';

class MenuListDemo extends StatefulWidget {
  MenuListDemo(this.agId);

  final String agId;

  RightsMenuPage createState() =>
      RightsMenuPage();
}

class RightsMenuPage extends State<MenuListDemo> {
  Map menuDate = {};
  Map sendObjDate = {}; // 发送的数据
  Map layer = {};

  List<dynamic> authList = []; // 保存权限
  List<dynamic> allData = [];
  List saveAuthList = [];
  List menuArr = []; // n层置为1层数组

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    await _loadDate();
    checkBoxInitFistTime();
    downgrade(menuDate); // n层置为1层操作
    getChangeObj();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('编辑权限')),
      body: loading(
          isLoading,
          allData.length > 0
              ? ListView(children: createTwoLayer(menuDate["children"]))
              : Container()),
      bottomNavigationBar: Container(
          padding: EdgeInsets.only(right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                color: Colors.blue,
                child: Text(
                  "保存",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  setState(() {
                    isLoading = false;
                  });
                  saveAuth();
                  if (saveAuthList.length > 0) {
                    saveAuthList.add(menuDate["funcName"]);
                  }
                  await saveAuthValue(
                    saveAuthList.join("|"),
                    widget.agId.toString(),
                  );
                  setState(() {
                    isLoading = true;
                  });
                  Toast.show("保存成功");
                  Navigator.pop(context);
                  saveAuthList = []; //防止报错
                },
              ),
            ],
          ),
          height: 50),
    );
  }

  List createTwoLayer(List value) {
    List<Widget> cardList = [];
    for (int i = 0; i < menuDate["children"].length; i++) {
      layer[menuDate["children"][i]["id"]]["selectde"] =
          menuDate["children"][i]["selected"];
      cardList.add(Card(
        child: Container(
          child: Column(
            children: <Widget>[
              CheckboxListTile(
                onChanged: (val) {
                  setState(() {
                    menuDate["children"][i]["selected"] = val;
                  });
                  layer[menuDate["children"][i]["id"]]["selected"] =
                      !layer[menuDate["children"][i]["id"]]["selected"];
                  influenceChild(menuDate["children"][i]["id"]);
                  influenceFather(menuDate["children"][i]["id"]);
                },
                title: Stack(
                  children: <Widget>[
                    Text(menuDate["children"][i]["label"],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                value: menuDate["children"][i]["selected"],
                controlAffinity: ListTileControlAffinity.leading,
              ),
              Column(
                children: <Widget>[
                  Column(
                    children: createThreeLayer(i, menuDate["children"][i]["selected"]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
    }
    return cardList;
  }
  List createThreeLayer(int value, bool status) {
    List<Widget> columnList = [];
    for (int j = 0; j < menuDate["children"][value]["children"].length; j++) {
      layer[menuDate["children"][value]["children"][j]["id"]]["selectde"] =
          menuDate["children"][value]["children"][j]["selected"];
      columnList.add(Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: CheckboxListTile(
              onChanged: (val) {
                setState(() {
                  menuDate["children"][value]["children"][j]["selected"] = val;
                  if (menuDate["children"][value]["children"][j]["selected"] ==
                      false) {}
                });
                layer[menuDate["children"][value]["children"][j]["id"]]
                        ["selected"] =
                    !layer[menuDate["children"][value]["children"][j]["id"]]
                        ["selected"];

                influenceChild(
                    menuDate["children"][value]["children"][j]["id"]);
                influenceFather(
                    menuDate["children"][value]["children"][j]["id"]);
              },
              title: Stack(
                children: <Widget>[
                  Text(menuDate["children"][value]["children"][j]["label"],
                      style: TextStyle(fontSize: 18)),
                ],
              ),
              value: menuDate["children"][value]["children"][j]["selected"],
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          Column(
            children: createFourLayer(value, j),
          ),
        ],
      ));
    }
    return columnList;
  }
  List createFourLayer(int value, int j) {
    List<Widget> accordionList = [];
    for (int i = 0;
        i < menuDate["children"][value]["children"][j]["children"].length;
        i++) {
      layer[menuDate["children"][value]["children"][j]["children"][i]["id"]]
              ["selected"] =
          menuDate["children"][value]["children"][j]["children"][i]["selected"];
      accordionList.add(
        SingleChildScrollView(
            child: ExpansionTile(
          title: Container(
            child: CheckboxListTile(
              onChanged: (val) {
                setState(() {
                  menuDate["children"][value]["children"][j]["children"][i]
                      ["selected"] = val;
                });
                layer[menuDate["children"][value]["children"][j]["children"][i]
                        ["id"]]["selected"] =
                    !layer[menuDate["children"][value]["children"][j]
                        ["children"][i]["id"]]["selected"];
                influenceChild(menuDate["children"][value]["children"][j]
                    ["children"][i]["id"]);
                influenceFather(menuDate["children"][value]["children"][j]
                    ["children"][i]["id"]);
              },
              title: Stack(
                children: <Widget>[
                  Text(menuDate["children"][value]["children"][j]["children"][i]
                      ["label"]),
                ],
              ),
              value: menuDate["children"][value]["children"][j]["children"][i]
                  ["selected"],
              controlAffinity: ListTileControlAffinity.leading,
            ),
            margin: EdgeInsets.only(left: 10),
          ),
          children: createFiveLayer(value, j, i),
        )),
      );
    }
    return accordionList;
  }
  List createFiveLayer(int value, int j, int i) {
    List<Widget> item = [];
    for (int k = 0;
        k <
            menuDate["children"][value]["children"][j]["children"][i]
                    ["children"]
                .length;
        k++) {
      layer[menuDate["children"][value]["children"][j]["children"][i]
              ["children"][k]["id"]]["selected"] =
          menuDate["children"][value]["children"][j]["children"][i]["children"]
              [k]["selectde"];
      item.add(ListTile(
        title: Container(
            child: CheckboxListTile(
              onChanged: (val) {

                setState(() {
                  menuDate["children"][value]["children"][j]["children"][i]
                      ["children"][k]["selectde"] = val;
                });
                layer[menuDate["children"][value]["children"][j]["children"][i]
                        ["children"][k]["id"]]["selected"] =
                    !layer[menuDate["children"][value]["children"][j]
                        ["children"][i]["children"][k]["id"]]["selected"];
                influenceChild(menuDate["children"][value]["children"][j]
                    ["children"][i]["children"][k]["id"]);
                influenceFather(menuDate["children"][value]["children"][j]
                    ["children"][i]["children"][k]["id"]);
              },
              title: Stack(
                children: <Widget>[
                  Text(menuDate["children"][value]["children"][j]["children"][i]
                      ["children"][k]["label"]),
                ],
              ),
              value: menuDate["children"][value]["children"][j]["children"][i]
                  ["children"][k]["selectde"],
              controlAffinity: ListTileControlAffinity.leading,
            ),
            margin: EdgeInsets.only(left: 30)),
      ));
    }
    return item;
  }

  Future _loadDate() async {
    setState(() {
      isLoading = true;
    });
    List<dynamic> result = await getMenuListByProject();
    List<dynamic> resultAuthList = await openAuth(groupId: widget.agId);
    setState(() {
      authList = resultAuthList;
    });
    if (result.length > 0) {
      setState(() {
        menuDate = result[0];
        allData = result;
        isLoading = false;
      });
    }
  }
  checkBoxInit() {
    for (int i = 0; i < menuDate["children"].length; i++) {
      if (menuDate["children"][i]["id"] != null) {
        menuDate["children"][i]["selected"] =
            initAuth(menuDate["children"][i]["id"]);
      }
      for (int j = 0; j < menuDate["children"][i]["children"].length; j++) {
        if (menuDate["children"][i]["children"][j]["id"] != null) {
          menuDate["children"][i]["children"][j]["selected"] =
              initAuth(menuDate["children"][i]["children"][j]["id"]);
        }
        for (int k = 0;
            k < menuDate["children"][i]["children"][j]["children"].length;
            k++) {
          if (menuDate["children"][i]["children"][j]["children"][k]["id"] !=
              null) {
            menuDate["children"][i]["children"][j]["children"][k]["selected"] =
                initAuth(menuDate["children"][i]["children"][j]["children"]
                    [k]["id"]);
          }
          for (int h = 0;
              h <
                  menuDate["children"][i]["children"][j]["children"][k]
                          ["children"]
                      .length;
              h++) {
            if (menuDate["children"][i]["children"][j]["children"][k]
                    ["children"][h]["id"] !=
                null) {
              menuDate["children"][i]["children"][j]["children"][k]["children"]
                      [h]["selectde"] =
                  initAuth(menuDate["children"][i]["children"][j]["children"]
                      [k]["children"][h]["id"]);
            }
          }
        }
      }
    }
  }
  checkBoxInitFistTime() {
    for (int i = 0; i < menuDate["children"].length; i++) {
      if (menuDate["children"][i]["id"] != null) {
        menuDate["children"][i]["selected"] =
            initAuthFirstTime(menuDate["children"][i]["funcName"]);
      }
      for (int j = 0; j < menuDate["children"][i]["children"].length; j++) {
        if (menuDate["children"][i]["children"][j]["id"] != null) {
          menuDate["children"][i]["children"][j]["selected"] =
              initAuthFirstTime(menuDate["children"][i]["children"][j]["funcName"]);
        }
        for (int k = 0;
        k < menuDate["children"][i]["children"][j]["children"].length;
        k++) {
          if (menuDate["children"][i]["children"][j]["children"][k]["id"] !=
              null) {
            menuDate["children"][i]["children"][j]["children"][k]["selected"] =
                initAuthFirstTime(menuDate["children"][i]["children"][j]["children"]
                [k]["funcName"]);
          }
          for (int h = 0;
          h <
              menuDate["children"][i]["children"][j]["children"][k]
              ["children"]
                  .length;
          h++) {
            if (menuDate["children"][i]["children"][j]["children"][k]
            ["children"][h]["id"] !=
                null) {
              menuDate["children"][i]["children"][j]["children"][k]["children"]
              [h]["selectde"] =
                  initAuthFirstTime(menuDate["children"][i]["children"][j]["children"]
                  [k]["children"][h]["funcName"]);
            }
          }
        }
      }
    }
  }

  downgrade(Map obj) {
    menuArr.add({
      "fid": obj["fid"],
      "id": obj["id"],
      "label": obj["fid"],
      "level": obj["level"],
      "funcName":obj["funcName"],
      "selected": obj["selected"],
    });
    if (obj['children'].length > 0) {
      for (int i = 0; i < obj['children'].length; i++) {
        downgrade(obj['children'][i]);
      }
    }
  }
  influenceChild(int id) {
    List childArr = [];
    layer.forEach((index, value) {
      if (value["fid"] == id) {
        childArr.add(value["id"]);
      }
    });
    for (int i = 0; i < childArr.length; i++) {
      if (layer[id]["selected"]) {
        layer[childArr[i]]["selected"] = true;
        influenceChild(layer[childArr[i]]["id"]);
      } else if (!layer[id]["selected"]) {
        layer[childArr[i]]["selected"] = false;
        influenceChild(layer[childArr[i]]["id"]);
      }
    }
    authList = [];
    layer.forEach((index, value) {
      if (value["selected"]) {
        authList.add(value["id"]);
      }
    });
    checkBoxInit();
  }
  influenceFather(int id) {
    List fatherArr = [];
    layer.forEach((index, value) {
      if (layer[id]["fid"] == value["fid"]) {
        fatherArr.add(value["id"]);
      }
    });
    int statusDate = 0;
    for (int j = 0; j < fatherArr.length; j++) {
      if (layer[fatherArr[j]]["selected"]) {
        statusDate++;
      } else if (!layer[fatherArr[j]]["selected"]) {
        statusDate--;
      }
    }
    if (statusDate == -fatherArr.length && layer[layer[id]["fid"]] != null) {
      layer[layer[id]["fid"]]["selected"] = false;
      if (layer[layer[id]["fid"]] != null && layer[layer[id]["fid"]] != null) {
        influenceFather(layer[id]["fid"]);
      }
    } else if (statusDate > -fatherArr.length &&
        statusDate != fatherArr.length &&
        layer[layer[id]["fid"]] != null) {
      layer[layer[id]["fid"]]["selected"] = true;
      if (layer[layer[id]["fid"]] != null) {
        influenceFather(layer[id]["fid"]);
      }
    } else if (statusDate == fatherArr.length &&
        layer[layer[id]["fid"]] != null) {
      layer[layer[id]["fid"]]["selected"] = true;
      if (layer[layer[id]["fid"]] != null) {
        influenceFather(layer[id]["fid"]);
      }
    }
    authList = [];
    layer.forEach((index, value) {
      if (value["selected"]) {
        authList.add(value["id"]);
      }
    });
    checkBoxInit();
  }

  getChangeObj() {
    for (int i = 1; i < menuArr.length; i++) {
      layer[menuArr[i]["id"]] = menuArr[i];
    }
  }

  saveAuth() {
    for (int i = 0; i < menuDate["children"].length; i++) {
      if (menuDate["children"][i]["selected"]) {
        saveAuthList.add(menuDate["children"][i]["funcName"].trim());
      }
      for (int j = 0; j < menuDate["children"][i]["children"].length; j++) {
        if (menuDate["children"][i]["children"][j]["selected"]) {
          saveAuthList.add(menuDate["children"][i]["children"][j]["funcName"].trim());
        }
        for (int k = 0;
            k < menuDate["children"][i]["children"][j]["children"].length;
            k++) {
          if (menuDate["children"][i]["children"][j]["children"][k]
              ["selected"]) {
            saveAuthList.add(
                menuDate["children"][i]["children"][j]["children"][k]["funcName"].trim());
          }
          for (int h = 0;
              h <
                  menuDate["children"][i]["children"][j]["children"][k]
                          ["children"]
                      .length;
              h++) {
            if (menuDate["children"][i]["children"][j]["children"][k]
                ["children"][h]["selectde"]) {
              saveAuthList.add(menuDate["children"][i]["children"][j]
                  ["children"][k]["children"][h]["funcName"].trim());
            }
          }
        }
      }
    }
  }

  initAuth(int atuhId) {
    for (int i = 0; i < authList.length; i++) {
      if (atuhId == authList[i]) {
        return true;
      }
    }
    return false;
  }
  initAuthFirstTime(String atuhId) {
    for (int i = 0; i < authList.length; i++) {
      if (atuhId == authList[i]) {
        return true;
      }
    }
    return false;
  }
}
