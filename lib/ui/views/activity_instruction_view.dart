import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:education/core/classes/activity.dart';
import 'package:education/core/classes/like.dart';
import 'package:education/core/classes/media.dart';
import 'package:education/core/classes/post.dart';
import 'package:education/core/classes/user.dart';
import 'package:education/core/services/api.dart';
import 'package:education/core/services/tool.dart';
import 'package:education/core/viewmodels/activity_instruction_model.dart';
import 'package:education/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
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

  List<Post> relatedPosts;
  final Api _api = locator<Api>();
  ScrollController scrollViewController;
  CarouselSlider carouselSlider;
  int _carouselIndex = 0;
  bool mediaDownloadingState = true;
  bool postDownloadingState = true;

  @override
  void initState() {
    super.initState();
    scrollViewController = ScrollController();
    getDiyInstruction();
  }

  @override
  void dispose() {
    if(widget.activity.listMedia != null && widget.activity.listMedia.isNotEmpty) {
      for(Media media in widget.activity.listMedia) {
        if(media.type == 'video')
          media.videoController.dispose();
      }
    }
    super.dispose();
    scrollViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ActivityInstructionModel>(
      onModelReady: (model) => getPosts(context),
        builder: (context, model, child) => WillPopScope(
        onWillPop: () {
          if(widget.activity.listMedia != null && widget.activity.listMedia.isNotEmpty) {
            for(Media media in widget.activity.listMedia) {
              if(media.type == 'video' && media.videoController.value.isPlaying)
                media.videoController.pause();
            }
          }
          return new Future.value(true);
        },
        child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              body: mediaDownloadingState
                  ? Container(child: Center(child: CircularProgressIndicator()))
                  : SingleChildScrollView(
                      child: Column(children: <Widget>[
                        // NAME
                        Container(
                          height: 65,
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
                        // INSTRUCTION
                        Container(
                          height: 120,
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
                        ),
                        // MEDIA
                        /*//VimeoPlayer(id: '484150659', autoPlay: false),
                        Container(
                          height: 400,
                          child: YouVimPlayer('vimeo','484150659'),
                        ),*/
                        Container(
                          height: widget.activity.listMedia.length == 1 ? 400 : 370,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // progress circles
                              widget.activity.listMedia.length == 1 ? Container() :
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(widget.activity.listMedia.length,(index){
                                  return Container(
                                    width: 10.0,
                                    height: 10.0,
                                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _carouselIndex == index ? Colors.green : Colors.grey[400],
                                    ),
                                  );
                                }),
                              ),
                              widget.activity.listMedia.length == 1 ? Container() :
                              SizedBox(
                                height: 10,
                              ),
                              /*FittedBox(
                                fit: BoxFit.fill,
                                child: VimeoPlayer(id: '484150659', autoPlay: false),
                              ),*/

                              carouselSlider = CarouselSlider(
                                height: widget.activity.listMedia.length == 1 ? 400 : 330,
                                initialPage: 0,
                                enlargeCenterPage: true,
                                autoPlay: false,
                                reverse: false,
                                enableInfiniteScroll: false,
                                autoPlayInterval: Duration(seconds: 2),
                                autoPlayAnimationDuration: Duration(milliseconds: 2000),
                                pauseAutoPlayOnTouch: Duration(seconds: 10),
                                scrollDirection: widget.activity.listMedia.length == 1 ? Axis.vertical : Axis.horizontal,
                                onPageChanged: (index) {
                                  setState(() {
                                    _carouselIndex = index;
                                    if(widget.activity.listMedia != null && widget.activity.listMedia.isNotEmpty) {
                                      for(Media media in widget.activity.listMedia) {
                                        if(media.type == 'video' && media.videoController.value.isPlaying)
                                          media.videoController.pause();
                                      }
                                    }
                                  });
                                },
                                items: widget.activity.listMedia.map((media) {
                                  return Builder(
                                    builder: (BuildContext mediaContext) {
                                      return Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                                        child:
                                        media.type == 'video' ?
                                        // VIDEO
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (media.videoController.value.isPlaying)
                                                media.videoController.pause();
                                              else
                                                media.videoController.play();
                                            });
                                          },
                                          child: Stack(
                                            children: [
                                              VideoPlayer(media.videoController),
                                              // Play button
                                              media.videoController == null || media.videoController.value.isPlaying
                                                  ? Text('')
                                                  : Center(
                                                      child: Icon(Icons.play_circle_filled, color: Colors.white, size: 60),
                                                    ),
                                            ],
                                          ),
                                        )
                                        :
                                        // IMAGE
                                        media.cachePath == null ?
                                          CachedNetworkImage(
                                            imageUrl: media.url,
                                            fit: BoxFit.fill,
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          )
                                        :
                                          Image.file(File(media.cachePath), fit: BoxFit.fill)
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        // TYPE, DIFFICULTY
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          height: 72,
                          child: Container(
                            child: Column(
                              children: [
                                // DIY INFO
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
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
                        relatedPosts == null ? Container() :
                        Container(
                          height: 5,
                          color: Colors.grey[200],
                        ),
                        // Related posts
                        relatedPosts == null ? Container() :
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
                          alignment: Alignment.centerLeft,
                          child: Text('Бусад хүүхдийн бүтээлүүд',
                              style: GoogleFonts.kurale(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
                        ),
                        relatedPosts == null ? Container() :
                        Container(
                          height: 230,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(4),
                          child: GridView.count(
                            controller: scrollViewController,
                            crossAxisCount: 1,
                            //childAspectRatio: 1,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            mainAxisSpacing: 5.0,
                            children: relatedPosts.map((Post post) {
                              return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        Navigator.pushNamed(context, '/post_detail', arguments: post).then((value) => setState(() {}));
                                      });
                                    },
                                    child: Stack(children: [
                                      // IMAGE, VIDEO
                                      Container(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Expanded(
                                                child: Container(
                                                    width: 230,
                                                    child: post.uploadMediaType == 'image'
                                                        ? (post.mediaDownloadUrl != null
                                                        ? Image.network(post.mediaDownloadUrl, fit: BoxFit.cover)
                                                        : Center(child: Icon(Icons.error, size: 20)))
                                                        : (post.coverDownloadUrl != null
                                                        ? Image.network(post.coverDownloadUrl, fit: BoxFit.cover)
                                                        : Center(
                                                        child: Icon(
                                                          Icons.ondemand_video,
                                                          size: 70,
                                                          color: Color(0xff36c1c8),
                                                        ))))),
                                          ],
                                        ),
                                      ),
                                      // POSTED USER
                                      Positioned(
                                          top: 5,
                                          right: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              border: Border.all(color: Colors.pink.withOpacity(0.7)),
                                            ),
                                            padding: EdgeInsets.all(2),
                                            //width: 40,
                                            height: 25,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                              ),
                                              padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.person, color: Colors.black54, size: 15),
                                                  SizedBox(width: 3),
                                                  Text(post.userName, style: GoogleFonts.kurale(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500)),
                                                ],
                                              ),
                                            ),
                                          )
                                      ),
                                    ]));
                            }).toList(),
                          ),
                        ),
                        // Bottom navigation
                      ]),
                    ),
              bottomNavigationBar: Container(
                height: 75,
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
                    if(widget.activity.listMedia != null && widget.activity.listMedia.isNotEmpty) {
                      for(Media media in widget.activity.listMedia) {
                        if(media.type == 'video' && media.videoController.value.isPlaying)
                          media.videoController.pause();
                      }
                    }

                    Post post = new Post();
                    //post.uploadMediaType = 'image';
                    post.activity = widget.activity;
                    post.user = Provider.of<User>(context);
                    post.pickedMedia = null;
                    Navigator.pushNamed(context, '/publish', arguments: post);
                  },
                ),
              )),
        ),
      ),
    );
  }

  void getDiyInstruction() async {
    try {
      setState(() {
        mediaDownloadingState = true;
      });
      var appDir = await getApplicationDocumentsDirectory();
      String fullPath = appDir.path + "/boo2.mp4'";
      if(widget.activity.listMedia != null && widget.activity.listMedia.isNotEmpty) {
        int mediaCount = 0;
        int videoCount = 0;
        var cacheDir = await getExternalCacheDirectories();
        String cachePath = cacheDir.first.path;
        var dio = Dio();
        for(Media media in widget.activity.listMedia) {
          // save to cache
          mediaCount++;
          media.cachePath = await Tool.cacheMedia(widget.activity, media, mediaCount, cachePath, dio);

          // IF video => initialize player
          if (media.type == 'video') {
            setState(() {
              videoCount++;
              //VideoPlayerController videoController = VideoPlayerController.network(media.url);
              VideoPlayerController videoController;
              if(media.cachePath == null)
                videoController = VideoPlayerController.network(media.url);
              else
                videoController = VideoPlayerController.file(File(media.cachePath));
              media.videoController = videoController;
              Future<void> initializeVideoPlayer = videoController.initialize();
              media.initializeVideoPlayer = initializeVideoPlayer;
              media.videoController.setLooping(true);
              media.videoController.setVolume(4.0);
              if (videoCount == 1 && widget.activity.autoPlay)
                media.videoController.play();
            });
          }
        }
      }
      setState(() {
        mediaDownloadingState = false;
      });
    } catch (ex) {
      print('error on loadInstructions: ' + ex.toString());
    }
  }

  void getPosts(BuildContext context) async{
    try {
      User loggedUser = Provider.of<User>(context);
      relatedPosts = await _api.getPostByActivity(widget.activity);
      List<Like> allLikes = await _api.getAllLikes();

      setState(() {
        if(relatedPosts != null && allLikes != null) {
          for (Like like in allLikes) {
            for (Post post in relatedPosts) {
              // Count every post's like
              if(like.postId == post.postId) {
                if(post.likeCount == null)
                  post.likeCount = 0;
                post.likeCount++;
              }
              // Check if logged user liked the post
              if(post.isUserLiked == null)
                post.isUserLiked = false;
              if(like.postId == post.postId && like.likedUserId == loggedUser.id) {
                post.isUserLiked = true;
              }
            }
          }
        }
      });
    } catch (ex) {
      print('error on getPost for selected activity: ' + ex.toString());
    }
  }
}
