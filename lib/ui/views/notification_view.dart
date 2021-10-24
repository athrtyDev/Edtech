import 'package:flutter/material.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flutter/foundation.dart';
import 'package:education/core/viewmodels/home_model.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationView extends StatefulWidget {
  NotificationView({Key key}) : super(key: key);

  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  _NotificationViewState({Key key});

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: model.state == ViewState.Busy
              ? Container(child: Center(child: CircularProgressIndicator()))
              : Column(children: [
                  // Header
                  Container(
                    height: 60,
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      children: [
                        Icon(Icons.bubble_chart, color: Color(0xff36c1c8), size: 23),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text('Мэдэгдэл',
                              style: GoogleFonts.kurale(fontSize: 18, color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                  // Gallery list
                  Expanded(
                      child: Center(
                        child: Container(
                          //color: Colors.green,
                          height: 450,
                          child: Stack(
                            children: [
                              Image.asset('lib/ui/images/info.png', height: 450),
                              Positioned(
                                top: 110,
                                left: MediaQuery.of(context).size.width/2 - 80,
                                child: Text('Мэдэгдэл ирээгүй', style: GoogleFonts.kurale(fontSize: 16, color: Colors.black)),
                              ),
                              Positioned(
                                top: 130,
                                left: MediaQuery.of(context).size.width/2 - 45,
                                child: Text(' байна.', style: GoogleFonts.kurale(fontSize: 16, color: Colors.black)),
                              ),
                            ],
                          ),
                        )
                      )
                  ),
                ]),
        ),
      ),
    );
  }
}
