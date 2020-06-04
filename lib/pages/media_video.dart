///// Bar chart with example of a legend with customized position, justification,
///// desired max rows, and padding. These options are shown as an example of how
///// to use the customizations, they do not necessary have to be used together in
///// this way. Choosing [end] as the position does not require the justification
///// to also be [endDrawArea].
//import 'package:flutter/material.dart';
////import 'package:video_player/video_player.dart';
//
///// Example that shows how to build a series legend that shows measure values
///// when a datum is selected.
/////
///// Also shows the option to provide a custom measure formatter.
//
//class VideoPage extends StatefulWidget {
//  @override
//  VideoPageState createState() => VideoPageState();
//}
//
//
//
//class VideoPageState extends State<VideoPage> {
//  VideoPlayerController _controller;
//  bool _isPlaying = false;
//  String url = 'http://easyhtml5video.com/assets/video/new/Penguins_of_Madagascar.mp4';
//
//  @override
//  void initState() {
//     _controller = VideoPlayerController.network(this.url)
//    // 播放状态
//    ..addListener(() {
//    final bool isPlaying = _controller.value.isPlaying;
//    if (isPlaying != _isPlaying) {
//    setState(() { _isPlaying = isPlaying; });
//    }
//    })
//    // 在初始化完成后必须更新界面
//    ..initialize().then((_) {
//    setState(() {});
//    });
//    super.initState();
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Stack(
//      children: <Widget>[
//        Scaffold(
//          appBar: AppBar(
//            title:Text("Vedio"),
//          ),
//         body:
//
//         new Center(
//           child: _controller.value.initialized
//           // 加载成功
//               ? new AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: VideoPlayer(_controller),
//           ) : new Container(),
//         ),
//          floatingActionButton: new FloatingActionButton(
//            onPressed: _controller.value.isPlaying
//                ? _controller.pause
//                : _controller.play,
//            child: new Icon(
//              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//            ),
//          ),
//
//        )
//      ],
//    );
//  }
//
//
//}
//
