import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AccessoriesListPage extends StatefulWidget {
  @override
  AccessoriesListPageState createState() => AccessoriesListPageState();
}

class AccessoriesListPageState extends State<AccessoriesListPage> {

  final List<charts.Series> seriesList=createSampleData();

  @override
  void initState() {
    super.initState();
  }

  String totalSubscriptValue = "0";

  @override
  Widget build(BuildContext context) {
      return  Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              title:Text("条形图"),
            ),
            body: new charts.BarChart(
              seriesList,
              animate: true,
              // Configure the bar renderer in grouped stacked rendering mode with a
              // custom weight pattern.
              //
              // The first stack of bars in each group is configured to be twice as wide
              // as the second stack of bars in each group.
              defaultRenderer: new charts.BarRendererConfig(
                groupingType: charts.BarGroupingType.stacked,
                weightPattern: [2, 1],
              ),
            ),

          )
        ],
      );


  }

  static List<charts.Series<OrdinalSales, String>> createSampleData() {
    final desktopSalesDataA = [
      new OrdinalSales('2014', 1),
      new OrdinalSales('2015', 2),
      new OrdinalSales('2016', 3),
      new OrdinalSales('2017', 4),
    ];

    final tableSalesDataA = [
      new OrdinalSales('2014', 1),
      new OrdinalSales('2015', 2),
      new OrdinalSales('2016', 2),
      new OrdinalSales('2017', 1),
    ];

    final mobileSalesDataA = [
      new OrdinalSales('2014', 20),
      new OrdinalSales('2015', 20),
      new OrdinalSales('2016', 20),
      new OrdinalSales('2017', 20),
    ];

    final desktopSalesDataB = [
      new OrdinalSales('2014', 30),
      new OrdinalSales('2015', 30),
      new OrdinalSales('2016', 30),
      new OrdinalSales('2017', 30),
    ];

    final tableSalesDataB = [
      new OrdinalSales('2014', 40),
      new OrdinalSales('2015', 40),
      new OrdinalSales('2016', 40),
      new OrdinalSales('2017', 40),
    ];

    final mobileSalesDataB = [
      new OrdinalSales('2014', 50),
      new OrdinalSales('2015', 50),
      new OrdinalSales('2016', 50),
      new OrdinalSales('2017', 50),
    ];

    return [
//      new charts.Series<OrdinalSales, String>(
//        id: 'Desktop A',
//        seriesCategory: 'A',
//        domainFn: (OrdinalSales sales, _) => sales.year,
//        measureFn: (OrdinalSales sales, _) => sales.sales,
//        data: desktopSalesDataA,
//      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Tablet A',
        seriesCategory: 'A',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesDataA,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Mobile A',
        seriesCategory: 'A',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesDataA,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Desktop B',
        seriesCategory: 'B',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesDataB,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Tablet B',
        seriesCategory: 'B',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesDataB,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Mobile B',
        seriesCategory: 'B',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesDataB,
      ),
    ];
  }
}
class OrdinalSales {
  final String year;
  final int sales;
  OrdinalSales(this.year, this.sales);
}
