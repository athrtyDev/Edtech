import 'package:avatar_glow/avatar_glow.dart';
import 'package:education/core/classes/user.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/core/viewmodels/register_model.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterView extends StatefulWidget {
  final String name;

  RegisterView({@required this.name});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>{
  final TextEditingController _nameInput = TextEditingController();
  final TextEditingController _passwordInput = TextEditingController();
  final TextEditingController _ageInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<RegisterModel>(
        onModelReady: (model) => _nameInput.text = widget.name,
        builder: (context, model, child) => MaterialApp(
              home: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {});
                  },
                  child: Scaffold(
                      backgroundColor: Colors.white,
                      body: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              AvatarGlow(
                                endRadius: 90,
                                duration: Duration(seconds: 1),
                                glowColor: Color(0xff36c1c8),
                                repeat: true,
                                repeatPauseDuration: Duration(seconds: 1),
                                startDelay: Duration(seconds: 1),
                                child: Material(
                                    elevation: 8.0,
                                    shape: CircleBorder(),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Image.asset('lib/ui/images/logo.png', height: 80),
                                      radius: 50.0,
                                    )),
                              ),
                              // NAME input
                              Container(
                                height: 60,
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                  color: Colors.transparent,
                                ),
                                child: Center(
                                  child: TextField(
                                    controller: _nameInput,
                                    keyboardType: TextInputType.text,
                                    style: GoogleFonts.kurale(color: Colors.grey[600]),
                                    onTap: () {
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(borderSide: new BorderSide(color: Colors.transparent)),
                                        focusedBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.transparent)),
                                        disabledBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.transparent)),
                                        enabledBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.transparent)),
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: "Нэр",
                                        hintStyle: GoogleFonts.kurale(color: Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 16.0)),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              // PASSWORD input
                              Container(
                                height: 60,
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                  color: Colors.transparent,
                                ),
                                child: Center(
                                  child: TextField(
                                    controller: _passwordInput,
                                    obscureText: true,
                                    style: GoogleFonts.kurale(color: Colors.grey[600]),
                                    keyboardType: TextInputType.number,
                                    onTap: () {
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        focusedBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        disabledBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        enabledBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: "Нууц үг",
                                        hintStyle: GoogleFonts.kurale(color: Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 16.0)),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              // AGE input
                              Container(
                                height: 60,
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                  color: Colors.transparent,
                                ),
                                child: Center(
                                  child: TextField(
                                    controller: _ageInput,
                                    style: GoogleFonts.kurale(color: Colors.grey[600]),
                                    keyboardType: TextInputType.number,
                                    onTap: () {
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        focusedBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        disabledBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        enabledBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        hintText: "Нас",
                                        hintStyle: GoogleFonts.kurale(color: Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 16.0)),
                                  ),
                                ),
                              ),
                              // REGISTER button
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                height: 50,
                                width: 300,
                                child: model.state == ViewState.Busy ? Center(child: CircularProgressIndicator()) :
                                    RaisedButton(
                                      textColor: Colors.white,
                                      color: Color(0xff36c1c8),
                                      disabledColor: Color(0xff36c1c8),
                                      disabledTextColor: Color(0xff36c1c8),
                                      elevation: 4.0,
                                      child: Text('БҮРТГҮҮЛЭХ', style: GoogleFonts.kurale()),
                                      onPressed: () async{
                                        if (_nameInput.text != '' && _passwordInput.text != '' && _ageInput.text != '') {
                                          User user = await model.registerUser(_nameInput.text, _passwordInput.text, _ageInput.text);
                                          if(user != null) {
                                            // Register success
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            prefs.setString('id', user.id);
                                            prefs.setString('username', user.name);
                                            prefs.setInt('age', user.age);
                                            prefs.setString('registeredDate', user.registeredDate);
                                            prefs.setString('type', user.type);
                                            Navigator.pushNamed(context, '/mainPage', arguments: null);
                                          } else {
                                            // Register fail. Username exists
                                            Flushbar(
                                              message: 'Нэр бүртгэлтэй байна. Өөр нэр сонгоно уу.',
                                              padding: EdgeInsets.all(25),
                                              backgroundColor: Color(0xff36c1c8),
                                              duration: Duration(seconds: 3),
                                            )..show(context);
                                          }
                                        } else {
                                          Flushbar(
                                            message: 'Мэдээллээ бүрэн бөглөнө үү.',
                                            padding: EdgeInsets.all(25),
                                            backgroundColor: Color(0xff36c1c8),
                                            duration: Duration(seconds: 3),
                                          )..show(context);
                                        }
                                      },
                                    )
                              ),
                            ],
                          ),
                        ),
                      ))),
            ));
  }
}
