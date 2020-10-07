import 'dart:io';
import 'package:education/core/classes/post.dart';
import 'package:flutter/material.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flutter/foundation.dart';
import 'package:education/core/viewmodels/publish_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class PublishView extends StatefulWidget {
  Post post;

  PublishView({@required this.post});

  @override
  _PublishViewState createState() => _PublishViewState();
}

class _PublishViewState extends State<PublishView> with SingleTickerProviderStateMixin {
  _PublishViewState({Key key});

  File selectedFile;
  VideoPlayerController videoController;
  Future<void> initializeVideoPlayer;

  @override
  void initState() {
    super.initState();
    openCameraOrGallery();
  }

  @override
  void dispose() {
    if (videoController != null) {
      videoController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<PublishModel>(
      builder: (context, model, child) => SafeArea(
        child: WillPopScope(
          onWillPop: () {
            // Prevent back navigation when uploading
            if(model.state == ViewState.Idle) {
              // Pause video before navigation
              if (videoController != null && videoController.value.isPlaying) {
                videoController.pause();
              }
              return new Future.value(true);
            } else {
              return new Future.value(false);
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(children: <Widget>[
                    // Media
                    Center(
                      child: Container(
                        height: 600,
                        child: widget.post.uploadMediaType == 'video'
                            ?
                            // Video
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (videoController.value.isPlaying)
                                      videoController.pause();
                                    else
                                      videoController.play();
                                  });
                                },
                                child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue[100].withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(3, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        FutureBuilder(
                                          future: initializeVideoPlayer,
                                          builder: (context, snapshot) {
                                            if (videoController != null && snapshot.connectionState == ConnectionState.done) {
                                              return VideoPlayer(videoController);
                                            } else {
                                              return Center(
                                                child: Image.asset('lib/ui/images/loading.gif'),
                                              );
                                            }
                                          },
                                        ),
                                        // Play button
                                        videoController == null || videoController.value.isPlaying
                                            ? Text('')
                                            : Center(
                                                child: Icon(
                                                Icons.play_circle_filled,
                                                color: Colors.white,
                                                size: 60,
                                              )),
                                      ],
                                    )),
                              )
                            :
                            // Image
                            selectedFile == null ? Center(child: Image.asset('lib/ui/images/loading.gif')) : Image.file(selectedFile),
                      ),
                    ),
                    // ACTION BUTTONS
                    Positioned(
                        bottom: 30,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: model.state == ViewState.Busy ?
                              Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(width: 10),
                                      Text("Бүтээлийг нь хуулж байна... Одоохон дууслаа.", style: GoogleFonts.kurale(fontSize: 14, color: Color(0xff36c1c8))),
                                    ],
                                  )
                              )
                              :
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: Icon(Icons.close, size: 60, color: Colors.red),
                                onTap: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil('/mainPage', (Route<dynamic> route) => false);
                                },
                              ),
                              SizedBox(width: 100),
                              GestureDetector(
                                child: Icon(Icons.check, size: 60, color: Colors.green),
                                onTap: () async {
                                  await model.uploadFile(widget.post, selectedFile);
                                  Navigator.of(context).pushNamedAndRemoveUntil('/mainPage', (Route<dynamic> route) => false);
                                },
                              ),
                            ],
                          ),
                        )),
                  ]),
          ),
        ),
      ),
    );
  }

  void openCameraOrGallery() async {
    final picker = ImagePicker();
    if (widget.post.uploadMediaType == 'image') {
      final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 30);
      setState(() {
        if (pickedFile != null) selectedFile = File(pickedFile.path);
      });
    } else if (widget.post.uploadMediaType == 'video') {
      final pickedFile = await picker.getVideo(source: ImageSource.gallery);
      if (pickedFile != null) selectedFile = File(pickedFile.path);
      setState(() {
        if (pickedFile != null) {
          selectedFile = File(pickedFile.path);
          videoController = VideoPlayerController.file(selectedFile);
          initializeVideoPlayer = videoController.initialize();
          videoController.setLooping(true);
          videoController.setVolume(4.0);
        }
      });
    }
  }
}
