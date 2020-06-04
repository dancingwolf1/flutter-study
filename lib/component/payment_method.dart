import 'package:flutter/material.dart';
import 'package:flutter_spterp/component/footer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 选择收款方式
class   PaymentMethodPage extends StatefulWidget {
  @override
  PaymentMethodPageState createState() => PaymentMethodPageState();
}

class PaymentMethodPageState extends State<PaymentMethodPage> {
  RefreshController _refreshController;



  // 数据列表
  List<Map<String, dynamic>> dataList = [];



  // 查询条件
  String eppName = ""; // 收款方式
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
        title: Text("收款方式"),
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
              title: Text("微信"),
              onTap: () {
                setState(() {
                  selectEpp={
                    'name':'微信',
                    'code':1
                  };
                  Navigator.pop(context, selectEpp);
                });
              }),
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                  title: Text("支付宝"),
                  onTap: () {
                    setState(() {
                      selectEpp={
                        'name':'支付宝',
                        'code':2
                      };
                      Navigator.pop(context, selectEpp);
                    });
                  }),
            ),
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
