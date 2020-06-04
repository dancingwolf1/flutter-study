import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:flutter_spterp/component/select_ pump_price.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:flutter_spterp/util/public_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
import 'package:flutter_spterp/component/appbar.dart';
import 'package:flutter_spterp/component/input.dart';


class ContractAddPumpPricePage extends StatefulWidget {
  ContractAddPumpPricePage(this.contractUid, this.contractDetailCode);

  final String contractUid;
  final String contractDetailCode;

  @override
  ContractAddPumpPricePageState createState() =>
      ContractAddPumpPricePageState();
}

class ContractAddPumpPricePageState extends State<ContractAddPumpPricePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  /// 真正的条件
  TextEditingController _selectedAutoController; //  泵车类别控制器
  Map<String, dynamic> selectAutoName = {}; // 泵车类别对象
  String price = ""; // 砼送价格
  String deskFee = ""; // 台班费
  bool _isLoading = false;
  bool isAllSelect = true; // 默认按钮为"全选"
  @override
  void initState() {
    super.initState();
    _selectedAutoController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "添加泵车价格", isRightButton: false),
      body: Form(
        autovalidate: true,
        child: loading(
            _isLoading,
            ListView(
              padding:EdgeInsets.only(top:8.0),
              children: <Widget>[
                inputSelect(_selectedAutoController,"泵车类别", () async {
                  Map<String, dynamic> _selectBuilder =
                  await Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              SelectPumpTruckPage()));
                  if (_selectBuilder == null) {
                    return;
                  }
                  setState(() {
//                  price = val;
                    selectAutoName = _selectBuilder;
                    _selectedAutoController.text =
                    selectAutoName['pumptypename'];
                  });
                },isFill:false),
                Container(
                    height: ScreenUtil().setWidth(96),
                    padding: EdgeInsets.only(
                        right: ScreenUtil().setWidth(24),
                        left: ScreenUtil().setWidth(24)
                    ),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Text(
                          "泵送价格",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: Color.fromRGBO(139, 137, 151, 1)),
                        ),

                        hintStyle:TextStyle(
                            fontSize: ScreenUtil().setSp(30),
                            color: Color.fromRGBO(201, 199, 210, 1)),
                        hintText: "请输入泵送价格",
                      ),
                      onChanged: (val) {
                        setState(() {
                          price = val;
                        }); // vehicle
                      },
                    ),
                    decoration: BoxDecoration(
                      color:Colors.white,
                      border: Border(
                          bottom: BorderSide(
                              width: 0.5,
                              color: Color.fromRGBO(201, 199, 210, 1))),
                    )),
                Container(
                    height: ScreenUtil().setWidth(96),
                    padding: EdgeInsets.only(
                        right: ScreenUtil().setWidth(24),
                        left: ScreenUtil().setWidth(24)
                    ),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Text(
                          "台班费",
                          style: TextStyle(

                              fontSize: ScreenUtil().setSp(30),
                              color: Color.fromRGBO(139, 137, 151, 1)),
                        ),

                        hintStyle:TextStyle(
                            fontSize: ScreenUtil().setSp(30),
                            color: Color.fromRGBO(201, 199, 210, 1)),
                        hintText: "请输入台班费",
                      ),
                      onChanged: (val) {
                        setState(() {
                          deskFee = val;
                        }); // vehicle
                      },
                    ),
                    decoration: BoxDecoration(
                      color:Colors.white,
                      border: Border(
                          bottom: BorderSide(
                              width: 0.5,
                              color: Color.fromRGBO(0, 0, 0, 0.16))),
                    )),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(top: 8.0,right: ScreenUtil().setWidth(24),left: ScreenUtil().setWidth(24)),
                    width: ScreenUtil().setWidth(222),
                    height: ScreenUtil().setWidth(96),
                    decoration: BoxDecoration(
                      color: usePublicColor(1),
                      borderRadius:
                      BorderRadius.circular(ScreenUtil().setWidth(8)),
                    ),
                    child: Center(
                        child: Text(
                          "添加",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  onTap: ()async {
                    setState(() {
                      _isLoading = true;
                    });
                    await _submitAddTask();
                    setState(() {
                      _isLoading = false;
                    });
                  },
                ),
              ],
            )),
      ),
    );
  }

  Future _submitAddTask() async {
    //TODO 验证输入的数据
    await insertPumpTruck(
      contractUID: widget.contractUid,
      contractCode: widget.contractDetailCode,
      pumpType: selectAutoName['pumptype'].toString(),
      pumPrice: price.toString(),
      tableExpense: deskFee.toString(),
    );

    Toast.show("添加成功");
    Navigator.pop(context);
  }
}
