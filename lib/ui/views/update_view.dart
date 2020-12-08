import 'package:flutter/material.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flutter/foundation.dart';
import 'package:education/core/viewmodels/home_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_appstore/open_appstore.dart';

class UpdateView extends StatefulWidget {
  UpdateView({Key key}) : super(key: key);

  @override
  _UpdateViewState createState() => _UpdateViewState();
}

class _UpdateViewState extends State<UpdateView> {
  _UpdateViewState({Key key});

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Color(0xffedeff4),
        body: SafeArea(
            child: model.state == ViewState.Busy
                ? Container(child: Center(child: CircularProgressIndicator()))
                : Padding(
              padding: EdgeInsets.fromLTRB(25, 50, 25, 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("lib/ui/images/update.gif", height: 300),
                  Text('Silly House', style: GoogleFonts.kurale(fontSize: 30, color: Color(0xff36c1c8), fontWeight: FontWeight.bold)),
                  Text('апп-аа шинэчлээрэй!', style: GoogleFonts.kurale(fontSize: 30, color: Color(0xff36c1c8), fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  RichText(
                    text: new TextSpan(
                      style: GoogleFonts.kurale(fontSize: 18, color: Colors.grey),
                      children: <TextSpan>[
                        new TextSpan(text: 'Заавар: '),
                        new TextSpan(text: 'Шинэчлэх ', style: new TextStyle(fontWeight: FontWeight.bold, color: Color(0xff36c1c8))),
                        new TextSpan(text: 'товчийг дарж, дараа нь '),
                        new TextSpan(text: 'Update ', style: new TextStyle(fontWeight: FontWeight.bold, color: Color(0xff36c1c8))),
                        new TextSpan(text: 'дарна.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                Icon(Icons.backup, color: Colors.white, size: 23),
                SizedBox(width: 8),
                Text('Шинэчлэх', style: GoogleFonts.kurale(fontSize: 18, color: Colors.white)),
              ],
            ),
            onPressed: () {
              OpenAppstore.launch(androidAppId: "com.education.sillyhouse", iOSAppId: "284882215");
            },
          ),
        ),
      ),
    );
  }
}
