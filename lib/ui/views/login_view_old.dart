import 'package:flutter/material.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/core/viewmodels/login_model.dart';
import 'package:education/ui/views/base_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  DateTime currentBackPressTime;
  final TextEditingController _phoneInput = TextEditingController();
  FocusNode _focusPhoneInput = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
        //onModelReady: (model) => model.getCustomers(),
        builder: (context, model, child) => WillPopScope(
            onWillPop: onWillPop,
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: _focusPhoneInput.hasFocus ? 210 : 270,
                              /*child: Center(
                          child: Image.asset('lib/ui/images/education_illustration.png', height: 80),
                        ),*/
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Нэвтрэх",
                                        style: TextStyle(
                                            fontSize: 40,
                                            fontFamily: 'Raleway',
                                            color: Colors.grey[500],
                                            letterSpacing: 1)),
                                    SizedBox(height: 70),
                                  ],
                                ),
                                Container(
                                  width: 350,
                                  child: TextField(
                                    controller: _phoneInput,
                                    focusNode: _focusPhoneInput,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.grey[600])),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.grey[600])),
                                        disabledBorder: OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.grey[600])),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.grey[600])),
                                        hintText: "Утасны дугаар",
                                        hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 13.0)),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: 30),
                                      color: Colors.grey[200],
                                      height: 45,
                                      width: 250,
                                      child: RaisedButton(
                                        textColor: Colors.white,
                                        color: Colors.orange[600],
                                        disabledColor: Colors.grey,
                                        disabledTextColor: Colors.deepOrange,
                                        elevation: 4.0,
                                        child: Text(
                                            model.state == ViewState.Busy
                                                ? 'Түр хүлээнэ үү...'
                                                : 'Нэвтрэх'),
                                        onPressed: () async {
                                          /*if (model.state != ViewState.Busy) {
                                            var loginSuccess = await model.registerKid(_phoneInput.text);
                                            if (loginSuccess) {
                                              Navigator.pushNamed(
                                                  context, '/home');
                                            }
                                          }*/
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(model.errorMessage == null
                                        ? ''
                                        : model.errorMessage),
                                  ],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 30),
                                        height: 1,
                                        color: Colors.grey,
                                        width: 130,
                                      ),
                                      SizedBox(width: 15),
                                      Container(
                                        padding: EdgeInsets.only(top: 25),
                                        child: Text("эсвэл",
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      ),
                                      SizedBox(width: 15),
                                      Container(
                                        margin: EdgeInsets.only(top: 30),
                                        height: 1,
                                        color: Colors.grey,
                                        width: 130,
                                      ),
                                    ]),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: 30),
                                      color: Colors.grey[200],
                                      height: 45,
                                      width: 250,
                                      child: RaisedButton(
                                        textColor: Colors.white,
                                        color: Colors.blue,
                                        disabledColor: Colors.grey,
                                        disabledTextColor: Colors.white,
                                        elevation: 4.0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                                'lib/ui/images/facebook_logo.png',
                                                height: 20),
                                            SizedBox(width: 10),
                                            Text('Facebook'),
                                          ],
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )),
              ),
            )));
  }

  Future<bool> onWillPop() {
    return Future.value(false);
  }
}
