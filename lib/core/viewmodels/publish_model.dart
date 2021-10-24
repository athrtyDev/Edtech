import 'dart:io';
import 'package:education/core/classes/post.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/core/services/api.dart';
import 'package:education/core/services/tool.dart';
import 'package:education/core/viewmodels/base_model.dart';
import 'package:education/locator.dart';

class PublishModel extends BaseModel {
  final Api _api = locator<Api>();

  Future<bool> uploadFile(Post post, File file) async{
    setState(ViewState.Busy);
    // save post
    var oldFileBytes = await file.readAsBytes();
    print('000000000');
    String postId = await _api.savePost(post, file);
    // cache new published file
    await Tool.cacheNewPublishedPost(postId, oldFileBytes);

    print('111111111');
    // means: if post is made by app's camera. Not uploaded from phone
    if(post.pickedMedia.storageFile == null && await File(post.pickedMedia.mediaStr).exists()) {
      print('22222 ' + post.pickedMedia.mediaStr);
      await File(post.pickedMedia.mediaStr).delete();
    }
    print('33333333333');

    setState(ViewState.Idle);
    return postId != null;
  }
}