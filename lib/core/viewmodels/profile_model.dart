import 'package:education/core/classes/post.dart';
import 'package:education/core/classes/user.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/core/services/api.dart';
import 'package:education/core/viewmodels/base_model.dart';
import 'package:education/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileModel extends BaseModel {
  final Api _api = locator<Api>();
  List<Post> listUserAllPosts;
  User loggedUser;

  void loadPostsByUser(BuildContext context) async {
    setState(ViewState.Busy);
    loggedUser = Provider.of<User>(context);
    listUserAllPosts = await _api.getPostByUser(loggedUser);
    // count Post, skill, like
    int postTotal = 0;
    int skillTotal = 0;
    int likeTotal = 0;
    if(listUserAllPosts != null) {
      for(Post post in listUserAllPosts) {
        postTotal++;
        skillTotal += post.skillPoints ?? 0;
        likeTotal += post.likeCount ?? 0;
      }
    }
    loggedUser.postTotal = postTotal;
    loggedUser.skillTotal = skillTotal;
    loggedUser.likeTotal = likeTotal;
    setState(ViewState.Idle);
    notifyListeners();
  }
}