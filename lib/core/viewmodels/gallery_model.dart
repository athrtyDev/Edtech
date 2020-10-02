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
  User loggedUser;

  void loadPostsByUser(BuildContext context) async {
    setState(ViewState.Busy);
    loggedUser = Provider.of<User>(context);
    listAllPosts = await _api.getAllPost();
    setState(ViewState.Idle);
    notifyListeners();
  }
}