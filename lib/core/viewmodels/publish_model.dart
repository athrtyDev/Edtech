import 'dart:io';
import 'package:education/core/classes/post.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/core/services/api.dart';
import 'package:education/core/viewmodels/base_model.dart';
import 'package:education/locator.dart';

class PublishModel extends BaseModel {
  final Api _api = locator<Api>();

  Future<bool> uploadFile(Post post, File file) async{
    setState(ViewState.Busy);
    bool isSuccess = await _api.savePost(post, file);
    setState(ViewState.Idle);
    return isSuccess;
  }
}