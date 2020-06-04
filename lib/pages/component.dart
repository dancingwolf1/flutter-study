import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spterp/component/appbar.dart';
import 'package:flutter_spterp/component/date_time.dart';
import 'package:flutter_spterp/component/input_filtrate/sidebar_input.dart';
import 'package:flutter_spterp/component/toast.dart';



class ComponentPage extends StatefulWidget {
  @override
  ComponentPageState createState() => ComponentPageState();
}



class ComponentPageState extends State<ComponentPage> {

  int _beginTime = DateTime.now().millisecondsSinceEpoch;//初始化未当前时间
  int dateFiltrateIndex = 0; // 日期选中的索引值

  @override
  Widget build(BuildContext context) {
    return

      Stack(
      children: <Widget>[
        Scaffold(
          appBar: getAppBar(context, "组件",isRightButton: false,
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      left: BorderSide(color: Colors.black, width: 3.0),
                      top: BorderSide(color: Colors.black, width: 3.0),
                      right: BorderSide(color: Colors.black, width: 3.0),
                      bottom: BorderSide(color: Colors.black, width: 3.0),
                      ),
                  ),
                  
                  child: onTapSelectTime(context, "时间选择", () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        onChanged: (date) {}, onConfirm: (date) {
                          dateFiltrateIndex = 5;
                          setState(() {
                            _beginTime = date.millisecondsSinceEpoch;
                            Toast.show(date.toIso8601String());
                          });
                        },
                        currentTime: DateTime.fromMillisecondsSinceEpoch(
                            _beginTime,
                            isUtc: false),
                        locale: LocaleType.zh);
                  }, _beginTime, dateLength: 19),
                ) ,
              ],
            ),
          ),

    )

          ]);
  }


  //输出文字
  void _print(String str){
    print("文字输出");
  }
}
