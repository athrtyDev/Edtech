import 'package:education/core/classes/like.dart';
import 'package:education/core/classes/post.dart';
import 'package:education/core/classes/user.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/core/services/api.dart';
import 'package:education/core/viewmodels/base_model.dart';
import 'package:education/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GalleryModel extends BaseModel {
  final Api _api = locator<Api>();
  List<Post> listAllPosts;
  List<Like> allLikes;
  User loggedUser;

  void loadPostsByUser(BuildContext context) async {
    setState(ViewState.Busy);
    loggedUser = Provider.of<User>(context);
    allLikes = await _api.getAllLikes();
    listAllPosts = await _api.getAllPost();

    if(listAllPosts != null && allLikes != null) {
      for (Like like in allLikes) {
        for (Post post in listAllPosts) {
          // Count every post's like
          if(like.postId == post.postId) {
            if(post.likeCount == null)
              post.likeCount = 0;
            post.likeCount++;
          }
          // Check if logged user liked the post
          if(post.isUserLiked == null)
            post.isUserLiked = false;
          if(like.postId == post.postId && like.likedUserId == loggedUser.id) {
            post.isUserLiked = true;
          }
        }
      }
    }
    setState(ViewState.Idle);
    notifyListeners();
  }

  void likePost(Post post) {
    post.isUserLiked = true;
    if(post.likeCount == null)
      post.likeCount = 0;
    post.likeCount++;
    _api.likePost(post, loggedUser.id);
    notifyListeners();
  }

  void dislikePost(Post post) {
    post.isUserLiked = false;
    post.likeCount--;
    _api.dislikePost(post, loggedUser.id);
    notifyListeners();
  }
}