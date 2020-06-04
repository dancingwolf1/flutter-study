import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:flutter_spterp/component/loading.dart';

class SelectSpecialPricePage extends StatefulWidget {
  final String taskId; // 任务单ID
  final List priceList; // 加价项目列表
  SelectSpecialPricePage(this.taskId, {this.priceList});

  @override
  SelectSpecialPricePageState createState() => SelectSpecialPricePageState();
}

class SelectSpecialPricePageState extends State<SelectSpecialPricePage> {
  List<dynamic> _stgIds = [];
  bool isLoaded = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await _loadDate();
    print("我的加价项目${widget.priceList}");
  }

  Future _loadDate() async {
    List<dynamic> stgIds = await getPriceMarkup();
    print("stgIds:$stgIds");

    setState(() {
      _stgIds = stgIds;
      isLoaded = true;
    });
    // 初始化复选框
    if(widget.priceList!=null){
      _stgIds.forEach((v){
        if(widget.priceList.contains(v["ppcode"])){
          v['selected'] =true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("加价项目"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "确定",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              print("send save");
              setState(() {
                _isLoading = true;
              });
//              List<Map<String, dynamic>> selectedStgs = [];
              List selectedStgs = [];
              print("我的选择列表${_stgIds}");
              _stgIds.forEach((item) {
                if (item['selected'] != null && item['selected']) {
                  selectedStgs.add(item['ppcode']);
                  print("为何成立${item['selected']}");
                  print("为何成立${item['selected']}");
                  print("为何成立全部$_stgIds");
                  print("为何成立全部item$item");
                  print("成立");
                  print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
                }
              });
              addTaskPriceMarkup(widget.taskId,selectedStgs.join(","));
              setState(() {
                isLoaded = false;
              });

              Toast.show("编辑加价项目成功");
              Navigator.pop(context);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: isLoaded
          ? loading(
              _isLoading,
              ListView(
                children: _listBuilder(),
              ))
          : loading(true, Container()),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _stgIds.forEach((item) {
                        item['selected'] = true;
                      });
                    });
                  },
                  child: Text(
                    "全选",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Container(
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _stgIds.forEach((item) {
                        item['selected'] = false;
                      });
                    });
                  },
                  child: Text(
                    "全不选",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _listBuilder() {
    List<Widget> list = [];
    _stgIds.forEach((item) {
      list.add(CheckboxListTile(
          onChanged: (value) {
            setState(() {
              item['selected'] =
                  item['selected'] == null ? true : !item['selected'];
            });
          },
          title: Text("${item['ppname']}"),
          value: item['selected'] == null ? false : item['selected'],
          controlAffinity: ListTileControlAffinity.leading));
    });
    return list;
  }
}
