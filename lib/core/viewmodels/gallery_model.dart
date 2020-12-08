import 'package:education/core/classes/comment.dart';
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
  List<Post> listTopPosts;
  List<Post> listOtherPosts;
  List<Post> listOtherShowingPosts;
  List<Post> listSelectedPosts;
  List<Like> allLikes;
  User loggedUser;

  void loadPostsByUser(BuildContext context) async {
    setState(ViewState.Busy);
    loggedUser = Provider.of<User>(context);
    allLikes = await _api.getAllLikes();
    List<Post> listAllPosts = await _api.getAllPost();
    List<Comment> listAllComments = await _api.getListComment(null);
    listTopPosts = new List<Post>();                // all top posts
    listOtherPosts = new List<Post>();              // non top ALL posts
    listOtherShowingPosts = new List<Post>();       // non top SHOWING other posts


    if(listAllPosts != null) {
      for (Post post in listAllPosts) {
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
            if (like.postId == post.postId && like.likedUserId == loggedUser.id) {
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

        // Seperate top posts and other posts
        if(post.isTop) listTopPosts.add(post);
        else listOtherPosts.add(post);
      }
    }
    if(listTopPosts.isEmpty) listTopPosts = null;
    if(listOtherPosts.isEmpty) listOtherPosts = null;
    setState(ViewState.Idle);
    notifyListeners();
  }
}