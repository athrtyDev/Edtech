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
                  backgroundColor: Colors.white,
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
                                    crossAxisSpacing: 6.0,
                                    mainAxisSpacing: 8.0,
                                    children: model.listUserAllPosts.map((Post post) {
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
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 0, 10, 3),
                                                          child: post.activity.difficulty == 'easy' ? Image.asset('lib/ui/images/icon_easy.png', height: 20)
                                                              : (post.activity.difficulty == 'medium' ? Image.asset('lib/ui/images/icon_medium.png', height: 20)
                                                              : (post.activity.difficulty == 'easy' ? Image.asset('lib/ui/images/icon_medium.png', height: 20) : Text(''))),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Gallery count round
                                              Positioned(
                                                right: 5,
                                                top: 5,
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
  double get maxExtent => 140.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 140,
      //color: Colors.deepOrangeAccent,
      child: Stack(
          children: [
            // NAME
            Positioned(
              top: 10,
              left: 50,
              child: Text(_loggedUser.name, style: TextStyle(fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold)),
            ),
            Positioned(
              top: 60,
              left: 50,
              child: Text('Бүтээлүүд', style: TextStyle(color: Colors.blue.withOpacity(0.6), fontWeight: FontWeight.bold, fontSize: 17)),
            ),
            Positioned(
              top: 85,
              left: 90,
              child: Text(_loggedUser.postTotal.toString(), style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 25)),
            ),
            Positioned(
              top: 60,
              left: 170,
              child: Text('Ур чадвар', style: TextStyle(color: Colors.blue.withOpacity(0.6), fontWeight: FontWeight.bold, fontSize: 17)),
            ),
            Positioned(
              top: 85,
              left: 190,
              child: Text('+' + _loggedUser.skillTotal.toString(), style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 25)),
            ),
            Positioned(
              top: 60,
              left: 300,
              child: Text('Like', style: TextStyle(color: Colors.blue.withOpacity(0.6), fontWeight: FontWeight.bold, fontSize: 17)),
            ),
            Positioned(
              top: 85,
              left: 310,
              child: Text(_loggedUser.likeTotal.toString(), style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 25)),
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