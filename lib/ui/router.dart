import 'package:education/core/classes/activity.dart';
import 'package:education/core/classes/post.dart';
import 'package:education/ui/views/activity_home_view.dart';
import 'package:education/ui/views/activity_instruction_view.dart';
import 'package:education/ui/views/gallery_view.dart';
import 'package:education/ui/views/post_detail_view.dart';
import 'package:education/ui/views/profile_view.dart';
import 'package:education/ui/views/publish_view.dart';
import 'package:education/ui/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:education/ui/views/mainPage_view.dart';
import 'package:education/ui/views/login_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginView());
      case '/register':
        var name = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => RegisterView(name: name));
      case '/mainPage':
        return MaterialPageRoute(builder: (_) => MainPageView());
      case '/activity':
        var type = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ActivityHomeView(activityType: type));
      case '/activity_instruction':
        var activity = settings.arguments as Activity;
        return MaterialPageRoute(builder: (_) => ActivityInstructionView(activity: activity));
      case '/post_detail':
        var post = settings.arguments as Post;
        return MaterialPageRoute(builder: (_) => PostDetailView(post: post));
      case '/publish':
        var post = settings.arguments as Post;
        return MaterialPageRoute(builder: (_) => PublishView(post: post));
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfileView());
      case '/gallery':
        return MaterialPageRoute(builder: (_) => GalleryView());
      default:
        return MaterialPageRoute(builder: (_) => Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        ));
    }
  }
}