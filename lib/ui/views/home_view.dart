import 'package:cached_network_image/cached_network_image.dart';
import 'package:education/core/classes/user.dart';
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
    return BaseView<HomeModel>(
      onModelReady: (model) => model.initHomeView(context),
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
            child: model.state == ViewState.Busy
                ? Container(child: Center(child: CircularProgressIndicator()))
                : Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          height: 270,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color(0xff36c1c8),
                            borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(60, 25), bottomRight: Radius.elliptical(60, 25)),
                          ),
                        ),
                      ),
                      ListView(children: <Widget>[
                        // GREETING
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 35, 5, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.bubble_chart, size: 30, color: Colors.white),
                                SizedBox(width: 10),
                                Flexible(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Сайн уу ',
                                            style: GoogleFonts.kurale(
                                                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 1.1)),
                                        Text(Provider.of<User>(context).name + ' !',
                                            style: GoogleFonts.kurale(
                                                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.1)),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(model.interfaceDynamic.homeGreeting ?? 'Даалгавруудыг биелүүлж, бусадтай хуваалцаарай.',
                                        style: GoogleFonts.kurale(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w300)),
                                  ],
                                ))
                              ],
                            )),
                        // TODAY'S POSTER
                        GestureDetector(
                          onTap: () async {
                            /*print('aaaaaaaaaaaaa');
                        var appDir = await getExternalCacheDirectories();
                        String fullPath = appDir.first.path + "/boo3.mp4'";
                        print('full path ${fullPath}');
                        var dio = Dio();
                        final imgUrl = "https://firebasestorage.googleapis.com/v0/b/education-69b9a.appspot.com/o/activity_diy%2F7%2Fintro.mp4?alt=media&token=3da7caf3-6140-479b-930f-d0ddd9002754";
                        Tool.download(dio, imgUrl, fullPath);
                        print('bbbbbbbbbbbbb');*/
                          },
                          child: Container(
                            height: 180,
                            margin: EdgeInsets.all(20),
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
                        // ALL ACTIVITY TYPES
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.bubble_chart, size: 30, color: Color(0xff36c1c8)),
                                    SizedBox(width: 10),
                                    Text(model.interfaceDynamic.homeActivityInfo ?? 'Даалгавруудаас сонгоорой',
                                        style: GoogleFonts.kurale(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                SizedBox(height: 10),
                                // ACTIVITY DIY
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/activity', arguments: 'diy');
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.deepOrange.withOpacity(0.2), spreadRadius: 0.4, blurRadius: 9, offset: Offset(5, 5)),
                                        ],
                                      ),
                                      height: 90,
                                      padding: EdgeInsets.all(0),
                                      child: Row(
                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 90,
                                            width: 100,
                                            child: FittedBox(
                                              fit: BoxFit.fill,
                                              child: model.interfaceDynamic.homeDiyUrl == null
                                                  ? Image.asset('lib/ui/images/home_game.png', height: 90)
                                                  : ClipRRect(
                                                      borderRadius: BorderRadius.circular(15),
                                                      child: CachedNetworkImage(
                                                        imageUrl: model.interfaceDynamic.homeDiyUrl,
                                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                                        height: 90,
                                                      ),
                                                      //Image.network(model.interfaceDynamic.homeDiyUrl, height: 90),
                                                    ),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 3),
                                                Text('Бүтээл', style: GoogleFonts.kurale(color: Colors.black87, fontSize: 16)),
                                                SizedBox(height: 3),
                                                Text('Хичээлүүдийг даган биелүүлж гайхалтай бүтээлтэй болоорой!',
                                                    style: GoogleFonts.kurale(fontSize: 12, color: Colors.black54)),
                                              ],
                                            ),
                                          ),
                                          Icon(Icons.keyboard_arrow_right, size: 40, color: Color(0xff36c1c8)),
                                        ],
                                      )),
                                ),
                                SizedBox(height: 15),
                                // ACTIVITY DISCOVER
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/activity', arguments: 'discover');
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.deepOrange.withOpacity(0.2), spreadRadius: 0.4, blurRadius: 9, offset: Offset(5, 5)),
                                        ],
                                      ),
                                      height: 90,
                                      padding: EdgeInsets.all(0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 90,
                                            width: 100,
                                            child: FittedBox(
                                              fit: BoxFit.fill,
                                              child: model.interfaceDynamic.homeDiscoverUrl == null
                                                  ? Image.asset('lib/ui/images/home_discover.png', height: 90)
                                                  : ClipRRect(
                                                      borderRadius: BorderRadius.circular(15),
                                                      child: CachedNetworkImage(
                                                        imageUrl: model.interfaceDynamic.homeDiscoverUrl,
                                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                                        height: 90,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 3),
                                                Text('Өөрийгөө нээ', style: GoogleFonts.kurale(color: Colors.black87, fontSize: 16)),
                                                SizedBox(height: 3),
                                                Text('Нуугдмал авьяасуудаа нээж илрүүлээрэй!',
                                                    style: GoogleFonts.kurale(fontSize: 12, color: Colors.black54)),
                                              ],
                                            ),
                                          ),
                                          Icon(Icons.keyboard_arrow_right, size: 40, color: Color(0xff36c1c8)),
                                        ],
                                      )),
                                ),
                                SizedBox(height: 15),
                                // ACTIVITY DANCE
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/activity', arguments: 'dance');
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.deepOrange.withOpacity(0.2), spreadRadius: 0.4, blurRadius: 9, offset: Offset(5, 5)),
                                        ],
                                      ),
                                      height: 90,
                                      padding: EdgeInsets.all(0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 90,
                                            width: 100,
                                            child: FittedBox(
                                              fit: BoxFit.fill,
                                              child: model.interfaceDynamic.homeDanceUrl == null
                                                  ? Image.asset('lib/ui/images/home_dance.png', height: 90)
                                                  : ClipRRect(
                                                      borderRadius: BorderRadius.circular(15),
                                                      child: CachedNetworkImage(
                                                        imageUrl: model.interfaceDynamic.homeDanceUrl,
                                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                                        height: 90,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 3),
                                                Text('Бүжиг', style: GoogleFonts.kurale(color: Colors.black87, fontSize: 16)),
                                                SizedBox(height: 3),
                                                Text('Шинэ хөдөлгөөн сурж, өөрийнхөө эрч хүчээ нэмээрэй!',
                                                    style: GoogleFonts.kurale(fontSize: 12, color: Colors.black54)),
                                              ],
                                            ),
                                          ),
                                          Icon(Icons.keyboard_arrow_right, size: 40, color: Color(0xff36c1c8)),
                                        ],
                                      )),
                                ),
                              ],
                            )),
                      ]),
                    ],
                  ),
          ),
      ),
    );
  }
}
