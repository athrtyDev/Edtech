import 'package:dio/dio.dart';
import 'package:education/core/classes/activity.dart';
import 'package:education/core/classes/media.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/core/services/api.dart';
import 'package:education/core/services/tool.dart';
import 'package:education/core/viewmodels/base_model.dart';
import 'package:education/locator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class ActivityHomeModel extends BaseModel {
  final Api _api = locator<Api>();
  List<Activity> allActivity;
  VideoPlayerController videoController;
  Future<void> initializeVideoPlayer;

  void getActivityList(String activityType) async {
    setState(ViewState.Busy);
    if(allActivity == null) {
      allActivity = await _api.getAllActivity();
      // Multiple media update change
      if(allActivity != null) {
        // Cache cover images
        var cacheDir = await getExternalCacheDirectories();
        String path = cacheDir.first.path;
        var dio = Dio();
        for(Activity activity in allActivity) {
          activity.activityType = activityType;
          if(activity.mediaUrlAll != null)
            activity.listMedia = getListMediaOfActivity(activity);
          // Cache cover images
          activity.cachePathCoverImg = await Tool.cacheActivity(activity, path, dio);
        }
      }
    }
    setState(ViewState.Idle);
    notifyListeners();
  }

  static List<Media> getListMediaOfActivity(Activity activity) {
    // For multiple media
    // aa.mp4;bb.mp4  => list[aa.mp4, bb.mp4] bolgoh
    List<String> listUrlString = activity.mediaUrlAll.split(";");
    List<String> listUrlTypeString = activity.mediaUrlAllMeta.split(";");
    List<Media> listMedia = new List<Media>();
    for(int index=0; index<listUrlString.length; index++) {
      Media media = new Media(url: listUrlString[index], type: listUrlTypeString[index]);
      listMedia.add(media);
    }
    return listMedia;
  }
}