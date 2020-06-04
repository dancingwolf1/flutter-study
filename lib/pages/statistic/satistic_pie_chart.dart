/// Gauge chart example, where the data does not cover a full revolution in the
/// chart.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class PieChartPage extends StatefulWidget {
  @override
  PieChartPageState createState() => PieChartPageState();
}



class PieChartPageState extends State<PieChartPage> {

  final List<charts.Series> seriesList=_createSampleData();

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
            title:Text("环形图"),
          ),
          body:  new charts.PieChart(seriesList,
              animate: true,
              // Configure the width of the pie slices to 30px. The remaining space in
              // the chart will be left as a hole in the center. Adjust the start
              // angle and the arc length of the pie so it resembles a gauge.
              //arcWidth 控制环形宽度
              //startAngle  控制起点
              //arcLength  控制长度
              defaultRenderer: new charts.ArcRendererConfig(
                  //下面存在缺口
                  //arcWidth: 5, startAngle: 4 / 5 * 3.14, arcLength: 7 / 5 * 3.14)),
                  //整圆
                  //arcWidth: 5, startAngle: 10 / 5 * 3.14, arcLength: 10 / 5 * 3.14)),
                  arcWidth: 25, startAngle: 0, arcLength: 6.28)),

        )
      ],
    );


  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<GaugeSegment, String>> _createSampleData() {
    final data = [
      new GaugeSegment('Low', 25),
      new GaugeSegment('Acceptable', 50),
      new GaugeSegment('High', 75),
      new GaugeSegment('Highly Unusual', 100),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }
}

/// Sample data type.
class GaugeSegment {
  final String segment;
  final int size;

  GaugeSegment(this.segment, this.size);
}