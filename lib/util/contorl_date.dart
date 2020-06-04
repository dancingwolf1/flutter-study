/**
 * create 王少帅 by 10月 16日
 * return 输出的时间类型为毫秒数
 * */

class OperationTime {
/*
* 昨天
*  */
  Map yesterday() {
    var hao = new DateTime.now();
    String begin = "00:00:00";
    String end = "23:59:59";
    var beginTime =
        hao.add(new Duration(days: -1)).toString().substring(0, 10) +
            " " +
            begin;
    var endTime =
        hao.add(new Duration(days: -1)).toString().substring(0, 10) + " " + end;
    return {
      "beginTime": beginTime,
      "endTime": endTime,
    };
  }

/*
* 三天内
*  */
  Map threeDays() {
    var hao = new DateTime.now();
    String begin = "00:00:00";
    String end = "23:59:59";
    var beginTime =
        hao.add(new Duration(days: -2)).toString().substring(0, 10) +
            " " +
            begin;
    var endTime =
        hao.add(new Duration(days: 0)).toString().substring(0, 10) + " " + end;
    return {
      "beginTime": beginTime,
      "endTime": endTime,
    };
  }

/*
* 本周
*  */
  Map date() {
    var hao = new DateTime.now();
    String begin = "00:00:00";
    String end = "23:59:59";
    String weekBegin = hao
        .add(new Duration(days: -hao.weekday + 1))
        .toString()
        .substring(0, 10) +
        " " +
        begin;
    String weekEnd = hao
        .add(new Duration(days: (7 - hao.weekday)))
        .toString()
        .substring(0, 10) +
        " " +
        end;
    return {
      "beginTime": weekBegin,
      "endTime": weekEnd,
    };
  }

/*
*本月
*/
  Map month() {
    var hao = new DateTime.now();
    String begin = "00:00:00";
    String end = "23:59:59";
    var beginTime =
        hao.add(new Duration(days: -hao.day + 1)).toString().substring(0, 10) +
            " " +
            begin;
    var monthEnd = new DateTime(hao.year, hao.month + 1, 1);
    monthEnd.add(new Duration(days: -1));
    var endTime =
        monthEnd.add(new Duration(days: -1)).toString().substring(0, 10) +
            " " +
            end;
    return {
      "beginTime": beginTime,
      "endTime": endTime,
    };
  }
 /*
*今天
*/
  Map day(){
    var hao = new DateTime.now();
    String begin = "00:00:00";
    String end = "23:59:59";
    var beginTime =
        hao.add(new Duration(days: 0)).toString().substring(0, 10) +
            " " +
            begin;
    var endTime =
        hao.add(new Duration(days: 0)).toString().substring(0, 10) + " " + end;
    return {
      "beginTime": beginTime,
      "endTime": endTime,
    };
  }
/*
*明天
*/
 Map tomorrow(){
   var hao = new DateTime.now();
   String begin = "00:00:00";
   String end = "23:59:59";
   var beginTime =
       hao.add(new Duration(days: 1)).toString().substring(0, 10) +
           " " +
           begin;
   var endTime =
       hao.add(new Duration(days: 1)).toString().substring(0, 10) + " " + end;
   return {
     "beginTime": beginTime,
     "endTime": endTime,
   };
 }
 /*
 * 上月
 */
 Map lastMonth(){
   var hao = new DateTime.now();
   String begin = "00:00:00";
   String end = "23:59:59";
   var beginTime =
       hao.add(new Duration(days: -hao.day + 1)).toString().substring(0, 10) +
           " " +
           begin;
   var monthEnd = new DateTime.now();
   var endTime =
       monthEnd.add(new Duration(days: -hao.day-1,)).toString().substring(0, 10) +
           " " +
           end;

   return {
     "beginTime": beginTime,
     "endTime": endTime,
   };
 }

}
/**
 * @param type　类型
 * */

Map changeTime(int type) {
  /**
   * 1代表本月
   * 2代表本周
   * 3代表三天内
   * 4代表昨天
   * 5代表今天
   * 6代表明天
   * 7代表上月
   */
  var operationTime = new OperationTime();

  int a = type;
  int _beginTime;
  int _endTime;

  switch (a) {
    case 1:

        _beginTime =
            DateTime.parse(operationTime.month()["beginTime"].toString())
                .millisecondsSinceEpoch;
        _endTime = DateTime.parse(operationTime.month()["endTime"].toString())
            .millisecondsSinceEpoch;

      break;
    case 2:
        _beginTime =
            DateTime.parse(operationTime.date()["beginTime"].toString())
                .millisecondsSinceEpoch;
        _endTime = DateTime.parse(operationTime.date()["endTime"].toString())
            .millisecondsSinceEpoch;
        break;
    case 3:
      _beginTime =
          DateTime.parse(operationTime.threeDays()["beginTime"].toString())
              .millisecondsSinceEpoch;
      _endTime =
          DateTime.parse(operationTime.threeDays()["endTime"].toString())
              .millisecondsSinceEpoch;
      break;
    case 4:
        _beginTime =
            DateTime.parse(operationTime.yesterday()["beginTime"].toString())
                .millisecondsSinceEpoch;
        _endTime =
            DateTime.parse(operationTime.yesterday()["endTime"].toString())
                .millisecondsSinceEpoch;
      break;
    case 5:
      _beginTime =
          DateTime.parse(operationTime.day()["beginTime"].toString())
              .millisecondsSinceEpoch;
      _endTime =
          DateTime.parse(operationTime.day()["endTime"].toString())
              .millisecondsSinceEpoch;
      break;
    case 6:
      _beginTime =
          DateTime.parse(operationTime.tomorrow()["beginTime"].toString())
              .millisecondsSinceEpoch;
      _endTime =
          DateTime.parse(operationTime.tomorrow()["endTime"].toString())
              .millisecondsSinceEpoch;
      break;
    case 7:
      _beginTime =
          DateTime.parse(operationTime.lastMonth()["beginTime"].toString())
              .millisecondsSinceEpoch;
      _endTime =
          DateTime.parse(operationTime.lastMonth()["endTime"].toString())
              .millisecondsSinceEpoch;
  }
  return {"beginTime":_beginTime,"endTime":_endTime};
}