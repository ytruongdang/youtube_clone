import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import './video_player_manager.dart';

class TopVideoPlayer extends StatefulWidget {
  final String videoUrl;
  TopVideoPlayer(this.videoUrl);
  @override
  _TopVideoPlayerState createState() => _TopVideoPlayerState();
}

class _TopVideoPlayerState extends State<TopVideoPlayer> {

  MyVideoPlayer _controller;

  void initState() {
    super.initState();
    _controller = MyVideoPlayer.fact('topVideo', widget.videoUrl)..initialize().then((_){
      setState(() {

      });
      _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: _controller.value.initialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Container(),
      )
    );
  }
}