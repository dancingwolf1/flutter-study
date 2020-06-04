/**
 * create 王少帅 by 10月 16日
 * return 输出的时间类型 2019-11-01 00:00:00
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
* 上周
*  */
  Map lastWeek() {
    var hao = new DateTime.now();
    String begin = "00:00:00";
    String end = "23:59:59";
    String weekBegin = hao
        .add(new Duration(days:-hao.weekday-6))
        .toString()
        .substring(0, 10) +
        " " +
        begin;
    String weekEnd = hao
        .add(new Duration(days: (-hao.weekday)))
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
*上月
*/

  Map lastMonth(){
    var date = new DateTime.now();
    var prevMonth = new DateTime(date.year, date.month - 1, 1);
    var hao = new DateTime.now();

    String begin = "00:00:00";
    String end = "23:59:59";
    var beginTime =
        prevMonth.toString().substring(0, 10) +
            " " +
            begin;

    var monthEnd = new DateTime.now();

    var endTime =
        monthEnd.add(new Duration(days: -hao.day - 1,)).toString().substring(0, 10) +
            " " +
            end;
    return {
      "beginTime": beginTime,
      "endTime": endTime,
    };
  }
/**
 * 今天
 * */

  Map toDay(){
    String begin = "00:00:00";
    String end = "23:59:59";

    var date = new DateTime.now();

    var beginTime =date.toString().substring(0, 10) + " " + begin;
    var endTime =date.toString().substring(0,10) +" " + end;

    return {
      "beginTime": beginTime,
      "endTime": endTime,
    };
  }
}
