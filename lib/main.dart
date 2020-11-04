import 'package:flutter/material.dart';
import 'package:education/core/classes/user.dart';
import 'package:education/core/services/authentication_service.dart';
import 'package:education/locator.dart';
import 'package:education/ui/router.dart';
import 'package:provider/provider.dart';

void main() async{
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>(
        initialData: User.initial(),
        builder: (context) => locator<AuthenticationService>().userController,
        child: MaterialApp(
          title: 'Education',
          theme: ThemeData(),
          initialRoute: ('/login'),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Router.generateRoute,
        ));
  }
}
