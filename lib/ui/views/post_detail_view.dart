import 'dart:io';

import 'package:education/core/classes/comment.dart';
import 'package:education/core/classes/post.dart';
import 'package:education/core/classes/user.dart';
import 'package:education/core/services/api.dart';
import 'package:education/core/services/tool.dart';
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
  List<Comment> listComment;
  final TextEditingController _commentInput = TextEditingController();
  FocusNode _focusCommentInput = new FocusNode();
  ViewState state;

  @override
  void initState() {
    state = ViewState.Busy;
    super.initState();
    getPostInstruction();
    getPostComments();
  }

  @override
  void dispose() {
    if (videoController != null) videoController.dispose();
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
            body: Center(
              child: state == ViewState.Busy
                  ? Container(child: Center(child: CircularProgressIndicator()))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                      // NAME, INSTRUCTION
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
                        child: Row(
                          children: [
                            Icon(Icons.scatter_plot, color: Colors.white, size: 25),
                            SizedBox(width: 10),
                            Text(widget.post.activity.name,
                                style: GoogleFonts.kurale(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500, letterSpacing: 1.3)),
                          ],
                        ),
                      ),
                      // Video instruction
                      Container(
                        height: (widget.post.uploadMediaType == 'video' && videoController.value.size != null ) ?
                        ((MediaQuery.of(context).size.width * videoController.value.size.height)/videoController.value.size.width)
                            : null,
                        width: widget.post.uploadMediaType == 'video' ? MediaQuery.of(context).size.width : null,
                        child: widget.post.uploadMediaType == 'image'
                              ?
                              // Image
                              Image.file(File(widget.post.cacheMediaPath), fit: BoxFit.fitWidth)
                              :
                              // Video instruction
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (videoController.value.isPlaying)
                                        videoController.pause();
                                      else
                                        videoController.play();
                                    });
                                  },
                                  child: Stack(
                                        children: [
                                          VideoPlayer(videoController),
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
                                      ),
                                ),
                      ),
                      // like and comment BUTTON
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // LIKE
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width / 2 - 0.5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _focusCommentInput.unfocus();
                                  if (widget.post.isUserLiked) {
                                    widget.post.dislikePost(widget.post, Provider.of<User>(context).id);
                                  } else {
                                    widget.post.likePost(widget.post, Provider.of<User>(context).id);
                                  }
                                });
                              },
                              child: Container(
                                height: 40,
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    widget.post.isUserLiked
                                        ? Image.asset('lib/ui/images/icon_love_liked.png', height: 20)
                                        : Image.asset('lib/ui/images/icon_love.png', height: 14),
                                    SizedBox(width: 5),
                                    Text(widget.post.likeCount == null ? '0' : widget.post.likeCount.toString(),
                                        style: GoogleFonts.kurale(color: Colors.white, fontSize: 19)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(width: 0.3, color: Colors.grey[200], height: 30),
                          // COMMENT
                          Container(
                            height: 43,
                            width: MediaQuery.of(context).size.width / 2 - 0.5,
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(_focusCommentInput);
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.insert_comment, size: 20, color: Colors.white),
                                    SizedBox(width: 5),
                                    Text('Сэтгэгдэл', style: GoogleFonts.kurale(color: Colors.white, fontSize: 16)),
                                    SizedBox(width: 5),
                                    Text((widget.post.listComment == null || widget.post.listComment.isEmpty) ? '0' : widget.post.listComment.length.toString(),
                                        style: GoogleFonts.kurale(color: Colors.white, fontSize: 16)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(thickness: 0.3, color: Colors.grey[200], height: 0),
                      // LIST COMMENTS
                      listComment == null || listComment.isEmpty ? Container() :
                      Column(
                        children: List.generate(listComment.length, (index) {
                          return ListTile(
                            leading: Icon(Icons.account_circle, color: Colors.white, size: 34),
                            title: Row(
                              children: [
                                listComment[index].userType == 'teacher' ? Icon(Icons.school, color: Colors.orange, size: 18) : Text(''),
                                listComment[index].userType == 'teacher' ? SizedBox(width: 5) : Text(''),
                                Text(listComment[index].userName + (listComment[index].userType == 'teacher' ? ' [Silly House-н багш]' : ''),
                                    style: GoogleFonts.kurale(fontSize: 14, fontWeight: FontWeight.w600,
                                        color: listComment[index].userType == 'teacher' ? Colors.orange : Colors.white)),
                              ],
                            ),
                            subtitle: Text(listComment[index].comment, style: GoogleFonts.kurale(fontSize: 13, color: Colors.white)),
                            //trailing: Icon(Icons.menu, color: Colors.white),
                          );
                        }),
                      ),
                      // ADD COMMENT TEXTFIELD
                      Container(
                        child: TextField(
                          controller: _commentInput,
                          focusNode: _focusCommentInput,
                          keyboardType: TextInputType.text,
                          style: GoogleFonts.kurale(color: Colors.grey[600]),
                          onSubmitted: (newComment) async{
                            _focusCommentInput.unfocus();
                            _commentInput.text = '';
                            await postComment(newComment);
                            getPostComments();
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(borderSide: new BorderSide(color: Colors.transparent)),
                              focusedBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.transparent)),
                              disabledBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.transparent)),
                              enabledBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.transparent)),
                              isDense: true,
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                              fillColor: Colors.transparent,
                              filled: true,
                              hintText: _focusCommentInput.hasFocus ? "Сэтгэгдэл бичих" : "",
                              hintStyle: GoogleFonts.kurale(color: Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 15.0)),
                        ),
                      )
                      // Bottom navigation
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getPostInstruction() async {
    try {
      setState(() {
        state = ViewState.Busy;
      });
      // cache post's media
      widget.post.cacheMediaPath = await Tool.cachePost(widget.post);
      // initialize video
      if (widget.post.uploadMediaType == 'video') {
        if(widget.post.cacheMediaPath == null)
          videoController = VideoPlayerController.network(widget.post.mediaDownloadUrl);
        else
          videoController = VideoPlayerController.file(File(widget.post.cacheMediaPath));
        await videoController.initialize();
        videoController.setLooping(true);
        videoController.setVolume(4.0);
      }
      setState(() {
        state = ViewState.Idle;
      });
    } catch (ex) {
      print('error on loadPostVideo: ' + ex.toString());
    }
  }

  void getPostComments() async {
    final Api _api = locator<Api>();
    listComment = await _api.getListComment(widget.post.postId);
    setState(() {});
  }

  Future<void> postComment(String commentMessage) async{
    final Api _api = locator<Api>();
    User user = Provider.of<User>(context);
    Comment comment = new Comment();
    comment.postId = widget.post.postId;
    comment.userId = user.id;
    comment.userName = user.name;
    comment.userProfilePic = user.profile_pic;
    comment.userType = user.type;
    comment.comment = commentMessage;
    comment.date = DateTime.now();
    await _api.postComment(comment);
    if(widget.post.listComment == null)
      widget.post.listComment = new List<Comment>();
    widget.post.listComment.add(comment);

    setState(() {});
  }
}
