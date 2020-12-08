import 'package:video_player/video_player.dart';

class Media {
  String url;
  String type;
  VideoPlayerController videoController;
  Future<void> initializeVideoPlayer;
  String cachePath;

  Media({this.url, this.type});
}