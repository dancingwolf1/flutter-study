import 'package:amap_base/amap_base.dart';
import 'package:flutter/material.dart';

class DrawPointScreen extends StatefulWidget {
  final List locals;

  String title;

  DrawPointScreen(this.locals, {this.title});

  @override
  DrawPointScreenState createState() => DrawPointScreenState();
}

class DrawPointScreenState extends State<DrawPointScreen> {
  AMapController _controller;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    List<MarkerOptions> makers = [];
    for (int i = 0; i < widget.locals.length; i++) {
      var latLng = widget.locals[i];
      makers.add(
        MarkerOptions(
          icon: 'images/home_map_icon_positioning_nor.png',
          position: latLng,
          title: widget.title == null ? '' : widget.title,
          snippet: '',
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择工程地址'),
//        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          return AMapView(
            onAMapViewCreated: (controller) {
              print("onAMapViewCreated===========");
              _controller = controller;
              _controller.markerClickedEvent.listen((marker) {
                Navigator.pop(context, marker.toJson()); // 将选择的位置返回选择页
              });
              _controller.addMarkers(makers);
            },
            amapOptions: AMapOptions(
              compassEnabled: false,
              zoomControlsEnabled: true,
              logoPosition: LOGO_POSITION_BOTTOM_CENTER,
//              camera: CameraPosition(
//                target: LatLng(40.851827, 111.801637),
//                zoom: 15,
//              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
