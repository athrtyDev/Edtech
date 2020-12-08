import 'package:cached_network_image/cached_network_image.dart';
import 'package:education/core/classes/post.dart';
import 'package:education/core/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flutter/foundation.dart';
import 'package:education/core/viewmodels/profile_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                                floating: false,
                              ),
                              SliverFillRemaining(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: model.listUserAllPosts == null ? Center(child: Image.asset('lib/ui/images/no_post.png', height: 350)) :
                                  GridView.count(
                                    controller: scrollViewController,
                                    crossAxisCount: 2,
                                    //childAspectRatio: 1,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    crossAxisSpacing: 6,
                                    mainAxisSpacing: 6,
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
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius.all(Radius.circular(13)),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                        child: Container(
                                                            width: (MediaQuery.of(context).size.width - 6) / 2,
                                                            child: post.coverDownloadUrl != null
                                                                ? ClipRRect(
                                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
                                                                    child: CachedNetworkImage(
                                                                      imageUrl: post.coverDownloadUrl,
                                                                      fit: BoxFit.cover,
                                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                                    ),
                                                                  )
                                                                : Center(child: Icon(Icons.broken_image, size: 70, color: Colors.grey,))
                                                        )),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(5, 2, 0, 2),
                                                          child: Container(
                                                              child: Text(post.activity.name + ' ' ,
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
                                                            child: Center(child: Text(post.activity.activityType == 'diy' ? 'Бүтээл' : (post.activity.activityType == 'discover' ? 'Өөрийгөө нээ' : (post.activity.activityType == 'dance' ? 'Бүжиг' : '')),
                                                                style: GoogleFonts.kurale(color: Colors.white, fontSize: 11)))),
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
                                                            Text(post.likeCount == null ? '0' : post.likeCount.toString(), style: GoogleFonts.kurale(color: Colors.black, fontSize: 16)),
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
              child: GestureDetector(
                onTap: () async{
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  await preferences.clear();
                  print('SharedPreferences cleared');
                },
                child: Text('Сайн уу, ' + _loggedUser.name, style: GoogleFonts.kurale(fontSize: 18, color: Colors.black)),
              )
            ),
            Positioned(
              top: 55,
              left: 30,
              child: Text('Бүтээлүүд', style: GoogleFonts.kurale(color: Colors.black, fontSize: 16)),
            ),
            Positioned(
              top: 75,
              left: 63,
              child: Text(_loggedUser.postTotal.toString(), style: GoogleFonts.kurale(color: Color(0xff36c1c8), fontWeight: FontWeight.bold, fontSize: 24)),
            ),
            Positioned(
              top: 55,
              left: 170,
              child: Text('Ур чадвар', style: GoogleFonts.kurale(color: Colors.black, fontSize: 16)),
            ),
            Positioned(
              top: 75,
              left: 190,
              child: Text('+' + _loggedUser.skillTotal.toString(), style: GoogleFonts.kurale(color: Color(0xff36c1c8), fontWeight: FontWeight.bold, fontSize: 24)),
            ),
            Positioned(
              top: 55,
              left: 325,
              child: Text('Like', style: GoogleFonts.kurale(color: Colors.black, fontSize: 16)),
            ),
            Positioned(
              top: 75,
              left: 333,
              child: Text(_loggedUser.likeTotal.toString(), style: GoogleFonts.kurale(color: Color(0xff36c1c8), fontWeight: FontWeight.bold, fontSize: 24)),
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