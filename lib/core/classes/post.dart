import 'dart:io';
import 'package:education/core/classes/activity.dart';
import 'package:education/core/classes/user.dart';

class Post {
  String postId;
  DateTime postDate;
  String uploadMediaType;
  String mediaDownloadUrl;
  String coverDownloadUrl;    // if it is video. null on image
  String userId;
  String userName;
  //String activityId;
  //String activityName;
  Activity activity;
  User user;
  File uploadingFile;
  int skillPoints;
  // tuslah
  int likeCount;
  bool isUserLiked = false;

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
    coverDownloadUrl = json['coverDownloadUrl'] ?? null;
    postDate = json['postDate'] == null ? (DateTime.parse(json['postDate'].toDate().toString())) : null;
    skillPoints = json['skillPoints'] != null ? int.tryParse(json['skillPoints'].toString()) : null;
    likeCount = json['likeCount'] != null ? int.tryParse(json['likeCount'].toString()) : null;
  }

  /*Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postId'] = this.postId;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['userAge'] = this.userAge;
    data['diyId'] = this.diyId;
    data['diyName'] = this.diyName;
    data['diyType'] = this.diyType;
    data['date'] = this.date;
    return data;
  }*/
}