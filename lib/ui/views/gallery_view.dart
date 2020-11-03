import 'package:education/core/classes/post.dart';
import 'package:education/core/viewmodels/gallery_model.dart';
import 'package:flutter/material.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';

class GalleryView extends StatefulWidget {
  GalleryView({Key key}) : super(key: key);

  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  _GalleryViewState({Key key});

  ScrollController scrollViewController;

  @override
  void initState() {
    super.initState();
    scrollViewController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<GalleryModel>(
      onModelReady: (model) => model.loadPostsByUser(context),
      builder: (context, model, child) => Scaffold(
        backgroundColor: model.listAllPosts == null ? Colors.white : Colors.grey[300],
        body: SafeArea(
          child: model.state == ViewState.Busy
              ? Container(child: Center(child: CircularProgressIndicator()))
              : Column(
                  children: [
                  Container(
                    height: 60,
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      children: [
                        Icon(Icons.bubble_chart, color: Color(0xff36c1c8), size: 23),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text('Бидний уран бүтээлүүд', style: GoogleFonts.kurale(fontSize: 19, color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: model.listAllPosts == null
                          ? Center(child: Image.asset('lib/ui/images/no_post.png', height: 350))
                          : GridView.count(
                              controller: scrollViewController,
                              crossAxisCount: 2,
                              //childAspectRatio: 1,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              crossAxisSpacing: 3.0,
                              mainAxisSpacing: 6.0,
                              children: model.listAllPosts.map((Post post) {
                                return Hero(
                                  tag: 'activity_' + post.postId,
                                  child: GestureDetector(
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
                                                      width: (MediaQuery.of(context).size.width - 6) / 2,
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
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.fromLTRB(5, 2, 0, 2),
                                                    child: Container(
                                                        child: Text(post.activity.name,
                                                            style: GoogleFonts.kurale(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500))),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                      decoration: BoxDecoration(color:
                                                        post.activity.activityType == 'diy'
                                                        ? Colors.blue.withOpacity(0.7) : (post.activity.activityType == 'discover'
                                                        ? Colors.orange.withOpacity(0.7) : (post.activity.activityType == 'dance'
                                                        ? Colors.red.withOpacity(0.7) : Colors.blue.withOpacity(0.6))),
                                                      borderRadius: BorderRadius.all(Radius.circular(20))),
                                                      margin: EdgeInsets.fromLTRB(5, 2, 5, 4),
                                                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                                                      //width: 40,
                                                      height: 25,
                                                      child: Center(
                                                          child: Text(
                                                              post.activity.activityType == 'diy'
                                                                  ? 'Бүтээл'
                                                                  : (post.activity.activityType == 'discover'
                                                                      ? 'Өөрийгөө нээ'
                                                                      : (post.activity.activityType == 'dance' ? 'Бүжиг' : '')),
                                                              style: GoogleFonts.kurale(color: Colors.white, fontSize: 11)))),
                                                ],
                                              ),
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
                                          ),
                                        ),
                                        // LIKE
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                                if(post.isUserLiked) {
                                                  model.dislikePost(post);
                                                } else {
                                                  model.likePost(post);
                                                }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20)),
                                              ),
                                              width: 57,
                                              height: 48,
                                              child: Center(
                                                  child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  post.isUserLiked ? Image.asset('lib/ui/images/icon_love_liked.png', height: 17)
                                                  : Image.asset('lib/ui/images/icon_love.png', height: 13),
                                                  SizedBox(width: 4),
                                                  Text(post.likeCount == null ? '0' : post.likeCount.toString(), style: GoogleFonts.kurale(color: Colors.black54, fontSize: 16)),
                                                ],
                                              )),
                                            ),
                                          ),
                                        ),
                                      ])),
                                );
                              }).toList(),
                            ),
                    ),
                  ),
              ]
          ),
        ),
      ),
    );
  }
}
