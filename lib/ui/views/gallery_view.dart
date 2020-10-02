import 'package:education/core/classes/constant.dart';
import 'package:education/core/classes/post.dart';
import 'package:education/core/viewmodels/gallery_model.dart';
import 'package:flutter/material.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flutter/foundation.dart';

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
                  backgroundColor: Colors.white,
                  body: SafeArea(
                    child: model.state == ViewState.Busy
                        ? Container(child: Center(child: CircularProgressIndicator()))
                        : Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                  child: model.listAllPosts == null ? Center(child: Image.asset('lib/ui/images/no_post.png', height: 350)) :
                                  GridView.count(
                                    controller: scrollViewController,
                                    crossAxisCount: 2,
                                    //childAspectRatio: 1,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    crossAxisSpacing: 6.0,
                                    mainAxisSpacing: 8.0,
                                    children: model.listAllPosts.map((Post post) {
                                      return Hero(
                                        tag: 'activity_' + post.postId,
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                //Navigator.pushNamed(context, '/activity_instruction', arguments: activity);
                                              });
                                            },
                                            child: Stack(children: [
                                              Container(
                                                color: Colors.white,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(5, 10, 0, 5),
                                                          child: Container(
                                                              child: Text(post.userName,
                                                                  style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600))),
                                                        )
                                                      ],
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                            width: (MediaQuery.of(context).size.width - 6) / 2,
                                                            child: post.uploadMediaType == 'image'
                                                                ? (post.mediaDownloadUrl != null
                                                                ? Image.network(post.mediaDownloadUrl, fit: BoxFit.cover)
                                                                : Center(child: Icon(Icons.error, size: 20))
                                                            )
                                                                : (post.coverDownloadUrl != null
                                                                ? Image.network(post.coverDownloadUrl, fit: BoxFit.cover)
                                                                : Center(child: Icon(Icons.broken_image, size: 70, color: Colors.grey,)))
                                                        )),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(5, 2, 0, 2),
                                                          child: Container(
                                                              child: Text(post.activity.name, style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600))),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(20))),
                                                            margin: EdgeInsets.fromLTRB(5, 2, 5, 4),
                                                            padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                                                            //width: 40,
                                                            height: 25,
                                                            child: Center(child: Text(post.activity.activityType == 'diy' ? 'Бүтээл' : (post.activity.activityType == 'discover' ? 'Өөрийгөө нээ' : (post.activity.activityType == 'dance' ? 'Бүжиг' : '')),
                                                                style: TextStyle(color: Colors.white, fontSize: 11)))),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Gallery count round
                                              Positioned(
                                                right: 5,
                                                bottom: 15,
                                                child: Container(
                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
                                                  width: 35,
                                                  height: 20,
                                                  child: Center(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Image.asset('lib/ui/images/icon_love.png', height: 15),
                                                          SizedBox(width: 5),
                                                          Text(post.likeCount.toString(), style: TextStyle(color: Colors.black, fontSize: 11)),
                                                        ],
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ])),
                                      );
                                    }).toList(),
                                  ),
                                ),
                ),
              ),
            );
  }
}