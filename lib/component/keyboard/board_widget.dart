import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spterp/component/keyboard/scroll_focus_node.dart';

abstract class BoardWidget extends State<StatefulWidget>
    with WidgetsBindingObserver {
  final ScrollController _controller = ScrollController();

  ScrollFocusNode _focusNode;

  double _currentPosition = 0.0;

  List<Widget> initChild();

  void bindNewInputer(ScrollFocusNode focusNode) {
    _focusNode = focusNode;
    _animateUp();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  //  向上滚动
  void _animateUp() {
    _controller
        .animateTo(_focusNode.moveValue,
        duration: Duration(milliseconds: 250), curve: Curves.easeOut)
        .then((Null) {
      _currentPosition = _controller.offset;
    });
  }

  //  向下滚动
  void _animateDown() {
    _controller
        .animateTo(0.0,
        duration: Duration(milliseconds: 250), curve: Curves.easeOut)
        .then((Null) {
      _currentPosition = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: initChild()..add(SizedBox(height: 400.0)),
        ),
      ),
    );
  }

  //  使用系统键盘 ---> 矩阵变换 ---> 返回原位置
  @override
  void didChangeMetrics() {
    if (_currentPosition != 0.0) {
      _focusNode.unfocus(); // 如果不加，收起键盘再点击会默认键盘还在。
      _animateDown();
    }
  }
}