import 'dart:collection';
import 'dart:typed_data';
import 'package:education/core/classes/activity.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/core/services/api.dart';
import 'package:education/core/viewmodels/base_model.dart';
import 'package:education/locator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';

class ActivityInstructionModel extends BaseModel {

  void goToUpload() {
    //Navigator.pushNamed(context, '/publish', arguments: 'image');
  }

  //Diy selectedDiy;
  //VideoPlayerController videoController;
  //Future<void> initializeVideoPlayer;

  /*void getDiyInstruction(Diy diy) async {
    setState(ViewState.Busy);
    selectedDiy = diy;

    try {
      HashMap mapInstruction = new HashMap<String, Uint8List>();
      // Get Introduction video
      StorageReference reference = FirebaseStorage.instance.ref().child('activity_diy/' + selectedDiy.id + '/intro.mp4');
      selectedDiy.introVideoStr = await reference.getDownloadURL();
      videoController = VideoPlayerController.network(selectedDiy.introVideoStr);
      // For future usage. Video from asset:
      // videoController = VideoPlayerController.asset("lib/ui/videos/test.mp4");
      initializeVideoPlayer = videoController.initialize();
      videoController.setLooping(true);
      videoController.setVolume(4.0);

      // Get preparation image
      //reference = FirebaseStorage.instance.ref().child('activity_diy/' + selectedDiy.id + '/prepare.png');
      //selectedDiy.prepareImage = await reference.getData(Constant.firestore_file_max_size);

      //Get Instruction Steps
      *//*for (int i=0; i<selectedDiy.steps; i++) {
          StorageReference reference = FirebaseStorage.instance.ref().child('activity_diy/' + selectedDiy.id + '/intro.mp4');
          mapInstruction[selectedDiy.id] = await reference.getData(Constant.firestore_file_max_size);
      }
      selectedDiy.map = map;
      *//*
      notifyListeners();
    } catch(ex) {
      print('error on loadInstructions: ' + ex.toString());
    }

    notifyListeners();
    setState(ViewState.Idle);
  }*/
}