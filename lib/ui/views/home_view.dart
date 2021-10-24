import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:education/core/classes/activity.dart';
import 'package:education/core/classes/post.dart';
import 'package:education/core/classes/user.dart';
import 'package:education/ui/views/post_detail_view.dart';
import 'package:education/ui/widgets/gallery_post_minimal_widget.dart';
import 'package:education/ui/widgets/gallery_post_widget.dart';
import 'package:flutter/material.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flutter/foundation.dart';
import 'package:education/core/viewmodels/home_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  _HomeViewState({Key key});

  ScrollController scrollViewController;
  ScrollController postViewController;
  ScrollController scrollBestPostController;

  @override
  void initState() {
    super.initState();
    scrollViewController = ScrollController();
    postViewController = ScrollController();
    scrollBestPostController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollViewController.dispose();
    postViewController.dispose();
    scrollBestPostController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      onModelReady: (model) => model.initHomeView(context),
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: model.state == ViewState.Busy
              ? Container(child: Center(child: CircularProgressIndicator()))
              : ListView(children: <Widget>[
                  Container(
                    height: 240,
                    child: Stack(children: [
                      // BACKGROUND CURVE
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          height: 220,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color(0xff36c1c8),
                            borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(30, 30), bottomRight: Radius.elliptical(30, 30)),
                          ),
                        ),
                      ),
                      // HELLO
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(20, 18, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.bubble_chart, size: 30, color: Colors.white),
                                SizedBox(width: 10),
                                // NAME
                                Flexible(
                                  child: Row(
                                    children: [
                                      Text('Сайн уу ',
                                          style:
                                              GoogleFonts.kurale(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 1)),
                                      Text(Provider.of<User>(context).name + ' !',
                                          style:
                                              GoogleFonts.kurale(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 1)),
                                    ],
                                  ),
                                ),
                                // NOTIFICATION
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/notification');
                                    },
                                    child: Container(
                                      height: 40,
                                      padding: EdgeInsets.fromLTRB(23, 5, 10, 0),
                                      color: Colors.transparent,
                                      child: SizedBox(
                                        width: 38,
                                        child: Stack(
                                          children: [
                                            Icon(Icons.notifications_active, size: 25, color: Colors.white),
                                            Positioned(
                                              left: 11,
                                              top: 0,
                                              child: Container(
                                                width: 15,
                                                height: 15,
                                                decoration: new BoxDecoration(
                                                  color: Color(0xffc83d36),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Text('0', style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              ],
                            )),
                      ),
                      // TODAY'S POSTER
                      Positioned(
                        top: 60,
                        left: 20,
                        child: GestureDetector(
                          onTap: () async {
                            print('aaaaaaaaaaaaa');
                            /*
                            var appDir = await getExternalCacheDirectories();
                            String fullPath = appDir.first.path + "/boo3.mp4'";
                            print('full path ${fullPath}');
                            var dio = Dio();
                            final imgUrl = "https://firebasestorage.googleapis.com/v0/b/education-69b9a.appspot.com/o/activity_diy%2F7%2Fintro.mp4?alt=media&token=3da7caf3-6140-479b-930f-d0ddd9002754";
                            Tool.download(dio, imgUrl, fullPath);
                            print('bbbbbbbbbbbbb');*/
                          },
                          child: Container(
                            height: 170,
                            width: MediaQuery.of(context).size.width - 40,
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.all(Radius.circular(40)),
                            ),
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: model.interfaceDynamic.homePosterUrl == null
                                    ? Image.asset("lib/ui/images/home_header2.png")
                                    : CachedNetworkImage(
                                        imageUrl: model.interfaceDynamic.homePosterUrl,
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),

                  // FEATURED CHALLENGES
                  model.listFeaturedActivity == null
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 5, 10),
                          child: Text('Онцлох даалгаврууд',
                              style: GoogleFonts.kurale(fontSize: 20, color: Color(0xff36c1c8), fontWeight: FontWeight.w800, letterSpacing: 1)),
                        ),
                  model.listFeaturedActivity == null
                      ? Container(height: 230)
                      : Container(
                          height: 190,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(4),
                          child: GridView.count(
                            controller: scrollViewController,
                            crossAxisCount: 1,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            mainAxisSpacing: 5.0,
                            children: model.listFeaturedActivity.map((Activity activity) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.pushNamed(context, '/activity_instruction', arguments: activity);
                                  });
                                },
                                child: Container(
                                  width: (MediaQuery.of(context).size.width) / 2,
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.all(Radius.circular(13)),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                          child: Container(
                                              width: (MediaQuery.of(context).size.width),
                                              child: activity.cachePathCoverImg != null
                                                  ? (ClipRRect(
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
                                                      child: Image.file(File(activity.cachePathCoverImg), fit: BoxFit.fitWidth),
                                                    ))
                                                  : (activity.coverImageUrl == null
                                                      ? Center(child: Image.asset('lib/ui/images/loading.gif'))
                                                      : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
                                                          child: CachedNetworkImage(
                                                            imageUrl: activity.coverImageUrl,
                                                            fit: BoxFit.cover,
                                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                                          ),
                                                          // Image.network(activity.coverImageUrl, fit: BoxFit.fill),
                                                        )))),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(5, 2, 0, 2),
                                            child: Container(
                                                child: Text(activity.name,
                                                    style: GoogleFonts.kurale(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500))),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                  color: activity.activityType == 'diy'
                                                      ? Colors.blue.withOpacity(0.7)
                                                      : (activity.activityType == 'discover'
                                                          ? Colors.orange.withOpacity(0.7)
                                                          : (activity.activityType == 'dance'
                                                              ? Colors.red.withOpacity(0.7)
                                                              : Colors.blue.withOpacity(0.6))),
                                                  borderRadius: BorderRadius.all(Radius.circular(20))),
                                              margin: EdgeInsets.fromLTRB(5, 2, 5, 4),
                                              padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                                              //width: 40,
                                              height: 25,
                                              child: Center(
                                                  child: Text(
                                                      activity.activityType == 'diy'
                                                          ? 'Бүтээл'
                                                          : (activity.activityType == 'discover'
                                                              ? 'Өөрийгөө нээ'
                                                              : (activity.activityType == 'dance' ? 'Бүжиг' : '')),
                                                      style: GoogleFonts.kurale(color: Colors.white, fontSize: 11)))),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(0, 0, 10, 3),
                                            child: activity.difficulty == 'easy'
                                                ? Image.asset('lib/ui/images/icon_easy.png', height: 20)
                                                : (activity.difficulty == 'medium'
                                                    ? Image.asset('lib/ui/images/icon_medium.png', height: 20)
                                                    : (activity.difficulty == 'hard'
                                                        ? Image.asset('lib/ui/images/icon_hard.png', height: 20)
                                                        : Text(''))),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                  Divider(color: Colors.grey[200], thickness: 3,),
                  // BEST POSTS
                  model.listBestPost == null
                      ? Container()
                      : Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 5, 10),
                    child: Text('Шилдэг бүтээлүүд',
                        style: GoogleFonts.kurale(fontSize: 20, color: Color(0xff36c1c8), fontWeight: FontWeight.w800, letterSpacing: 1)),
                  ),
                  model.listBestPost == null
                      ? Container(height: 230)
                      : Container(
                    height: 187,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(4),
                    child: GridView.count(
                      controller: scrollBestPostController,
                      crossAxisCount: 1,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      mainAxisSpacing: 5.0,
                      children: model.listBestPost.map((Post post) {
                        return GalleryPostMinimalWidget(post: post);
                      }).toList(),
                    ),
                  ),
                ]),
        ),
      ),
    );
  }
}
