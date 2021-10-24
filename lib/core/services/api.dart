import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education/core/classes/Interface_dynamic.dart';
import 'package:education/core/classes/activity.dart';
import 'package:education/core/classes/like.dart';
import 'package:education/core/classes/comment.dart';
import 'package:education/core/classes/post.dart';
import 'package:http/http.dart' as http;
import 'package:education/core/classes/user.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_compress/video_compress.dart';

class Api {
  static const endpoint = 'https://jsonplaceholder.typicode.com';
  var client = new http.Client();

  Future<User> getUserProfile(int userId) async {
    // Get user profile for id
    var response = await client.get('$endpoint/users/$userId');
    // Convert and return
    return User.fromJson(json.decode(response.body));
  }

  Future<InterfaceDynamic> getInterfaceDynamic() async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('Interface_dynamic')
        .getDocuments();

    if(snapshot.documents.isEmpty) {
      return null;
    }
    else {
      InterfaceDynamic dynamic = InterfaceDynamic.fromJson(snapshot.documents[0].data);
      return dynamic;
    }
  }

  Future<List<Activity>> getAllActivity() async {
    QuerySnapshot itemSnapshot = await Firestore.instance
        .collection('Activity')
        .where('skill', isGreaterThan: 0)
        .getDocuments();

    if(itemSnapshot.documents.isEmpty)
      return null;
    else
      return itemSnapshot.documents.map((activity) => new Activity.fromJson(activity.data)).toList();
  }

  Future<List<Activity>> getActivityByType(String activityType) async {
    QuerySnapshot itemSnapshot = await Firestore.instance
        .collection('Activity')
        .where('skill', isGreaterThan: 0)
        .where('activityType', isEqualTo: activityType)
        .getDocuments();

    if(itemSnapshot.documents.isEmpty)
      return null;
    else
      return itemSnapshot.documents.map((activity) => new Activity.fromJson(activity.data)).toList();
  }

  Future<Activity> getActivityById(String activityId) async {
    QuerySnapshot itemSnapshot = await Firestore.instance
        .collection('Activity')
        .where('skill', isGreaterThan: 0)
        .where('id', isEqualTo: activityId)
        .getDocuments();

    if(itemSnapshot.documents.isEmpty)
      return null;
    else {
      Activity activity = Activity.fromJson(itemSnapshot.documents[0].data);
      return activity;
    }
  }

  Future<String> savePost(Post post, File file) async{
    try {
      // compress media
      File thumbnailFile;
      String coverDownloadUrl = '';
      String postId = Uuid().v4();
      if(post.uploadMediaType == 'video') {
        // Compress video
        print('File compress video starting... ' + DateTime.now().toString());
        MediaInfo mediaInfo = await VideoCompress.compressVideo(
          file.path,
          quality: VideoQuality.MediumQuality,
          deleteOrigin: true,
          includeAudio: true,
        );
        file = mediaInfo.file;

        // Thumbnail image
        thumbnailFile = await VideoCompress.getFileThumbnail(
            mediaInfo.path,
            quality: 30, // default(100)
            position: -1 // default(-1)
        );

        // save thumbnail image
        StorageUploadTask thumbnailUploadTask = await FirebaseStorage.instance
            .ref()
            .child("post/" + post.user.name + '_' + post.user.id +"/" + post.activity.activityType + "_" + post.activity.id + "_" + postId + '_cover')
            .putFile(thumbnailFile, StorageMetadata(contentType: 'image/jpeg'));
        coverDownloadUrl = await (await thumbnailUploadTask.onComplete).ref.getDownloadURL();
        print('File upload success! ' + DateTime.now().toString());

        print('File compress video success... ' + DateTime.now().toString());
      }

      // save media to storage
      print('File upload starting222... ' + DateTime.now().toString());
      StorageUploadTask fileUploadTask = await FirebaseStorage.instance
          .ref()
          .child("post/" + post.user.name + '_' + post.user.id +"/" + post.activity.activityType + "_" + post.activity.id + "_" + postId + '_media')
          .putFile(file, StorageMetadata(contentType: post.uploadMediaType == 'image' ? 'image/jpeg' : 'video/mp4'));
      String downloadUrl = await (await fileUploadTask.onComplete).ref.getDownloadURL();

      // prepare post data
      Map<String, dynamic> postJson = new Map();
      postJson['postId'] = postId;
      postJson['uploadMediaType'] = post.uploadMediaType;
      postJson['userId'] = post.user.id;
      postJson['userName'] = post.user.name;
      postJson['activityId'] = post.activity.id;
      postJson['activityName'] = post.activity.name;
      postJson['activityType'] = post.activity.activityType;
      postJson['activityDifficulty'] = post.activity.difficulty;
      postJson['skillPoints'] = post.activity.skill;
      postJson['likeCount'] = 0;
      postJson['mediaDownloadUrl'] = downloadUrl;
      postJson['coverDownloadUrl'] = post.uploadMediaType == 'video' ? coverDownloadUrl : downloadUrl;
      postJson['postDate'] = DateTime.now();

      // order -> batch
      var db = Firestore.instance;
      DocumentReference orderReference = db.collection("Post").document();
      WriteBatch batch = db.batch();
      batch.setData(orderReference, postJson);

      // execute batch
      print('Post upload starting... ' + DateTime.now().toString());
      await batch.commit().then((value) {
        print('Post upload succeeded. ' + DateTime.now().toString());
      }).catchError((error) {
        print('Post upload error:' + error);
      });
      return postId;
    }
    catch(e) {
      print('SavePost function error:' + e);
      return null;
    }
  }

  Future<List<Post>> getAllPost() async {
    QuerySnapshot postSnapshot = await Firestore.instance
        .collection('Post')
        .orderBy('postDate', descending: true)
        .getDocuments();
    if(postSnapshot.documents.isEmpty) {
      return null;
    }
    else {
      return postSnapshot.documents.map((post) => new Post.fromJson(post.data)).toList();
    }
  }

  Future<List<Post>> getPostByUser(User user) async {
    QuerySnapshot postSnapshot = await Firestore.instance
        .collection('Post')
        .where('userId', isEqualTo: user.id)
        .orderBy('postDate', descending: true)
        .getDocuments();
    if(postSnapshot.documents.isEmpty) {
      return null;
    }
    else {
      return postSnapshot.documents.map((post) => new Post.fromJson(post.data)).toList();
    }
  }

  Future<List<Post>> getHomePost() async {
    QuerySnapshot postSnapshot = await Firestore.instance
        .collection('Post')
        .orderBy('postDate', descending: true)
        .limit(10)
        .getDocuments();
    if(postSnapshot.documents.isEmpty) {
      return null;
    }
    else {
      return postSnapshot.documents.map((post) => new Post.fromJson(post.data)).toList();
    }
  }

  Future<List<Post>> getPostByActivity(Activity activity) async {
    QuerySnapshot postSnapshot = await Firestore.instance
        .collection('Post')
        //.where('activityType', isEqualTo: activity.activityType)
        .where('activityId', isEqualTo: activity.id)
        .orderBy('postDate', descending: true)
        .getDocuments();
    if(postSnapshot.documents.isEmpty) {
      return null;
    }
    else {
      return postSnapshot.documents.map((post) => new Post.fromJson(post.data)).toList();
    }
  }

  Future<void> deletePost(Post post) async{
    print('aaaaaaaa');
    print(post.postId);
    print(post.coverDownloadUrl);
    print(post.mediaDownloadUrl);
    print(post.cacheMediaPath);
    // delete document
    await Firestore.instance.collection('Post')
        .where("postId", isEqualTo: post.postId)
        .getDocuments().then((snapshot){
      snapshot.documents.first.reference.delete();
      print('Successfully deleted document' );
    });

    // delete file from storage
    StorageReference ref = await FirebaseStorage().getReferenceFromUrl(post.mediaDownloadUrl);
    await ref.delete();
    print('deleting media... ' + post.mediaDownloadUrl);
    print('Successfully deleted MEDIA storage item');

    if(post.uploadMediaType == 'video') {
      ref = await FirebaseStorage().getReferenceFromUrl(post.coverDownloadUrl);
      await ref.delete();
      print('deleting cover... ' + post.coverDownloadUrl);
      print('Successfully deleted COVER storage item');
    }

    // delete from cache
    if(await File(post.cacheMediaPath).exists()) {
      File(post.cacheMediaPath).delete();
      print('Successfully deleted ' + post.cacheMediaPath + ' cache');
    }
  }

  Future<List<Comment>> getListComment(String postId) async {
    QuerySnapshot postSnapshot;
    if(postId == null || postId == '') {
      postSnapshot = await Firestore.instance
          .collection('Comment')
          .orderBy('date', descending: true)
          .getDocuments();
    } else {
      postSnapshot = await Firestore.instance
          .collection('Comment')
          .where('postId', isEqualTo: postId)
          .orderBy('date', descending: true)
          .getDocuments();
    }

    if(postSnapshot.documents.isEmpty) {
      return null;
    }
    else {
      return postSnapshot.documents.map((comment) => new Comment.fromJson(comment.data)).toList();
    }
  }

  Future<void> postComment(Comment newComment) async {
    final CollectionReference ref = Firestore.instance.collection('Comment');
    ref.document().setData(newComment.toJson());
  }

  Future<List<Like>> getAllLikes() async {
    QuerySnapshot postSnapshot = await Firestore.instance
        .collection('Like')
        .getDocuments();
    if(postSnapshot.documents.isEmpty) {
      return null;
    }
    else {
      return postSnapshot.documents.map((like) => new Like.fromJson(like.data)).toList();
    }
  }

  void likePost(Post post, String userId) {
    Like like = new Like();
    like.postId = post.postId;
    like.likedUserId = userId;
    final CollectionReference ref = Firestore.instance.collection('Like');
    ref.document().setData(like.toJson());
  }

  void dislikePost(Post post, String userId) {
    Firestore.instance.collection('Like')
        .where("likedUserId", isEqualTo: userId).where("postId", isEqualTo: post.postId)
        .getDocuments().then((snapshot){
      snapshot.documents.first.reference.delete();
    });
  }

  Future<void> deleteComment(String commentId) async{
    Firestore.instance.collection('Comment')
        .where("commentId", isEqualTo: commentId)
        .getDocuments().then((snapshot){
      snapshot.documents.first.reference.delete();
    });
  }
}