import 'package:education/core/classes/Interface_dynamic.dart';
import 'package:education/core/classes/activity.dart';
import 'package:education/core/classes/comment.dart';
import 'package:education/core/classes/like.dart';
import 'package:education/core/classes/post.dart';
import 'package:education/core/classes/user.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/core/services/api.dart';
import 'package:education/core/viewmodels/base_model.dart';
import 'package:education/locator.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class HomeModel extends BaseModel {
  final Api _api = locator<Api>();
  InterfaceDynamic interfaceDynamic;
  List<Activity> listFeaturedActivity;
  List<Post> listHomePost;
  List<Post> listBestPost;

  void initHomeView(BuildContext context) async{
    setState(ViewState.Busy);
    interfaceDynamic = await _api.getInterfaceDynamic();
    checkUpdate(context);
    getFeaturedActivity();
    getNewsFeedPost(context);
    notifyListeners();
    setState(ViewState.Idle);
  }

  void checkUpdate(BuildContext context) async {
    // Check app version to update
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.buildNumber;
      print('app verions: ' + version);
      print('db app version: ' + interfaceDynamic.appVersion);
      print((interfaceDynamic.appVersion == version).toString());
      if(interfaceDynamic.appVersion != version)
        Navigator.pushNamed(context, '/update');
    } catch (e) {
      print('error: Failed to check version');
    }
  }

  void getFeaturedActivity() async {
    List<Activity> allActivity = await _api.getAllActivity();
    listFeaturedActivity = new List<Activity>();
    for(Activity activity in allActivity)
      if(activity.isFeatured)
        listFeaturedActivity.add(activity);
    notifyListeners();
  }

  void getNewsFeedPost(BuildContext context) async {
    List<Post> listAllPost = await _api.getHomePost();
    getPostsDetail(context, listAllPost);
    notifyListeners();
  }

  void getPostsDetail(BuildContext context, List<Post> allPost) async {
    String loggedUserId = Provider.of<User>(context).id;
    List<Like> allLikes = await _api.getAllLikes();
    List<Comment> listAllComments = await _api.getListComment(null);
    listHomePost = new List<Post>();
    listBestPost = new List<Post>();

    if(allPost != null) {
      for (Post post in allPost) {
        // Check LIKE for posts
        if(allLikes != null) {
          for (Like like in allLikes) {
            // Count every post's like
            if (like.postId == post.postId) {
              if (post.likeCount == null)
                post.likeCount = 0;
              post.likeCount++;
            }
            // Check if logged user liked the post
            if (post.isUserLiked == null)
              post.isUserLiked = false;
            if (like.postId == post.postId && like.likedUserId == loggedUserId) {
              post.isUserLiked = true;
            }
          }
        }

        // Check COMMENT for posts
        if(listAllComments != null) {
          for (Comment comment in listAllComments) {
            if (comment.postId == post.postId) {
              List<Comment> commentOfThisPost = post.listComment;
              if(commentOfThisPost == null)
                commentOfThisPost = new List<Comment>();
              commentOfThisPost.add(comment);
              post.listComment = commentOfThisPost;
            }
          }
        }

        // Distinguish best posts
        if(post.isTop) listBestPost.add(post);
        else listHomePost.add(post);
      }
    }
    notifyListeners();
  }

  /*// old code
  void selectHomeActivity(BuildContext context) async {
    setState(ViewState.Busy);
    String homeActivityId = interfaceDynamic.homeActivityId;
    final Api _api = locator<Api>();
    Activity activity = await _api.getActivityById(homeActivityId);

    //activity.activityType = homeActivityType;
    if(activity.mediaUrlAll != null)
      activity.listMedia = ActivityHomeModel.getListMediaOfActivity(activity);
    Navigator.pushNamed(context, '/activity_instruction', arguments: activity);
    notifyListeners();
    setState(ViewState.Idle);
  }*/
}