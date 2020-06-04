import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/component/select_buyer.dart';
import 'package:flutter_spterp/component/select_department.dart';
import 'package:flutter_spterp/component/select_mnemonicCode.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/select_dropdown.dart';
import 'package:flutter_spterp/component/toast.dart';


class AccessoriesAddPage extends StatefulWidget {
  @override
  AccessoriesPageState createState() => AccessoriesPageState();
}

class AccessoriesPageState extends State<AccessoriesAddPage> {

  Map<String, dynamic> selectedRequestMode = {}; //选中的申请模式对象
    Map<String, dynamic> selectedDepartment = {}; //选中的申请部门对象
  // 申请人
  Map<String, dynamic> selectedBuyer = {}; //选中的申请人对象
  //助记码
  Map<String, dynamic> selectedMnemonicCode = {}; //选中的助记码对象
  // 配件名称
  String goodsName = "";
  // 配件规格
  String specification = "";
  //申请数量
  String num ="";
  //申请金额
  String amount ="";
  // 申请描述
  String requestDep = "";
  // 备注
  String remarks ="";
  TextEditingController _selectedRequestModeController;
  TextEditingController _selectedDepartmentController;
  TextEditingController _selectedBuyerController;
  TextEditingController _selectedGoodsNameController;
  TextEditingController _selectedSpecificationController;
  TextEditingController _selectedNumController;
  TextEditingController _selectedAmountController;
  TextEditingController _selectedRequestDepController;
  TextEditingController _selectedRemarksController;

  GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    _selectedRequestModeController = new TextEditingController();
    _selectedDepartmentController = new TextEditingController();
    _selectedBuyerController = new TextEditingController();
    _selectedGoodsNameController = new TextEditingController();
    _selectedSpecificationController = new TextEditingController();
    _selectedNumController = new TextEditingController();
    _selectedAmountController = new TextEditingController();
    _selectedRequestDepController = new TextEditingController();
    _selectedRemarksController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加申请单"),
      ),
      body: Form(
        key: _formKey,
        autovalidate: true,
        child: ListView(
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                child: RichText(
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                      color: Color(0xffff0000),
                      fontSize: 20.0,
                    ),
                  )
                ])),
                flex: 1,
              ),
              Expanded(
                child: TextField(
                  controller: _selectedRequestModeController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    icon: Icon(Icons.assessment),
                    labelText: "申请模式",
                    hintText: "请输入申请模式",
                    suffixIcon: Icon(Icons.chevron_right),
                  ),
                  onTap: () async {
                    Map<String, dynamic> result = await Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => SelectDropDownPage(
                                  type: 76,
                                )));
                    if (result == null) {
                      return;
                    }
                    setState(() {
                      selectedRequestMode = result;
                    });
                    _selectedRequestModeController.text =
                    selectedRequestMode['name'];
                  },
                ),
                flex: 20,
              ),
            ]),
            Row(children: <Widget>[
              Expanded(
                child: RichText(
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Color(0xffff0000),
                          fontSize: 20.0,
                        ),
                      )
                    ])),
                flex: 1,
              ),
              Expanded(
                child: TextField(
                  controller: _selectedDepartmentController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    icon: Icon(Icons.perm_contact_calendar),
                    labelText: "申请部门",
                    hintText: "请输入申请部门",
                    suffixIcon: Icon(Icons.chevron_right),
                  ),
                  onTap: () async {
                    Map<String, dynamic> result = await Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => SelectDepartmentPage(

                            )));
                    if (result == null) {
                      return;
                    }
                    setState(() {
                      selectedDepartment = result;
                    });
                    _selectedDepartmentController.text =
                    selectedDepartment['name'];
                  },
                ),
                flex: 20,
              ),
            ]),   Row(children: <Widget>[
              Expanded(
                child: RichText(
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Color(0xffff0000),
                          fontSize: 20.0,
                        ),
                      )
                    ])),
                flex: 1,
              ),
              Expanded(
                child: TextField(
                  controller: _selectedBuyerController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    icon: Icon(Icons.account_box),
                    labelText: "申请人",
                    hintText: "请输入申请人",
                    suffixIcon: Icon(Icons.chevron_right),
                  ),
                  onTap: () async {
                    Map<String, dynamic> result = await Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => SelectAccessoriesPage(
                            )));
                    if (result == null) {
                      return;
                    }
                    setState(() {
                      selectedBuyer = result;
                    });
                    _selectedBuyerController.text =
                    selectedBuyer['empname'];
                  },
                ),
                flex: 20,
              ),
            ]),
            RaisedButton(
                color: Colors.blue,
                child: Text(
                  "选择助记码",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  Map<String, dynamic> _selectContract = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectMnemonicCodePage()));
                  if (_selectContract == null) {
                    return;
                  }

                  // 配件名称
                  goodsName = _selectContract["goodsName"];
                  // 子合同代号
                  specification = _selectContract["specification"];
                  _selectedGoodsNameController.text =
                  _selectContract["goodsName"];
                  _selectedSpecificationController.text = _selectContract["specification"];

                }),
            Row(children: <Widget>[
              Expanded(
                child: RichText(
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Color(0xffff0000),
                          fontSize: 20.0,
                        ),
                      )
                    ])),
                flex: 1,
              ),
              Expanded(
                child: TextField(
                  controller: _selectedGoodsNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      icon: Icon(Icons.assignment),
                      labelText: "物品名称",
                      hintText: "请输入物品名称"),
                  onChanged: (val) {
                    setState(() {
                      goodsName = val;
                    });
                  },
                ),
                flex: 20,
              ),
            ]),
            Row(children: <Widget>[
              Expanded(
                child: RichText(
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Color(0xffff0000),
                          fontSize: 20.0,
                        ),
                      )
                    ])),
                flex: 1,
              ),
              Expanded(
                child: TextField(
                  controller: _selectedSpecificationController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      icon: Icon(Icons.calendar_view_day),
                      labelText: "物品规格",
                      hintText: "请输入物品规格"),
                  onChanged: (val) {
                    setState(() {
                      specification = val;
                    });
                  },
                ),
                flex: 20,
              ),
            ]),
            Row(children: <Widget>[
              Expanded(
                child: RichText(
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                      color: Color(0xffff0000),
                      fontSize: 20.0,
                    ),
                  )
                ])),
                flex: 1,
              ),
              Expanded(
                child: TextField(
                  controller: _selectedNumController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      icon: Icon(Icons.view_headline),
                      labelText: "申请数量",
                      hintText: "请输入申请数量"),
                  onChanged: (val) {
                    setState(() {
                      num = val;
                    });
                  },
                ),
                flex: 20,
              ),
            ]),
            Row(children: <Widget>[
              Expanded(
                child: RichText(
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Color(0xffff0000),
                          fontSize: 20.0,
                        ),
                      )
                    ])),
                flex: 1,
              ),
              Expanded(
                child: TextField(
                  controller: _selectedAmountController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      icon: Icon(Icons.attach_money),
                      labelText: "申请金额",
                      hintText: "请输入申请金额"),
                  onChanged: (val) {
                    setState(() {
                      amount = val;
                    });
                  },
                ),
                flex: 20,
              ),
            ]),
            TextField(
              controller: _selectedRequestDepController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  icon: Icon(Icons.format_align_center),
                  labelText: "申请描述",
                  hintText: "请输入申请描述"),
              onChanged: (val) {
                setState(() {
                  requestDep = val;
                });
              },
            ),
            TextField(
              controller: _selectedRemarksController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  icon: Icon(Icons.format_align_left),
                  labelText: "备注",
                  hintText: "请输入备注"),
              onChanged: (val) {
                setState(() {
                  remarks= val;
                });
              },
            ),

            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: RaisedButton(
                child: Text(
                  "添加",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _submitAddTask();
                },
                color: Colors.blueAccent,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _submitAddTask() async {
    if(selectedRequestMode['code'] == null){
      Toast.show("请选择申请模式");
      return;
    }
    if(selectedDepartment['deptid'] == null){
      Toast.show("请选择申请部门");
      return;
    }
    if(selectedBuyer['empname'] == null){
      Toast.show("请选择申请人");
      return;
    }
    if(goodsName == ""){
      Toast.show("请输入配件名称");
      return;
    }
    if(specification == ""){
      Toast.show("请输入配件规格");
      return;
    }
    if(num == ""){
      Toast.show("请输入申请数量");
      return;
    }
    if(amount==""){
      Toast.show("请输入申请金额");
      return;
    }
    await addWmConFigureApply(
        requestMode:selectedRequestMode['code'].toString(),
        department:selectedDepartment['deptid'].toString(),
        buyer: selectedBuyer['empname'].toString(),
        goodsName:goodsName,
        specification:specification,
        num:num,
        amount:amount,
        requestDep:requestDep,
        remarks:remarks,
    );
    Toast.show("添加成功");
    Navigator.pop(context);
  }
}
