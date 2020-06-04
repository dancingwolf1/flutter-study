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

class PageTransfPage2 extends StatefulWidget {
  @override
  PageTransfPage2State createState() => PageTransfPage2State();
}



class PageTransfPage2State extends State<PageTransfPage2> {


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
            title:Text("页面跳转2"),
          ),
         body: Container(
           child: Container(
             child: Column(
               children: <Widget>[

                 FloatingActionButton(

                   onPressed: () => Navigator.pop(context),
                   child: Text("点我跳转到上一页"),
                   tooltip: "按这么长时间干嘛",
                   foregroundColor: Colors.black,
                   backgroundColor: Colors.blue,
                   shape: BeveledRectangleBorder(),//形状长方形
                 ),
               ],
             ),
           ),
         ),


        )
      ],
    );
  }

}

