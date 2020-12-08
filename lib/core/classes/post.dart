import 'dart:io';
import 'package:camera/camera.dart';
import 'package:education/core/classes/activity.dart';
import 'package:education/core/classes/comment.dart';
import 'package:education/core/classes/picked_media.dart';
import 'package:education/core/classes/user.dart';
import 'package:education/core/services/api.dart';
import 'package:education/locator.dart';

class Post {
  String postId;
  DateTime postDate;
  String uploadMediaType;
  String mediaDownloadUrl;
  String coverDownloadUrl;    // if it is video. null on image
  String userId;
  String userName;
  Activity activity;
  User user;
  File uploadingFile;
  int skillPoints;
  bool isTop;
  // tuslah
  int likeCount;
  bool isUserLiked = false;
  List<Comment> listComment;
  PickedMedia pickedMedia;
  List<CameraDescription> cameras;
  String cacheMediaPath;
  final Api _api = locator<Api>();

  Post({this.postId, this.activity, this.user, this.uploadMediaType, this.userId, this.userName,
    //this.activityId, this.activityName,
    this.mediaDownloadUrl, this.postDate, this.uploadingFile, this.coverDownloadUrl,
    this.likeCount, this.skillPoints});

  Post.fromJson(Map<String, dynamic> json) {
    postId = json['postId'] ?? null;
    uploadMediaType = json['uploadMediaType'] ?? null;
    userId = json['userId'] ?? null;
    userName = json['userName'] ?? '';
    activity = new Activity();
    activity.id = json['activityId'] ?? null;
    activity.name = json['activityName'] ?? '';
    activity.activityType = json['activityType'] ?? '';
    activity.difficulty = json['activityDifficulty'] ?? '';
    mediaDownloadUrl = json['mediaDownloadUrl'] ?? null;
    coverDownloadUrl = (json['coverDownloadUrl'] == null || json['coverDownloadUrl'] == "") ? json['mediaDownloadUrl'] : json['coverDownloadUrl'];
    postDate = json['postDate'] == null ? (DateTime.parse(json['postDate'].toDate().toString())) : null;
    skillPoints = json['skillPoints'] != null ? int.tryParse(json['skillPoints'].toString()) : null;
    likeCount = json['likeCount'] != null ? int.tryParse(json['likeCount'].toString()) : null;
    isTop = json['isTop'] ?? false;
  }

  void likePost(Post post, String userId) {
    post.isUserLiked = true;
    if(post.likeCount == null)
      post.likeCount = 0;
    post.likeCount++;
    _api.likePost(post, userId);
  }

  void dislikePost(Post post, String userId) {
    post.isUserLiked = false;
    post.likeCount--;
    _api.dislikePost(post, userId);
  }
}