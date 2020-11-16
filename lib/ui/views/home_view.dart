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
    double width = MediaQuery.of(context).size.width;
    return BaseView<HomeModel>(
      onModelReady: (model) => model.initHomeView(),
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: model.state == ViewState.Busy
              ? Container(child: Center(child: CircularProgressIndicator()))
              : ListView(children: <Widget>[
                  /*Text('Өнөөдрийн сорил', style: GoogleFonts.kurale(fontSize: 22, color: Colors.blue, fontWeight: FontWeight.bold)),
                        SizedBox(height: 15),
                        // CHALLENGE
                        Container(
                          height: 120,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(5, 5), // changes position of shadow
                                ),
                              ],
                              image: DecorationImage(image: AssetImage("lib/ui/images/tmp_challenge.jpg"), fit: BoxFit.fitWidth)),
                        ),*/
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("lib/ui/images/home_header.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 35, 5, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.shutter_speed, size: 30, color: Color(0xff36c1c8)),
                          SizedBox(width: 10),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Сайн уу ' + Provider.of<User>(context).name + ' !', style: GoogleFonts.kurale(fontSize: 19, color: Colors.black54, fontWeight: FontWeight.w600)),
                                //Text(Provider.of<User>(context).name, style: GoogleFonts.kurale(fontSize: 19, color: Colors.black54, fontWeight: FontWeight.w600)),
                                Text('Даалгавруудыг биелүүлж, бусадтай хуваалцаарай.', style: GoogleFonts.kurale(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w300)),
                              ],
                            )

                          )
                        ],
                      )
                  ),
                  // ALL ACTIVITY TYPES
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 55, 20, 0),
                      child: Row(
                        children: [
                          Icon(Icons.bubble_chart, size: 30, color: Color(0xff36c1c8)),
                          SizedBox(width: 10),
                          Text('Даалгавруудаас сонгоорой', style: GoogleFonts.kurale(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500)),
                        ],
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/activity', arguments: 'diy');
                          },
                          child: Container(
                            height: 140,
                            width: (width - 30 - 20) / 3,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      3, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: -1,
                                  left: 5,
                                  child: Image.asset(
                                      'lib/ui/images/home_game.png',
                                      height: 90),
                                ),
                                Positioned(
                                  top: 92,
                                  left: 26,
                                  child: Text('Бүтээл',
                                      style: GoogleFonts.kurale(
                                          fontSize: 15,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/activity',
                                arguments: 'discover');
                          },
                          child: Container(
                            height: 140,
                            width: (width - 60 - 30) / 3,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      3, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: -8,
                                  left: -23,
                                  child: Image.asset(
                                      'lib/ui/images/home_discover.png',
                                      height: 100),
                                ),
                                Positioned(
                                  top: 86,
                                  left: 11,
                                  child: Text('Өөрийгөө',
                                      style: GoogleFonts.kurale(
                                          fontSize: 15,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500)),
                                ),
                                Positioned(
                                  top: 100,
                                  left: 30,
                                  child: Text('нээ',
                                      style: GoogleFonts.kurale(
                                          fontSize: 15,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/activity',
                                arguments: 'dance');
                          },
                          child: Container(
                            height: 140,
                            width: (width - 60 - 30) / 3,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      3, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: -20,
                                  left: -35,
                                  child: Image.asset(
                                      'lib/ui/images/home_dance.png',
                                      height: 130),
                                ),
                                Positioned(
                                  top: 92,
                                  left: 22,
                                  child: Text('Бүжиг',
                                      style: GoogleFonts.kurale(
                                          fontSize: 15,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  /*
                        // ОНЦЛОХ
                        SizedBox(height: 45),
                        Text('Онцлох', style: GoogleFonts.kurale(fontSize: 22, color: Colors.blue, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Container(
                          height: 200,
                          child: model.state == ViewState.Busy ? Center(child: CircularProgressIndicator()) :
                          GridView.count(
                            controller: scrollViewController,
                            crossAxisCount: 1,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            crossAxisSpacing: 6.0,
                            mainAxisSpacing: 8.0,
                            children: model.allActivity.map((Activity activity) {
                              return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Navigator.pushNamed(context, '/activity_instruction', arguments: activity);
                                    });
                                  },
                                  child: Stack(children: [
                                    Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          Expanded(
                                              child: Container(
                                                  width: (MediaQuery.of(context).size.width) / 2,
                                                  child: activity.coverImage == null
                                                      ? Center(child: Image.asset('lib/ui/images/loading.gif'))
                                                      : Image.memory(activity.coverImage, fit: BoxFit.cover))),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(5, 2, 0, 2),
                                                child: Container(
                                                    child: Text(activity.name,
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
                                                  child: Center(child: Text('Уран зураг', style: TextStyle(color: Colors.white, fontSize: 11)))),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(0, 0, 10, 3),
                                                child: Image.asset('lib/ui/images/icon_medium.png', height: 20),
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
                                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all(Radius.circular(20))),
                                          width: 35,
                                          height: 20,
                                          child: Center(child: Text('143', style: TextStyle(color: Colors.deepOrange, fontSize: 11)))),
                                    ),
                                  ]));
                            }).toList(),
                          ),
                        ),*/
                ]),
        ),
      ),
    );
  }
}
