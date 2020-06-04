import 'package:flutter/material.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 选择邀请码状态
class SelectinvitationcodePage extends StatefulWidget {
  @override
  SelectinvitationcodePageState createState() => SelectinvitationcodePageState();
}

class SelectinvitationcodePageState extends State<SelectinvitationcodePage> {
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
              title: Text("未使用"),
              onTap: () {
                setState(() {
                  selectEpp={
                    'name':'未使用',
                    'code':'0'
                  };
                  Navigator.pop(context, selectEpp);
                });
              }),
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                  title: Text("已使用"),
                  onTap: () {
                    setState(() {
                      selectEpp={
                        'name':'已使用',
                        'code':'1'
                      };
                      Navigator.pop(context, selectEpp);
                    });
                  }),
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                  title: Text("作废"),
                  onTap: () {
                    setState(() {
                      selectEpp={
                        'name':'作废',
                        'code':'2'
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
