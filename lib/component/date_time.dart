import 'package:flutter/material.dart';

Future<int> showDateTime(BuildContext context, {int initTimeStamp}) async {
  /// 返回时间日期的13位时间戳
  DateTime date = await showDatePicker(
    context: context,
    initialDate: initTimeStamp == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(initTimeStamp),
    firstDate: DateTime(2018),
    lastDate: DateTime(2030),
    builder: (BuildContext context, Widget child) {
      return Theme(
        data: ThemeData.light(),
        child: SingleChildScrollView(
          child: child,
        ),
      );
    },
  );
  // 以后未选择日期
  if (date == null) {
    return initTimeStamp == null
        ? DateTime.now().millisecondsSinceEpoch
        : initTimeStamp;
  }
  TimeOfDay time = await showTimePicker(
    initialTime: TimeOfDay.now(),
    context: context,
  );
  return DateTime.parse(date.toString().substring(0, 10) +
          " " +
          (time.hour < 10 ? "0" + time.hour.toString() : time.hour.toString()) +
          ":" +
          (time.minute < 10
              ? "0" + time.minute.toString()
              : time.minute.toString()))
      .millisecondsSinceEpoch;
}
