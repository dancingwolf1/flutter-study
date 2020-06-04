import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/select_builder.dart';
import 'package:flutter_spterp/component/select_dropdown.dart';
import 'package:flutter_spterp/component/select_epp.dart';
import 'package:flutter_spterp/component/select_salesman.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:flutter_spterp/component/appbar.dart';
import 'package:flutter_spterp/component/input.dart';
import 'package:flutter_spterp/util/public_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库


class ContractAddPage extends StatefulWidget {
  @override
  ContractAddPageState createState() => ContractAddPageState();
}

class ContractAddPageState extends State<ContractAddPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _selectContractCodeController;
  TextEditingController _selectedEppController; // 选中后的工程名称输入框控制器
  TextEditingController _selectedBuilderController; // 选中后的施工单位输入框控制器
  TextEditingController _selectedSalesmanController; // 选中后的业务员输入框控制器
  TextEditingController _selectedContractTypeController; // 选中后的合同类型输入框控制器
  TextEditingController _selectedPriceTypeController; // 选中后的价格执行方式输入框控制器
  TextEditingController _selectedSignTimeController;
  TextEditingController _selectedEndTimeController;
  TextEditingController _contractQuantity; //合同方量
  TextEditingController _estimatedQuantity; //预计方量
  TextEditingController _prepaymentAmount; // 预付金额
  TextEditingController _remarks; //备注
  GlobalKey _formKey = GlobalKey<FormState>();

  Map<String, dynamic> selectedEpp = {};
  Map<String, dynamic> selectBuilder = {};
  Map<String, dynamic> selectSalesman = {};
  Map<String, dynamic> selectContractType = {}; // 选中的合同类型
  Map<String, dynamic> selectPriceType = {}; // 选中的价格执行方式类型

  String contractCode = "";
  List priceTypeDropDown = [];
  List contractTypeDropDown = [];

  double contractNum = 0;
  double preNum = 0;

  // 预付金额
  double preMoney = 0;

  int _endTime = DateTime.now().millisecondsSinceEpoch;

  int _signTime = DateTime.now().millisecondsSinceEpoch;

  String remark;

  // 点击按钮开始加载中
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    _contractQuantity = new TextEditingController();
    _selectContractCodeController = new TextEditingController();
    _selectedEppController = new TextEditingController();
    _selectedBuilderController = new TextEditingController();
    _selectedSalesmanController = new TextEditingController();
    _selectedContractTypeController = new TextEditingController();
    _selectedPriceTypeController = new TextEditingController();
    _selectedSignTimeController = new TextEditingController();
    _selectedEndTimeController = new TextEditingController();
    _prepaymentAmount = new TextEditingController();
    _estimatedQuantity = new TextEditingController();
    _prepaymentAmount = new TextEditingController();
    _remarks = new TextEditingController();
    _selectedSignTimeController.text =
        DateTime.fromMillisecondsSinceEpoch(_signTime, isUtc: false)
            .toString()
            .substring(0, 10);
    _selectedEndTimeController.text =
        DateTime.fromMillisecondsSinceEpoch(_endTime, isUtc: false)
            .toString()
            .substring(0, 10);
    // 合同编号初始化
    initContractId();

    _getPriceTypeDropDown();

    _getContractTypeDropDown();
  }

  initContractId() async {
    String result = await makeAutoContractId();
    if (result != "" && result != null) {
      setState(() {
        _selectContractCodeController.text = result;
        contractCode = result;
      });
    }
  }

  _getPriceTypeDropDown() async {
    List dropDown = await getPriceTypeDropDown();
    setState(() {
      priceTypeDropDown = dropDown;
    });
  }

  _getContractTypeDropDown() async {
    List dropDown = await getContractTypeDropDown();
    setState(() {
      contractTypeDropDown = dropDown;
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: getAppBar(context, "添加简易合同", isRightButton: false),
        body: loading(
            false,
            Form(
              key: _formKey,
              autovalidate: true,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: ScreenUtil().setWidth(20),
                  ),
//                  Container(
//                    color: Colors.grey,
//                    height: ScreenUtil().setWidth(20),
//                    width: MediaQuery.of(context).size.width,
//                  ),
                  Container(
                    color: Colors.white,
                    height: ScreenUtil().setWidth(208),
                    width: MediaQuery.of(context).size.width,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(
                          right: ScreenUtil().setWidth(24),
                          left: ScreenUtil().setWidth(24),
                          top: ScreenUtil().setWidth(20),
                          bottom: ScreenUtil().setWidth(20)),
                      width: ScreenUtil().setWidth(256),
                      height: ScreenUtil().setWidth(96),
                      decoration: BoxDecoration(
                        color: usePublicColor(1),
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(8)),
                      ),
                      child: Center(
                          child: Text("解析",
                              style: TextStyle(color: Colors.white))),
                    ),
                  ),
                  inputWrite("合同编号",(value) {
                    setState(() {
                      contractCode = value;
                    });
                  },inputControl:_selectContractCodeController,mustFile: true),
                  inputSelect(_selectedEppController,"工程名称",() async {
                    Map<String, dynamic> result = await Navigator.push(
                        context,
                        new CupertinoPageRoute(
                            builder: (context) => SelectEppPage()));
                    if (result == null) {
                      return;
                    }
                    setState(() {
                      selectedEpp = result;
                      _selectedEppController.text =
                          selectedEpp['eppName'].toString();
                    });
                  }),
                  inputSelect(_selectedBuilderController,"施工单位",() async {
                    Map<String, dynamic> _selectBuilder = await Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => SelectBuilderPage()));
                    if (_selectBuilder == null) {
                      return;
                    }
                    setState(() {
                      selectBuilder = _selectBuilder;
                      _selectedBuilderController.text =
                          selectBuilder['builderName'].toString();
                    });
                  }),
                  inputSelect(_selectedEppController,"工程名称", () async {
                    Map<String, dynamic> result = await Navigator.push(
                        context,
                        new CupertinoPageRoute(
                            builder: (context) => SelectEppPage()));
                    if (result == null) {
                      return;
                    }
                    setState(() {
                      selectedEpp = result;
                      _selectedEppController.text =
                          selectedEpp['eppName'].toString();
                    });
                  }),

                  inputSelect(_selectedSalesmanController,"业务员", () async {
                    Map<String, dynamic> _selectSalesman = await Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => SelectSalesmanPage()));
                    if (_selectSalesman == null) {
                      return;
                    }
                    setState(() {
                      selectSalesman = _selectSalesman;
                      _selectedSalesmanController.text =
                          selectSalesman['salesManName'].toString();
                    });
                  }),
                  inputSelect(_selectedContractTypeController,"合同类型",() async {
                    Map<String, dynamic> selected = await Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => SelectDropDownPage(
                              type: 46,
                            )));
                    if (selected == null) {
                      return;
                    }
                    setState(() {
                      selectContractType = selected;
                    });
                    _selectedContractTypeController.text =
                    selected['name'];
                  }),
                  inputSelect(_selectedPriceTypeController,"价格执行方式", () async {
                    Map<String, dynamic> selected = await Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => SelectDropDownPage(
                              type: 47,
                            )));
                    if (selected == null) {
                      return;
                    }
                    setState(() {
                      selectPriceType = selected;
                    });
                    _selectedPriceTypeController.text = selected['name'];
                  }),
                  inputSelect(_selectedSignTimeController,"签订时间",() async {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        onChanged: (date) {}, onConfirm: (date) {
                          setState(() {
                            _signTime = date.millisecondsSinceEpoch;
                            _selectedSignTimeController.text =
                                DateTime.fromMillisecondsSinceEpoch(_signTime,
                                    isUtc: false)
                                    .toString()
                                    .substring(0, 10);
                          });
                        },
                        currentTime: DateTime.fromMillisecondsSinceEpoch(
                            _signTime,
                            isUtc: false),
                        locale: LocaleType.zh);
                  }),

                  inputSelect(_selectedEndTimeController,"到期时间",() async {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        onChanged: (date) {}, onConfirm: (date) {
                          setState(() {
                            _endTime = date.millisecondsSinceEpoch;
                            _selectedEndTimeController.text =
                                DateTime.fromMillisecondsSinceEpoch(_endTime,
                                    isUtc: false)
                                    .toString()
                                    .substring(0, 10);
                          });
                        },
                        currentTime: DateTime.fromMillisecondsSinceEpoch(
                            _signTime,
                            isUtc: false),
                        locale: LocaleType.zh);
                  }),

                  inputWrite("合同方量",(val) {
                        setState(() {
//                        _prepaymentAmount.text = val;
                          contractNum = double.parse(val == "" ? "0.0" : val);
                        });
                      }),
                  inputWrite("预计方量",(val) {
                    setState(() {
//                        _prepaymentAmount.text = val;
                      preMoney = double.parse(val);
                    });
                  },inputControl: _estimatedQuantity),
                  inputWrite("预付金额",(val) {
                    setState(() {
//                        _prepaymentAmount.text = val;
                      preMoney = double.parse(val);
                    });
                  },inputControl: _prepaymentAmount),
                 Container(child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                     Container(

                       child:  Padding(
                         padding: EdgeInsets.only(top: ScreenUtil().setWidth(10),bottom: ScreenUtil().setWidth(10),left: ScreenUtil().setWidth(22)),
                         child: Text("备注",style: TextStyle(
                             fontSize: ScreenUtil().setSp(28),
                             color: usePublicColor(2),
                             fontWeight: FontWeight.w500),textAlign: TextAlign.right,),
                       ),
                     ),

                     Container(

                       padding: EdgeInsets.only(left: ScreenUtil().setWidth(22),right:ScreenUtil().setWidth(22),bottom: ScreenUtil().setWidth(24)),
                       decoration: BoxDecoration(
                         color: Colors.white,
                         border: Border(
                             bottom:
                             BorderSide(width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.41))),
                       ),
                       child:  TextField(
                         maxLength: 140,
                         decoration: InputDecoration(
                             border: InputBorder.none,
                             hintText: "请输入不少于10个字的文字描述信息",
                             hintStyle:TextStyle(
                                 fontSize: ScreenUtil().setSp(28),
                                 color: Color.fromRGBO(201, 199, 210, 1))
                         ),
                         controller: _remarks,
                         keyboardType: TextInputType.text,
                         textInputAction: TextInputAction.send,
                         maxLines: 3,
                         onChanged: (val) {
                           setState(() {
                             remark = val;
                           });
                         },
                       ),

                     ),

                   ],
                 ), color: Colors.white,),

                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(
                          right: ScreenUtil().setWidth(24),
                          left: ScreenUtil().setWidth(24),
                          top: ScreenUtil().setWidth(52),
                          bottom: ScreenUtil().setWidth(52)),
                      height: ScreenUtil().setWidth(96),
                      decoration: BoxDecoration(
                        color: usePublicColor(1),
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(8)),
                      ),
                      child: Center(
                          child: Text(
                        "完成",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    onTap: () {
                      _submitAddContract();
                    },
                  ),
                ],
              ),
            )));
  }

  ///选择输入框
  /// [control]输入抗控制器
  /// [title]输入框标题
  /// [hintText]输入框提示信息
  /// [select] 点击选择执行事件
  /// [isFill] 控制是否是必填选项
  Widget selectInputBox(
      TextEditingController control, // 选择输入框控制器
      String title,
      String hintText,
      Function onTop,
      Function selectTop,
      {bool suffixIcon = true,
       bool isFill = true,
      }) {
    return Container(
      padding: EdgeInsets.only(
          right: ScreenUtil().setWidth(20), left: ScreenUtil().setWidth(20)),
      child: TextField(
        maxLines: 1,
        controller: control,
        enableInteractiveSelection: false,
        onTap: onTop,
        onChanged: selectTop,
        decoration: InputDecoration(
            border: InputBorder.none,
            icon: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "$title",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          color: usePublicColor(2),
                          fontWeight: FontWeight.w500)),
                  TextSpan(
                    text: "${isFill?'*':' '}",
                    style: TextStyle(color: Color.fromRGBO(240, 48, 93, 1)
                    ),
                  ),
                ],
              ),
            ),
            hintStyle: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                color: Color.fromRGBO(201, 199, 210, 1)),
            hintText: "$hintText",
            suffixIcon: suffixIcon
                ? Icon(Icons.chevron_right,
                    color: Color.fromRGBO(201, 199, 210, 1), size: 32)
                : SizedBox()),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
