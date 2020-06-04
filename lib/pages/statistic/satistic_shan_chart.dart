/// Bar chart with example of a legend with customized position, justification,
/// desired max rows, and padding. These options are shown as an example of how
/// to use the customizations, they do not necessary have to be used together in
/// this way. Choosing [end] as the position does not require the justification
/// to also be [endDrawArea].
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// Example that shows how to build a series legend that shows measure values
/// when a datum is selected.
///
/// Also shows the option to provide a custom measure formatter.

class ShanChartPage extends StatefulWidget {
  @override
  ShanChartPageState createState() => ShanChartPageState();
}



class ShanChartPageState extends State<ShanChartPage> {

  final List<charts.Series> seriesList=_createSampleData();
  final bool animate =true ;







  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title:Text("扇形图"),
          ),
          body:  new charts.PieChart(seriesList,
              animate: animate,
              // Add an [ArcLabelDecorator] configured to render labels outside of the
              // arc with a leader line.
              //
              // Text style for inside / outside can be controlled independently by
              // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
              //
              // Example configuring different styles for inside/outside:
              //       new charts.ArcLabelDecorator(
              //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
              //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
              defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
                new charts.ArcLabelDecorator(
                    labelPosition: charts.ArcLabelPosition.outside)
              ])),

        )
      ],
    );


  }



  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 100),
      new LinearSales(1, 75),
      new LinearSales(2, 25),
      new LinearSales(3, 5),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
