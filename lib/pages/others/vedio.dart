
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class VedioPage extends StatefulWidget {
  @override
  VedioPageState createState() => VedioPageState();
}



class VedioPageState extends State<VedioPage> {

  VideoPlayerController _controller; //视频
  bool loadOk = true;
  var privacyHeight = 1.7;
  @override
  void initState() {
    super.initState();
    _controller =
    VideoPlayerController.network('http://www.hntxrj.com/txal/Promo.mp4')
      ..initialize().then((_) {
        setState(() {
          loadOk = true;
        });
      });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title:Text("vedio"),
          ),
         body:loadOk
             ? SingleChildScrollView(
           child: Column(
             children: <Widget>[_shortcutMenu()],
           ),
         )
             : Container(),
        )
      ],
    );
  }

  _shortcutMenu() {
    return Card(
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 150,
                      child: _controller.value.initialized
                          ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                          : Container(),
                    ),
                    FloatingActionButton(
                      backgroundColor: Color.fromRGBO(230, 230, 230, 0.01),
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      child: _controller.value.isPlaying
                          ? Icon(
                        Icons.pause,
                        color: Colors.black,
                      )
                          : Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

}