//      border:Border.all(width: 1,color: Color.fromRGBO(0, 0, 0, 0.41)),
        border: Border(
            bottom:
                BorderSide(width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.41))),
      ),
    );
  }

  Future _submitAddContract() async {
    String contractId = "";
    String salesman = "";
    String signDate = "";
    String effectDate = ""; // 到期日期
    int contractType = 0;
    int priceStyle = 0;
    String eppCode = "";
    String builderCode = "";
//    double contractNum = 0.0;
//    double preNum = 0.0;
    double preMoney = 0.0;
    String remarks = "";
    contractId = contractCode;
    salesman = selectSalesman['salesCode'];
    signDate =
        DateTime.fromMillisecondsSinceEpoch(_signTime, isUtc: false).toString();
    effectDate =
        DateTime.fromMillisecondsSinceEpoch(_endTime, isUtc: false).toString();
    contractType = selectContractType['code'] == null
        ? 500
        : int.parse(selectContractType['code']);

    priceStyle = selectPriceType['code'] == null
        ? 500
        : int.parse(selectPriceType['code']);
    eppCode = selectedEpp['eppCode'] == null
        ? "0"
        : selectedEpp['eppCode'].toString();

    builderCode = selectBuilder['builderCode'] == null
        ? "0"
        : selectBuilder['builderCode'].toString();
//    contractNum = contractNum;
//    preNum = preNum;
    preMoney = preMoney;
    remarks = remark;
    if (contractNum >= 1000000000000000000) {
      Toast.show("合同方量过大请重新录入");
      return;
    }
    if (contractCode.length > 15) {
      Toast.show("合同编号长度大于15");
      return;
    }
    if (contractId == null || contractId == "") {
      Toast.show("请输入合同编号");
      return;
    }
    if (eppCode == null || eppCode == "0") {
      Toast.show("请选择工程名称");
      return;
    }
    if (builderCode == null || builderCode == "0") {
      Toast.show("请选择施工单位");
      return;
    }
    if (salesman == null) {
      Toast.show("请选择业务员");
      return;
    }
    if (contractType == null || contractType == 500) {
      Toast.show("请选择合同类型");
      return;
    }
    if (priceStyle == null || priceStyle == 500) {
      Toast.show("请选择价格执行方式");
      return;
    }

    if (signDate == null || signDate == "") {
      Toast.show("请选择签订时间");
      return;
    }
    if (effectDate == null || effectDate == "") {
      Toast.show("请选择执行时间");
      return;
    }
    if (remarks != null) {
      if (remark.length < 10) {
        Toast.show("备注文字过少");
        return;
      }
      if (remark.length > 250) {
        Toast.show("备注字数过多");
        return;
      }
    }

//    console.log("");
    await addContract(
        contractId,
        salesman,
        DateTime.parse(signDate).millisecondsSinceEpoch,
        DateTime.parse(effectDate).millisecondsSinceEpoch,
        contractType,
        priceStyle,
        eppCode,
        builderCode,
        contractNum,
        preNum,
        preMoney,
        remarks);
    setState(() {
      // 加载中.....
      isloading = false;
    });
    Toast.show("添加成功!");
    Navigator.pop(context);
  }
}
