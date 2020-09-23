import 'package:education/core/classes/constant.dart';
import 'package:education/core/classes/activity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/core/services/api.dart';
import 'package:education/core/viewmodels/base_model.dart';
import 'package:education/locator.dart';

class HomeModel extends BaseModel {
  final Api _api = locator<Api>();
  List<Activity> allActivity;
  ViewState loadVideoState;

  void initHomeView() {
    //getActivityList();
  }

  void getActivityList() async {
    setState(ViewState.Busy);
    if(allActivity == null) {
      allActivity = await _api.getAllActivity('diy');
      notifyListeners();
    }
    loadVideoState = ViewState.Idle;
    setState(ViewState.Idle);
  }
}