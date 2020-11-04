import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:education/core/classes/user.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/core/viewmodels/login_model.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with SingleTickerProviderStateMixin {
  final TextEditingController _nameInput = TextEditingController();
  final TextEditingController _passwordInput = TextEditingController();
  FocusNode _focusNameInput = new FocusNode();
  FocusNode _focusPasswordInput = new FocusNode();

  @override
  void initState() {
    super.initState();
    checkIsLoggedIn();
  }

  Future<Null> checkIsLoggedIn() async {
    SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username');
    print('Username exist? ' + (username ?? 'null'));
    if(username != null) {
      User user = new User(id: prefs.getString('id'), name: prefs.getString('username'), age: prefs.getInt('age'), registeredDate: prefs.getString('registeredDate'));
      StreamController<User> userController = StreamController<User>();
      userController.add(user);
      Navigator.pushNamed(context, '/mainPage', arguments: null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
        builder: (context, model, child) => WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: MaterialApp(
              home: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    //_nameInput.clear();
                    //_passwordInput.clear();
                    setState(() {});
                  },
                  child: Scaffold(
                      //backgroundColor: Color(0xFFfc9c5b),
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
                                      child: Image.asset('lib/ui/images/splash.png', height: 100),
                                      radius: 50.0,
                                    )),
                              ),
                              _focusNameInput.hasFocus || _focusPasswordInput.hasFocus ? Container() : Text("Сайн уу,", style: GoogleFonts.kurale(fontWeight: FontWeight.bold, fontSize: 35.0, color: Color(0xff36c1c8), letterSpacing: 1)),
                              _focusNameInput.hasFocus || _focusPasswordInput.hasFocus ? Container() :
                              Text("Бүтээлч хүүхдүүдийн нэгдэл", style: GoogleFonts.kurale(fontSize: 25, color: Color(0xff36c1c8), letterSpacing: 0.8)),
                              _focusNameInput.hasFocus || _focusPasswordInput.hasFocus ? Container() : SizedBox(height: 50),
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
                                    focusNode: _focusNameInput,
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
                                        hintStyle: GoogleFonts.kurale(color: Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 15.0)),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
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
                                    focusNode: _focusPasswordInput,
                                    obscureText: true,
                                    keyboardType: TextInputType.number,
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
                                        hintText: "Нууц үг",
                                        hintStyle: GoogleFonts.kurale(color: Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 15.0)),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                height: 45,
                                width: 300,
                                child: model.state == ViewState.Busy ? Center(child: CircularProgressIndicator()) :
                                  RaisedButton(
                                    textColor: Colors.white,
                                    color: Color(0xff36c1c8),
                                    disabledColor: Color(0xff36c1c8),
                                    disabledTextColor: Color(0xff36c1c8),
                                    elevation: 4.0,
                                    child: Text('НЭВТРЭХ', style: GoogleFonts.kurale(letterSpacing: 1)),
                                    onPressed: () async{
                                      if (_nameInput.text != '' && _passwordInput.text != '') {
                                        User user = await model.login(_nameInput.text, _passwordInput.text);
                                        if(user != null) {
                                          FocusScope.of(context).unfocus();
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          prefs.setString('username', user.name);
                                          prefs.setString('id', user.name);
                                          prefs.setInt('age', user.age);
                                          prefs.setString('registeredDate', user.registeredDate);
                                          Navigator.pushNamed(context, '/mainPage', arguments: null);
                                        } else {
                                          Flushbar(
                                            message: 'Нэр, нууц үг буруу байна.',
                                            padding: EdgeInsets.all(25),
                                            backgroundColor: Color(0xff36c1c8),
                                            duration: Duration(seconds: 3),
                                          )..show(context);
                                        }
                                      }
                                      else {
                                        Flushbar(
                                          message: 'Мэдээллээ бүрэн оруулна уу.',
                                          padding: EdgeInsets.all(25),
                                          backgroundColor: Color(0xff36c1c8),
                                          duration: Duration(seconds: 3),
                                        )..show(context);
                                      }


                                    },
                                  ),
                              ),
                              _focusNameInput.hasFocus || _focusPasswordInput.hasFocus ? Container() :
                              Container(
                                width: 300,
                                margin: EdgeInsets.fromLTRB(0, 70, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, '/register', arguments: _nameInput.text);
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 30,
                                        color: Colors.transparent,
                                        child: Text('Бүртгүүлэх', style: GoogleFonts.kurale(color: Colors.grey[600], fontSize: 17, decoration: TextDecoration.underline, letterSpacing: 1)),
                                      ),
                                    ),
                                    Container(
                                      width: 150,
                                      height: 30,
                                      color: Colors.transparent,
                                      child: Text('Нууц үг мартсан', style: GoogleFonts.kurale(color: Colors.grey[600], fontSize: 17, decoration: TextDecoration.underline, letterSpacing: 1)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))),
            )));
  }
}
