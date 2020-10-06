import 'package:education/core/classes/post.dart';
import 'package:education/core/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flutter/foundation.dart';
import 'package:education/core/viewmodels/profile_model.dart';

class ProfileView extends StatefulWidget {
  ProfileView({Key key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  _ProfileViewState({Key key});

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
    return BaseView<ProfileModel>(
        onModelReady: (model) => model.loadPostsByUser(context),
        builder: (context, model, child) => Scaffold(
                  backgroundColor: model.listUserAllPosts == null ? Colors.white : Colors.grey[300],
                  body: SafeArea(
                    child: model.state == ViewState.Busy
                        ? Container(child: Center(child: CircularProgressIndicator()))
                        :
                          CustomScrollView(
                            slivers: <Widget>[
                              SliverPersistentHeader(
                                delegate: _SliverAppBarDelegate(model.loggedUser),
                                pinned: false,
                                floating: true,
                              ),
                              SliverFillRemaining(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                  child: model.listUserAllPosts == null ? Center(child: Image.asset('lib/ui/images/no_post.png', height: 350)) :
                                  GridView.count(
                                    controller: scrollViewController,
                                    crossAxisCount: 2,
                                    //childAspectRatio: 1,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    crossAxisSpacing: 3.0,
                                    mainAxisSpacing: 6.0,
                                    children: model.listUserAllPosts.map((Post post) {
                                      return Hero(
                                        tag: 'activity_' + post.postId,
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                Navigator.pushNamed(context, '/post_detail', arguments: post).then((value) => setState(() {}));
                                              });
                                            },
                                            child: Stack(children: [
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
                                                              child: Text(post.activity.name + ' ' ,
                                                                  style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600))),
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
                                                            SizedBox(width: 5),
                                                            Text(post.likeCount == null ? '0' : post.likeCount.toString(), style: TextStyle(color: Colors.black, fontSize: 14)),
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
                              )
                            ]
                          ),
                ),
              ),
            );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._loggedUser);

  final User _loggedUser;

  @override
  double get minExtent => 50.0;

  @override
  double get maxExtent => 120.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 115,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Stack(
          children: [
            // NAME
            Positioned(
              top: 15,
              left: 30,
              child: Icon(Icons.bubble_chart, color: Color(0xff36c1c8), size: 25),
            ),
            Positioned(
              top: 17,
              left: 60,
              child: Text('Сайн уу, ' + _loggedUser.name, style: TextStyle(fontSize: 18, color: Colors.black45)),
            ),
            Positioned(
              top: 60,
              left: 30,
              child: Text('Бүтээлүүд', style: TextStyle(color: Colors.black45, fontSize: 14)),
            ),
            Positioned(
              top: 80,
              left: 57,
              child: Text(_loggedUser.postTotal.toString(), style: TextStyle(color: Color(0xff36c1c8), fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            Positioned(
              top: 60,
              left: 170,
              child: Text('Ур чадвар', style: TextStyle(color: Colors.black45, fontSize: 14)),
            ),
            Positioned(
              top: 80,
              left: 185,
              child: Text('+' + _loggedUser.skillTotal.toString(), style: TextStyle(color: Color(0xff36c1c8), fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            Positioned(
              top: 60,
              left: 325,
              child: Text('Like', style: TextStyle(color: Colors.black45, fontSize: 14)),
            ),
            Positioned(
              top: 80,
              left: 330,
              child: Text(_loggedUser.likeTotal.toString(), style: TextStyle(color: Color(0xff36c1c8), fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            // SKILLS
          ]),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}