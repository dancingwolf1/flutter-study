import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:ui';

class ContractPaperDetailPage extends StatefulWidget {
  final List<String> images;
  final int index;

  const ContractPaperDetailPage(this.images, this.index, {Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ContractPaperDetailPageState();
}

class ContractPaperDetailPageState extends State<ContractPaperDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                top: MediaQueryData.fromWindow(window).padding.top),
            alignment: Alignment.topRight,
            child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {

                  Navigator.pop(context);
                }),
          ),
          Container(
            margin: EdgeInsets.only(
                top: MediaQueryData.fromWindow(window).padding.top + 50),
            child: Swiper(
              index: widget.index,
              itemBuilder: (BuildContext context, int index) {
                return Image.network(
                  widget.images[index],
                  fit: BoxFit.fitWidth,
                );
              },
              itemCount: widget.images.length,
              pagination: SwiperPagination(),
              control: SwiperControl(),
            ),
          )
        ],
      ),
    );
  }
}
