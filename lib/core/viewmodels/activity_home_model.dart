import 'package:education/core/classes/constant.dart';
import 'package:education/core/classes/activity.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/core/services/api.dart';
import 'package:education/core/viewmodels/base_model.dart';
import 'package:education/locator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';

class ActivityHomeModel extends BaseModel {
  final Api _api = locator<Api>();
  List<Activity> allActivity;
  VideoPlayerController videoController;
  Future<void> initializeVideoPlayer;

  void getActivityList(String activityType) async {
    setState(ViewState.Busy);
    if(allActivity == null) {
      allActivity = await _api.getAllActivity(activityType);
      notifyListeners();
    }
    setState(ViewState.Idle);
  }

  /*void getDiyVideo(Diy diy) async {
    loadVideoState = ViewState.Busy;

    try {
      // Get Introduction video
      StorageReference reference = FirebaseStorage.instance.ref().child('activity_diy/' + selectedDiy.id + '/intro.mp4');
      selectedDiy.introVideoStr = await reference.getDownloadURL();
      videoController = VideoPlayerController.network(selectedDiy.introVideoStr);
      initializeVideoPlayer = videoController.initialize();
      videoController.setLooping(true);
      videoController.setVolume(4.0);
      videoController.play();
      notifyListeners();
    } catch(ex) {
      print('error on loadInstructions: ' + ex.toString());
    }

    notifyListeners();
    loadVideoState = ViewState.Idle;
  }*/
}