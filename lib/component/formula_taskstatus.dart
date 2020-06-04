import 'package:flutter/material.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/loading.dart';
import 'package:flutter_spterp/component/no_more.dart';
class SelecttaskStatusPage extends StatefulWidget {
  SelecttaskStatusPage({this.type});

  final int type;
  @override
  SelecttaskStatusPageState createState() => SelecttaskStatusPageState();
}
class SelecttaskStatusPageState extends State<SelecttaskStatusPage> {
  List<dynamic> dateList = [];
  bool isLoaded = false;
  Map<String, dynamic> selectedDate = {};
  String _title = "";
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init().then((v){
      setState(() {
        _loading = false;
      });
    });
  }
  Future _init() async {
    String title = "";

    List<dynamic> _date = await getDropDown(widget.type);
    setState(() {
      dateList = _date;
      isLoaded = true;
    });

    switch (widget.type) {
      case 23:
        title = "请选择任务单状态";
        break;
    }
    setState(() {
      _title = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: loading(_loading, _bodyBuild()));
  }

  Widget _bodyBuild() {
    if (!isLoaded) {
      return Container();
    }

    List<Widget> listViewWidget = [];
    for (Map dateItem in dateList) {
      listViewWidget.add(_itemBuild(dateItem));
    }

    return ListView(
      children: listViewWidget.length==0?<Widget>[noMore()]:listViewWidget,
    );
  }

  Widget _itemBuild(itemDate) {
    return Container(
      color: Colors.white,
      child: ListTile(
          title: Text(itemDate['name']),
//          subtitle: Text(itemDate['code']),
          onTap: () {
            setState(() {
              selectedDate = itemDate;

              Navigator.pop(context, selectedDate);
            });
          }),
    );
  }
}