import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:flutter_spterp/component/loading.dart';
import '../../api.dart';
import 'package:flutter_spterp/util/public_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
import 'package:flutter_spterp/component/appbar.dart';

class ContractAddDistancePage extends StatefulWidget {
  ContractAddDistancePage(this.contractUid, this.contractDetailCode);

  final String contractUid;
  final String contractDetailCode;

  @override
  ContractAddDistancePageState createState() => ContractAddDistancePageState();
}

class ContractAddDistancePageState extends State<ContractAddDistancePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _selectedCompNameController; // 选中后的合同单号输入框控制器
  TextEditingController _selectedDistanceController; // 选中后的施工单位输入框控制器

  Map<String, dynamic> selectEppName = {}; // 工程名称
  Map<String, dynamic> selectedPouringMethod = {}; // 浇筑方式
  Map<String, dynamic> selectedGrade = {}; // 砼标号
  Map<String, dynamic> selectedCementVarieties = {}; // 水泥品种
  Map<String, dynamic> selectedStoneRequirements = {}; //石料要求

  String remarks = ""; // 备注
  double distance = 0; // 运输距离
  bool _isloading = false;

  @override
  void initState() {
    _selectedCompNameController = new TextEditingController();
    _selectedDistanceController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "添加运距", isRightButton: false),
      body: Form(
        autovalidate: true,
        child: loading(
            _isloading,
            ListView(
              children: <Widget>[
                SizedBox(height: ScreenUtil().setWidth(20)),
                Container(
                    padding: EdgeInsets.only(
                        right: ScreenUtil().setWidth(24),
                        left: ScreenUtil().setWidth(24)
                    ),
                  height: ScreenUtil().setWidth(96),
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Text(
                        "运输距离",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(30),
                            color: Color.fromRGBO(139, 137, 151, 1)),
                      ),
                      hintStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                          color: Color.fromRGBO(201, 199, 210, 1)),
                      hintText: "请输入运输距离",
                    ),
                    onChanged: (val) {
                      setState(() {
                        distance = double.parse(val);
                      }); // vehicle
                    },
                  ),
                  decoration: BoxDecoration(
                      color:Colors.white,
                      border: Border(
                          bottom: BorderSide(
                              width: 0.5,
                              color: Color.fromRGBO(0, 0, 0, 0.16))),
                    )
                ),
                Container(
                    padding: EdgeInsets.only(
                        right: ScreenUtil().setWidth(24),
                        left: ScreenUtil().setWidth(24)
                    ),
                    height: ScreenUtil().setWidth(96),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon:  Text(
                            "备注",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(30),
                                color: Color.fromRGBO(139, 137, 151, 1)),
                          ),
                          hintStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: Color.fromRGBO(201, 199, 210, 1)),
                          hintText: "请输入备注"),
                      onChanged: (val) {
                        setState(() {
                          remarks = val;
                        });
                      },
                    ),
                    decoration: BoxDecoration(
                      color:Colors.white,
                      border: Border(
                          bottom: BorderSide(
                              width: 0.5,
                              color: Color.fromRGBO(0, 0, 0, 0.16))),
                    )
                ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(top: 20.0,right: ScreenUtil().setWidth(24),left: ScreenUtil().setWidth(24)),
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
                      _isloading = true;
                    });
                    await _submitAddTask();
                    setState(() {
                      _isloading = false;
                    });
                  },
                )
              ],
            )),
      ),
    );
  }

  Future<String> _submitAddTask() async {

    String result = await saveContractDistance(
        remarks: remarks,
        distance: distance.toString(),
        contractUid: widget.contractUid,
        contractDetailCode: widget.contractDetailCode);

    setState(() {
      Toast.show("添加成功");
      Navigator.pop(context);
    });
  }
}
