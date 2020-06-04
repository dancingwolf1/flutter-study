import 'package:flutter/material.dart';
import 'package:flutter_spterp/pages/home/index.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// 生成柱形图的方法
/// [value]  柱形图所依赖的文件配置
Widget getBarView(var value) {
  List<BarSales> dataBar = value;
  var seriesBar = [
    charts.Series(
      id: "Sales",
      // 柱形图的配置文件
      data: dataBar,
      domainFn: (BarSales sales, _) => sales.name,
      // 柱形图的高
      measureFn: (BarSales sales, _) => sales.sale,
      // 柱形图上方的值
      labelAccessorFn: (BarSales sales, _) {
        if (sales.sale > 10000) {
          return '${(double.parse((sales.sale).toString()) / 1000).toStringAsFixed(2)}万';
        }
        return '${sales.sale}';
      },
      // 返回柱形图每个柱子的颜色
      fillColorFn: (BarSales sales, __) {
        String materialScience = sales.name;
        var color;
        switch (materialScience) {
          case "砂":
            color = charts.MaterialPalette.blue.shadeDefault.lighter;
            break;
          case "石":
            color = charts.MaterialPalette.deepOrange.shadeDefault.lighter;
            break;
          case "水泥":
            color = charts.MaterialPalette.red.shadeDefault.lighter;
            break;
          case "粉煤灰":
            color = charts.MaterialPalette.pink.shadeDefault.lighter;
            break;
          case "矿粉":
            color = charts.MaterialPalette.green.shadeDefault.lighter;
            break;
          case "外加剂":
            color = charts.MaterialPalette.cyan.shadeDefault.lighter;
            break;
          default:
            color = charts.MaterialPalette.teal.shadeDefault;
        }
        return color;
      },
      // 柱形图 上方文字颜色
      outsideLabelStyleAccessorFn: (BarSales sales, _) {
        String materialScience = sales.name;
        var color;
        switch (materialScience) {
          case "砂":
            color = charts.MaterialPalette.blue.shadeDefault;
            break;
          case "石":
            color = charts.MaterialPalette.deepOrange.shadeDefault;
            break;
          case "水泥":
            color = charts.MaterialPalette.red.shadeDefault;
            break;
          case "粉煤灰":
            color = charts.MaterialPalette.pink.shadeDefault;
            break;
          case "矿粉":
            color = charts.MaterialPalette.green.shadeDefault;
            break;
          case "外加剂":
            color = charts.MaterialPalette.cyan.shadeDefault;
            break;
          default:
            color = charts.MaterialPalette.teal.shadeDefault;
        }
        return new charts.TextStyleSpec(
          color: color,
          fontSize: 12,
        );
      },
    )
  ];
  return Container(
    width: double.infinity,
    child: charts.BarChart(seriesBar,
        // 动画效果
        animate: false,
        // 柱形图上方文字样式
        barRendererDecorator: new charts.BarLabelDecorator<String>(
            labelPosition: charts.BarLabelPosition.outside),
// domainAxis: new charts.OrdinalAxisSpec(),
        // y轴
        primaryMeasureAxis: new charts.NumericAxisSpec(
            renderSpec: new charts.SmallTickRendererSpec(
                // Tick and Label styling here.
                )),
        //自定义系列渲染器
        customSeriesRenderers: [
          new charts.BarTargetLineRendererConfig<String>(
              // ID used to link series to this renderer.
              customRendererId: 'customTargetLine',
              groupingType: charts.BarGroupingType.grouped)
        ]),
  );
}
