/// Bar chart with example of a legend with customized position, justification,
/// desired max rows, and padding. These options are shown as an example of how
/// to use the customizations, they do not necessary have to be used together in
/// this way. Choosing [end] as the position does not require the justification
/// to also be [endDrawArea].
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_spterp/pages/home/circular_graph.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕适配库
/// Example that shows how to build a series legend that shows measure values
/// when a datum is selected.
///
/// Also shows the option to provide a custom measure formatter.

class KeyPage extends StatefulWidget {
  @override
  KeyPageState createState() => KeyPageState();
}



class KeyPageState extends State<KeyPage> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
            appBar: AppBar(
              title:Text("首页完成度"),
            ),
            body: Center(
              child: Container(
                  height: ScreenUtil().setWidth(684),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/index_bg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 60,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.black,//圆环背景
                              minRadius: ScreenUtil().setWidth(147),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.blue,//环中圆背景
                              minRadius: ScreenUtil().setWidth(123),
                            ),
                            GradientCircularProgressIndicator(
                              backgroundColor: Colors.transparent,
                              colors: [
                                Colors.red,
                                Colors.green,
                              ],
                              radius: ScreenUtil().setWidth(137),
                              stokeWidth: ScreenUtil().setWidth(24),
                              strokeCapRound: true,
                              value: double.parse("123"),
                            ),
                            Column(
                              children: <Widget>[
                                Text("456%",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(60))),
                                Text("已完成",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setWidth(28))),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: ScreenUtil().setWidth(40)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Text("789",
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(40),
                                            color: Colors.white)),
                                    SizedBox(
                                      height: ScreenUtil().setWidth(6),
                                    ),
                                    Text("已完成",
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(28),
                                            color: Colors.white))
                                  ],
                                ),
                              ),
                              //今日计划
                              GestureDetector(
                                onTap: () async {
                                  await Navigator.pushNamed(
                                      context, "/production_planning");
                                },
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Text("258",
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(40),
                                              color: Colors.white)),
                                      SizedBox(
                                        height: ScreenUtil().setWidth(6),
                                      ),
                                      Text("今日计划",
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(28),
                                              color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),

                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Text("369",
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(40),
                                            color: Colors.white)),
                                    SizedBox(
                                      height: ScreenUtil().setWidth(6),
                                    ),
                                    Text("未完成",
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(28),
                                            color: Colors.white))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        /*     Container(
                                height: 100,
                                width: 100,
                                color: Colors.red,
                              ),*/
                      ],
                    ),
                  )),
            )


        )
      ],
    );
  }

}


