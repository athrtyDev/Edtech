import 'package:education/core/classes/activity.dart';
import 'package:education/core/classes/post.dart';
import 'package:education/core/classes/user.dart';
import 'package:education/core/viewmodels/activity_instruction_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ActivityInstructionView extends StatefulWidget {
  final Activity activity;

  ActivityInstructionView({@required this.activity});

  @override
  _ActivityInstructionViewState createState() => _ActivityInstructionViewState();
}

class _ActivityInstructionViewState extends State<ActivityInstructionView> {
  _ActivityInstructionViewState({Key key});

  VideoPlayerController videoController;
  Future<void> initializeVideoPlayer;

  @override
  void initState() {
    super.initState();
    getDiyInstruction();
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ActivityInstructionModel>(
      builder: (context, model, child) => WillPopScope(
        onWillPop: () {
          if (videoController.value.isPlaying) {
            videoController.pause();
          }
          return new Future.value(true);
        },
        child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              body: model.state == ViewState.Busy
                  ? Container(child: Center(child: CircularProgressIndicator()))
                  : Column(children: <Widget>[
                      // NAME, INSTRUCTION
                      Container(
                        height: 70,
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(widget.activity.name,
                                style: GoogleFonts.kurale(fontSize: 20, color: Color(0xff36c1c8), fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                          ],
                        )

                      ),
                      Container(
                        height: 5,
                        color: Colors.grey[200],
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Даалгавар:',
                                  style: GoogleFonts.kurale(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
                              SizedBox(height: 5),
                              Text(widget.activity.instruction,
                                  style: GoogleFonts.kurale(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.5)),
                            ],
                          )
                        )
                      ),
                      // Video instruction
                      Container(
                        height: 400,
                        child: Hero(
                            tag: 'diy_' + widget.activity.id,
                            child: Container(
                                child: Column(
                              children: [
                                // Video instruction
                                Expanded(
                                    child: GestureDetector(
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
                                              if (snapshot.connectionState == ConnectionState.done) {
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
                                )),
                              ],
                            ))),
                      ),
                      // TYPE, DIFFICULTY
                      Expanded(
                        flex: 1,
                        child: Container(
                          //height: 120,
                          child: Container(
                            child: Column(
                              children: [
                                // DIY INFO
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // TYPE, XP points
                                      Container(
                                          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(10))),
                                          padding: EdgeInsets.fromLTRB(5, 10, 7, 10),
                                          child: Container(
                                              child: Row(
                                            children: [
                                              Image.asset("lib/ui/images/icon_do_it.png", height: 25),
                                              Column(
                                                children: [
                                                  /*Text(widget.activity.activityType == 'diy' ? 'Бүтээл' : (widget.activity.activityType == 'discover' ? 'Өөрийгөө нээ' : (widget.activity.activityType == 'dance' ? 'Бүжиг' : '')),
                                                      style: GoogleFonts.kurale(color: Colors.black45)),*/
                                                  Container(
                                                    padding: EdgeInsets.fromLTRB(5, 4, 0, 4),
                                                    decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(10))),
                                                    child: Text('+' + widget.activity.skill.toString() + ' оноо', style: GoogleFonts.kurale(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w600)),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ))),
                                      SizedBox(width: 25),
                                      // DIFFICULTY LEVEL
                                      Container(
                                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(10))),
                                        padding: EdgeInsets.fromLTRB(5, 10, 7, 10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(0, 0, 5, 3),
                                              child: widget.activity.difficulty == 'easy' ? Image.asset('lib/ui/images/icon_easy.png', height: 25)
                                                  : (widget.activity.difficulty == 'medium' ? Image.asset('lib/ui/images/icon_medium.png', height: 25)
                                                  : (widget.activity.difficulty == 'hard' ? Image.asset('lib/ui/images/icon_hard.png', height: 25) : Text(''))),
                                            ),
                                            Text(widget.activity.difficulty == 'easy' ? 'Амархан'
                                                : (widget.activity.difficulty == 'medium' ? 'Дунд зэрэг'
                                                : (widget.activity.difficulty == 'hard' ? 'Хэцүү' : Text(''))),
                                                style: GoogleFonts.kurale(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w600))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Bottom navigation
                    ]),
              bottomNavigationBar: Container(
                height: 80,
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Color(0xff36c1c8),
                  elevation: 4.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: Colors.white, size: 23),
                      SizedBox(width: 8),
                      Text('Бүтээлээ оруулах', style: GoogleFonts.kurale(fontSize: 16, color: Colors.white)),
                    ],
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => AlertDialog(
                        elevation: 24,
                        insetPadding: EdgeInsets.all(0),
                        contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        actionsPadding: EdgeInsets.all(0),
                        buttonPadding: EdgeInsets.all(0),
                        titlePadding: EdgeInsets.all(0),
                        backgroundColor: Colors.grey[300],
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Post post = new Post();
                                post.uploadMediaType = 'image';
                                post.activity = widget.activity;
                                post.user = Provider.of<User>(context);
                                Navigator.pushNamed(context, '/publish', arguments: post);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Colors.green.withOpacity(0.9),
                                ),
                                width: 110,
                                height: 60,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.photo, color: Colors.white, size: 35),
                                      SizedBox(width: 5),
                                      Text('Зураг', style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            GestureDetector(
                              onTap: () {
                                Post post = new Post();
                                post.uploadMediaType = 'video';
                                post.activity = widget.activity;
                                post.user = Provider.of<User>(context);
                                Navigator.pushNamed(context, '/publish', arguments: post);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Colors.orange.withOpacity(0.9),
                                ),
                                width: 110,
                                height: 60,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.videocam, color: Colors.white, size: 35),
                                      SizedBox(width: 5),
                                      Text('Бичлэг', style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )),
        ),
      ),
    );
  }

  void getDiyInstruction() async {
    try {
      //StorageReference reference = FirebaseStorage.instance.ref().child('activity_diy/' + widget.activity.id + '/intro.mp4');
      //widget.activity.introVideoStr = await reference.getDownloadURL();
      setState(() {
        videoController = VideoPlayerController.network(widget.activity.mediaUrl);
        initializeVideoPlayer = videoController.initialize();
        videoController.setLooping(true);
        videoController.setVolume(4.0);
      });
    } catch (ex) {
      print('error on loadInstructions: ' + ex.toString());
    }
  }
}
