import 'package:avatar_glow/avatar_glow.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/core/viewmodels/register_model.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

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
                                    style: TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.number,
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
                                    style: TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.number,
                                    onTap: () {
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        focusedBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        disabledBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        enabledBorder: OutlineInputBorder(borderSide: new BorderSide(color: Colors.white)),
                                        hintText: "Нас",
                                        hintStyle: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 15.0)),
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
                                      textColor: Colors.deepOrange,
                                      color: Colors.white,
                                      disabledColor: Colors.grey,
                                      disabledTextColor: Colors.white,
                                      elevation: 4.0,
                                      child: Text('БҮРТГҮҮЛЭХ'),
                                      onPressed: () async{
                                        if (_nameInput.text != '' && _passwordInput.text != '' && _ageInput.text != '') {
                                          if(await model.registerUser(_nameInput.text, _passwordInput.text, _ageInput.text)) {
                                            // Register success
                                            Navigator.pushNamed(context, '/mainPage', arguments: null);
                                          } else {
                                            // Register fail. Username exists
                                            Flushbar(
                                              message: 'Нэр бүртгэлтэй байна. Өөр нэр сонгоно уу.',
                                              padding: EdgeInsets.all(25),
                                              backgroundColor: Color(0xff36adc8),
                                              duration: Duration(seconds: 3),
                                            )..show(context);
                                          }
                                        } else {
                                          Flushbar(
                                            message: 'Мэдээллээ бүрэн бөглөнө үү.',
                                            padding: EdgeInsets.all(25),
                                            backgroundColor: Color(0xff36adc8),
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
