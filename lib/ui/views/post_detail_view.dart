import 'package:education/core/classes/post.dart';
import 'package:education/core/classes/user.dart';
import 'package:education/core/services/api.dart';
import 'package:education/core/viewmodels/activity_instruction_model.dart';
import 'package:education/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class PostDetailView extends StatefulWidget {
  final Post post;

  PostDetailView({@required this.post});

  @override
  _PostDetailViewState createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
  _PostDetailViewState({Key key});

  VideoPlayerController videoController;
  Future<void> initializeVideoPlayer;

  @override
  void initState() {
    super.initState();
    getPostInstruction();
  }

  @override
  void dispose() {
    if(videoController != null)
      videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ActivityInstructionModel>(
      builder: (context, model, child) => WillPopScope(
        onWillPop: () {
          if (videoController != null && videoController.value.isPlaying) {
            videoController.pause();
          }
          return new Future.value(true);
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: model.state == ViewState.Busy
                ? Container(child: Center(child: CircularProgressIndicator()))
                : ListView(children: <Widget>[
                    // NAME, INSTRUCTION
                    Container(
                      height: 150,
                      padding: EdgeInsets.fromLTRB(20, 80, 20, 0),
                      child: Row(
                              children: [
                                Icon(Icons.fiber_smart_record, color: Colors.white, size: 25),
                                SizedBox(width: 10),
                                Text(widget.post.activity.name,
                                      style: GoogleFonts.kurale(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1.3)),
                              ],
                            ),
                    ),
                    // Video instruction
                    Container(
                      height: 470,
                      child: Hero(
                          tag: 'diy_' + widget.post.activity.id,
                          child: widget.post.uploadMediaType == 'image'
                            ?
                            // Image
                            Image.network(widget.post.mediaDownloadUrl, fit: BoxFit.fitWidth)
                            :
                            // Video instruction
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (videoController
                                        .value.isPlaying)
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
                                          color: Colors.blue[100]
                                              .withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(3,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        FutureBuilder(
                                          future:
                                              initializeVideoPlayer,
                                          builder:
                                              (context, snapshot) {
                                            if (snapshot
                                                    .connectionState ==
                                                ConnectionState
                                                    .done) {
                                              return VideoPlayer(
                                                  videoController);
                                            } else {
                                              return Center(
                                                child: Image.asset(
                                                    'lib/ui/images/loading.gif'),
                                              );
                                            }
                                          },
                                        ),
                                        // Play button
                                        videoController == null ||
                                                videoController
                                                    .value.isPlaying
                                            ? Text('')
                                            : Center(
                                                child: Icon(
                                                Icons
                                                    .play_circle_filled,
                                                color: Colors.white,
                                                size: 60,
                                              )),
                                      ],
                                    )),
                              ),
                            ),
                    ),
                    // LIKE
                    Container(
                      height: 70,
                      child: GestureDetector(
                        onTap: () {
                          if(widget.post.isUserLiked) {
                            dislikePost(widget.post);
                          } else {
                            likePost(widget.post);
                          }
                        },
                        child: Center(
                          child: Container(
                          width: 70,
                          height: 60,
                          child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  widget.post.isUserLiked ? Image.asset('lib/ui/images/icon_love_liked.png', height: 25)
                                      : Image.asset('lib/ui/images/icon_love.png', height: 20),
                                  SizedBox(width: 5),
                                  Text(widget.post.likeCount == null ? '0' : widget.post.likeCount.toString(), style: GoogleFonts.kurale(color: Colors.white, fontSize: 19)),
                                ],
                              ),
                        )),
                      ),
                    ),
                    // Bottom navigation
                  ]),
          ),
        ),
      ),
    );
  }

  void getPostInstruction() async {
    try {
      if (widget.post.uploadMediaType == 'video') {
        setState(() {
          videoController = VideoPlayerController.network(widget.post.mediaDownloadUrl);
          initializeVideoPlayer = videoController.initialize();
          videoController.setLooping(true);
          videoController.setVolume(4.0);
        });
      }
    } catch (ex) {
      print('error on loadPostVideo: ' + ex.toString());
    }
  }

  void likePost(Post post) {
    setState(() {
      post.isUserLiked = true;
      post.likeCount = post.likeCount ?? 0;
      post.likeCount++;
      final Api _api = locator<Api>();
      _api.likePost(post, Provider.of<User>(context).id);
    });
  }

  void dislikePost(Post post) {
    setState(() {
      post.isUserLiked = false;
      post.likeCount--;
      final Api _api = locator<Api>();
      _api.dislikePost(post, Provider.of<User>(context).id);
    });
  }
}
