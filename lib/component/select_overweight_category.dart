import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 楼号选择
class SelectOverWeightPage extends StatefulWidget {
  @override
  SelectOverWeightPageState createState() => SelectOverWeightPageState();
}

class SelectOverWeightPageState extends State<SelectOverWeightPage> {
  List<Map<String, dynamic>> dataList = [];
  Map<String, dynamic> pageMap = {};
  String floorName = "";

  TextEditingController textEditingController = new TextEditingController();
  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _loadDate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("请选择过磅类别"),
      ),
      body: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        controller: _refreshController,
        header: WaterDropHeader(),
        footer: getFooter(),
        onRefresh: () => {},
        onLoading: () => {},
        child: ListView(
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
        title: Text(floorDropDown['name']),
//        subtitle: Text(floorDropDown['code']),
        onTap: () {
          Navigator.pop(context, floorDropDown);
        },
      ),
    );
  }

  _loadDate() async {
    List<dynamic> result = await getweightType();
    setState(() {
      for (Map<String, dynamic> item in result) {
        dataList.add(item);
      }
    });
  }
}
