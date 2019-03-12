import 'package:video_player/video_player.dart';

class MyVideoPlayer extends VideoPlayerController {
  MyVideoPlayer.asset(String dataSource) : super.asset(dataSource);

  MyVideoPlayer.network(String dataSource) : super.network(dataSource);

  // MyVideoPlayer.file(String dataSource) : super.file(dataSource);

  static final Map<String, VideoPlayerController> _videoPlayerController = <String, VideoPlayerController>{};

  factory MyVideoPlayer.fact(String name, String url) {
    if(_videoPlayerController.containsKey(name)) {
      print("set init player >>>>>>>>>>>>>>>>>>>>>>>>>> ${name}");
      _videoPlayerController[name].play();
      return _videoPlayerController[name];
    }else {
      print("set init player ${name}");
      final currentVideoPlayerController =MyVideoPlayer.network(url);
      _videoPlayerController[name] = currentVideoPlayerController;
      return currentVideoPlayerController;
    }
  }

  void removePlayer(String name) {
    // print("removePlayer when dispose ${name}");
    _videoPlayerController.keys
    .where((k) => k == name) // filter keys
    .toList() // create a copy to avoid concurrent modifications
    .forEach(_videoPlayerController.remove);
    // _videoPlayerController.remove(_videoPlayerController[name]);
  }

  static void stopVideoPlayer(String name) {
    VideoPlayerController _currentPlaying = _videoPlayerController[name];
    if(_currentPlaying !=null) {
      _currentPlaying.pause();
    }
  }

  static void playHomeVideo(String name) {
    if(_videoPlayerController.containsKey(name)) {
      _videoPlayerController[name].play();
    }
  }

  @override
  Future<void> dispose() async {  
    super.dispose(); 
  }

}