import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spterp/component/toast.dart';

class SelectJurisdictionPage extends StatefulWidget {
  SelectJurisdictionPage(this.uid, {this.uAid});

  final uid;
  final uAid;

  @override
  SelectJurisdictionPageState createState() => SelectJurisdictionPageState();
}

class SelectJurisdictionPageState extends State<SelectJurisdictionPage> {
  List<Map<String, dynamic>> dataList = [];
  Map<String, dynamic> pageMap = {};
  String floorName = "";

  TextEditingController textEditingController = new TextEditingController();
  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    getBuildingNumber();
    _loadDate();
    getAuthGroupDropDown();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置用户权限组"),
        actions: <Widget>[],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        header: WaterDropHeader(),
        footer: getFooter(),
        onRefresh: _onRefresh,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: dataList
              .map((builderDropDown) => _itemBuild(builderDropDown))
              .toList(),
        ),
      ),
    );
  }

  Widget _itemBuild(floorDropDown) {
    return Container(
      child: ListTile(
        title: Text(floorDropDown['agName']),
        onTap: () async {
          Map<String, dynamic> addObj; // 要添加的内容(或者修改的内容)
          if (widget.uAid == null) {
            addObj = {
              'arr': [
                {
                  'uid': widget.uid,
                  'eid': await getEnterpriseId(),
                  'authGroup': floorDropDown['agid'],
                  'agid': floorDropDown['agid']
                }
              ],
              'uid': widget.uid,
            };
            await setUserAuth(obj: addObj);

            Toast.show("添加成功");
            Navigator.pop(context);
          } else if (widget.uAid != null) {
            addObj = {
              'arr': [
                {
                  'uid': widget.uid,
                  'uaid': widget.uAid,
                  'eid': await getEnterpriseId(),
                  'authGroup': floorDropDown['agid'],
                  'agid': floorDropDown['agid']
                }
              ],
              'uid': widget.uid,
            };
            await setUserAuth(obj: addObj);

            Toast.show("编辑成功");
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  _loadDate() async {
    List<dynamic> result = await getAuthGroupDropDown();
    setState(() {
      for (Map<String, dynamic> item in result) {
        dataList.add(item);
      }
      result.remove("arr");
    });
  }

  Future _onRefresh() async {
    setState(() {
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
}
