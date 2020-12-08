import 'package:flutter/material.dart';
import 'package:education/core/classes/user.dart';
import 'package:education/core/services/authentication_service.dart';
import 'package:education/locator.dart';
import 'package:education/ui/router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String username = prefs.getString('username');
  print('Username exist? ' + (username ?? 'null'));
  runApp(MyApp(username));
}

class MyApp extends StatelessWidget {
  MyApp(this.username);
  final String username;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>(
        initialData: User.initial(),
        builder: (context) => locator<AuthenticationService>().userController,
        child: MaterialApp(
          title: 'Education',
          theme: ThemeData(),
          initialRoute: (username == null ? '/login' : '/mainPage'),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Router.generateRoute,
        ));
  }
}
