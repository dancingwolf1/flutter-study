import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:ui' as ui show TextStyle;

class CanvasPainter extends CustomPainter {
  final List _realTimeInventory;

  CanvasPainter(this._realTimeInventory);

  // 文字
  Paragraph buildParagraph(
      String text, double textSize, double constWidth, Color colors,
      {bool stroke = false, Color textColor = Colors.black}) {
    ParagraphBuilder builder = ParagraphBuilder(
      ParagraphStyle(
        textAlign: TextAlign.left,
        fontSize: textSize,
        fontWeight: FontWeight.normal,
      ),
    );
    builder.pushStyle(ui.TextStyle(
        color: colors,
        shadows: stroke
            ? [
                //阴影改描边
                Shadow(color: textColor, blurRadius: 1.4, offset: Offset(0, 0)),
                Shadow(color: textColor, blurRadius: 1.4, offset: Offset(0, 0)),
                Shadow(color: textColor, blurRadius: 1.4, offset: Offset(0, 0)),
                Shadow(color: textColor, blurRadius: 1.4, offset: Offset(0, 0)),
              ]
            : [null]));
    builder.addText(text);
    ParagraphConstraints constraints = ParagraphConstraints(width: constWidth);
    return builder.build()..layout(constraints);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Color colors; // 文字描边颜色记录器
// paint 画笔状态,用来定义画笔
    Paint()
      ..color = Color.fromRGBO(51, 150, 251, 1)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;

    /// 下列注释用于维护和测试
// 一切以填充为基准
/*// 最大库存(边框)
    canvas.drawRect(
        Rect.fromLTWH(0.0, 30, 280.0, 25.0),
        Paint()
          ..color = Colors.lightBlueAccent
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke);
// 当前库存(填充)
    canvas.drawRect(Rect.fromLTWH(1.0, 30.0 + 1.0, 278.0, 23.0),
        Paint()..color = Colors.red);
// 库位名称(文字提示)
    canvas.drawParagraph(
        buildParagraph('33#(10-20)碎石', 18, 1000, Colors.black), Offset(0, 0));
// 最大库存(文字提示)
    canvas.drawParagraph(
        buildParagraph('最大库存', 14, 1000, Colors.yellow), Offset(300, 20));
// 最大库存数量(文字提示)
    canvas.drawParagraph(
        buildParagraph('180.000吨', 14, 1000, Colors.red), Offset(300, 38));
// 当前库存数
    canvas.drawParagraph(
        buildParagraph('180.000吨', 14, 1000, Colors.white), Offset(2, 30));
*/
    // 写一个返回填充长度和颜色的方法 第一个最大库存 第二个当前库存
    Map _getFillState(double maxInventory, double currenInventory) {
      double fillLength;

      if (currenInventory <= 0) {
        // 当前库存为负值
        colors = Colors.blue;
        fillLength = 0;
        return {"fillLength": fillLength, "color": Colors.white};
      }

      if (maxInventory <= 0) {
        fillLength = 280.0;
        colors = Color.fromRGBO(242, 86, 67, 1);
        return {
          "fillLength": fillLength,
          "color": Color.fromRGBO(242, 86, 67, 1)
        };
      }

      // 爆仓处理
      if (currenInventory > maxInventory) {
        // 当前库存大于最大库存
        fillLength = 280.0;
        colors = Color.fromRGBO(242, 86, 67, 1);
        return {
          "fillLength": fillLength,
          "color": Color.fromRGBO(242, 86, 67, 1)
        };
      }

      // 缺少材料处理
      if (currenInventory / maxInventory <= 0.2) {
        fillLength = 280.0 * (currenInventory / maxInventory);
        colors = Color.fromRGBO(255, 148, 62, 1);
        return {
          "fillLength": fillLength,
          "color": Color.fromRGBO(255, 148, 62, 1)
        };
      }

      // 将要爆仓处理
      if (currenInventory / maxInventory >= 0.8) {
        fillLength = 280.0 * (currenInventory / maxInventory);
        colors = Color.fromRGBO(242, 86, 67, 1);
        return {
          "fillLength": fillLength,
          "color": Color.fromRGBO(242, 86, 67, 1)
        };
//        rgba(242, 86, 67, 1)
      }

      // 当前库存在最大库存之间(正常状态)
      fillLength = 280.0 * (currenInventory / maxInventory);
      colors = Color.fromRGBO(51, 150, 251, 1);
      return {
        "fillLength": fillLength,
        "color": Color.fromRGBO(51, 150, 251, 1)
      };
    }

    for (var i = 0; i < _realTimeInventory.length; i++) {
      // 填充文字数据位置
      double fillTextPositon = 0;
      fillTextPositon = 30.0 * (i + 1) + 30 * i + 24 * i;
      canvas.drawRect(
          Rect.fromLTWH(0.0, 30.0 * (i + 1) + 30 * i + 24 * i, 280.0, 25.0),
          Paint()
            ..color = Color.fromRGBO(51, 150, 251, 1)
            ..strokeWidth = 1.2
            ..style = PaintingStyle.stroke);
// 当前库存(填充)
      canvas.drawRect(
          Rect.fromLTWH(
              0.0,
              30.0 * (i + 1) + 2 + 30 * i + 24 * i - 2.5,
              _getFillState(
                  double.parse(_realTimeInventory[i]['Sto_Maxqty'].toString()),
                  double.parse(_realTimeInventory[i]['Sto_Curqty']
                      .toString()))['fillLength'],
              26.0),
          Paint()
            ..color = _getFillState(
                double.parse(_realTimeInventory[i]['Sto_Maxqty'].toString()),
                double.parse(
                    _realTimeInventory[i]['Sto_Curqty'].toString()))['color']);
// 库位名称(文字提示)
      canvas.drawParagraph(
          buildParagraph(
              '${_realTimeInventory[i]['Sto_Name']}', 18, 1000, Colors.black),
          Offset(0, 0 + 30.0 * i + 30 * i + 24 * i));
// 最大库存(文字提示)
      canvas.drawParagraph(buildParagraph('最大库存', 14, 1000, Colors.black),
          Offset(300, 20 + 30.0 * i + 30.0 * i + 24 * i));
// 最大库存数量(文字提示)
      canvas.drawParagraph(
          buildParagraph('${_realTimeInventory[i]['Sto_Maxqty'] / 1000}吨', 14,
              1000, Colors.black),
          Offset(300, 38 + 30.0 * i + 30 * i + 24 * i));
// 当前库存数
      canvas.drawParagraph(
          buildParagraph(
              '${(_realTimeInventory[i]['Sto_Curqty'] / 1000).toStringAsFixed(2)}吨',
              14,
              1000,
              Colors.white,
              stroke: true,
              textColor: colors),
          Offset(2, fillTextPositon));
    }
  }

  @override
  bool shouldRepaint(CanvasPainter other) {
    return true;
  }
}
