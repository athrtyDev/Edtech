import 'package:avatar_glow/avatar_glow.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/core/viewmodels/login_model.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    final color = Colors.white;
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
                      backgroundColor: Color(0xFFfc9c5b),
                      body: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              AvatarGlow(
                                endRadius: 90,
                                duration: Duration(seconds: 1),
                                glowColor: Colors.white24,
                                repeat: true,
                                repeatPauseDuration: Duration(seconds: 1),
                                startDelay: Duration(seconds: 1),
                                child: Material(
                                    elevation: 8.0,
                                    shape: CircleBorder(),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[100],
                                      child: Image.asset('lib/ui/images/splash.png', height: 100),
                                      radius: 50.0,
                                    )),
                              ),
                              _focusNameInput.hasFocus || _focusPasswordInput.hasFocus ? Container() : Text("Сайн уу,", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35.0, color: color)),
                              _focusNameInput.hasFocus || _focusPasswordInput.hasFocus ? Container() : SizedBox(height: 10),
                              _focusNameInput.hasFocus || _focusPasswordInput.hasFocus ? Container() : Text("Бүтээлч хүүхдүүдийн групп", style: TextStyle(fontSize: 20.0, color: color)),
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
                                    style: TextStyle(color: Colors.white),
                                    onTap: () {
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        focusedBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        disabledBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        enabledBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        fillColor: Colors.white,
                                        hintText: "Нэр",
                                        hintStyle: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 15.0)),
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
                                    style: TextStyle(color: Colors.white),
                                    onTap: () {
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        focusedBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        disabledBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        enabledBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        hintText: "Нууц үг",
                                        hintStyle: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 15.0)),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                height: 45,
                                width: 300,
                                child: model.state == ViewState.Busy ? Center(child: CircularProgressIndicator()) :
                                  RaisedButton(
                                    textColor: Colors.deepOrange,
                                    color: Colors.white,
                                    disabledColor: Colors.grey,
                                    disabledTextColor: Colors.white,
                                    elevation: 4.0,
                                    child: Text('НЭВТРЭХ'),
                                    onPressed: () async{
                                      if (_nameInput.text != '' && _passwordInput.text != '') {
                                        if(await model.login(_nameInput.text, _passwordInput.text)) {
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          prefs.setString('username', _nameInput.text);
                                          Navigator.pushNamed(context, '/mainPage', arguments: null);
                                        } else {
                                          Flushbar(
                                            message: 'Нэр, нууц үг буруу байна.',
                                            padding: EdgeInsets.all(25),
                                            backgroundColor: Color(0xff36adc8),
                                            duration: Duration(seconds: 3),
                                          )..show(context);
                                        }
                                      }
                                      else {
                                        Flushbar(
                                          message: 'Мэдээллээ бүрэн оруулна уу.',
                                          padding: EdgeInsets.all(25),
                                          backgroundColor: Color(0xff36adc8),
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
                                        child: Text('Бүртгүүлэх', style: TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.underline)),
                                      ),
                                    ),
                                    Container(
                                      width: 130,
                                      height: 30,
                                      color: Colors.transparent,
                                      child: Text('Нууц үг мартсан', style: TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.underline)),
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
