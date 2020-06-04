import 'package:flutter/material.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 选择审核状态
class SelectRequestStatusCodePage extends StatefulWidget {
  @override
  SelectRequestStatusCodePageState createState() => SelectRequestStatusCodePageState();
}

class SelectRequestStatusCodePageState extends State<SelectRequestStatusCodePage> {
  RefreshController _refreshController;



  // 数据列表
  List<Map<String, dynamic>> dataList = [];



  // 查询条件
  String eppName = ""; // 工程名称
  String name ="";

  // 被选中的工程对象
  Map<String, dynamic> selectEpp = {};

  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("审核状态"),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: getFooter(),
        controller: _refreshController,
        child: ListView(
          children:[
          Container(
          color: Colors.white,
          child: ListTile(
              title: Text("申请批准"),
              onTap: () {
                setState(() {
                  selectEpp={
                    'name':'申请批准',
                    'code':'2'
                  };
                  Navigator.pop(context, selectEpp);
                });
              }),
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                  title: Text("申请禁止"),
                  onTap: () {
                    setState(() {
                      selectEpp={
                        'name':'申请禁止',
                        'code':'8'
                      };
                      Navigator.pop(context, selectEpp);
                    });
                  }),
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                  title: Text("申请作废"),
                  onTap: () {
                    setState(() {
                      selectEpp={
                        'name':'申请作废',
                        'code':'9'
                      };
                      Navigator.pop(context, selectEpp);
                    });
                  }),
            )
          ]
        ),
      ),
    );
  }


  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

}
