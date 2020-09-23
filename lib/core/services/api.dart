import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education/core/classes/activity.dart';
import 'package:education/core/classes/item.dart';
import 'package:education/core/classes/order.dart';
import 'package:education/core/classes/post.dart';
import 'package:http/http.dart' as http;
import 'package:education/core/classes/user.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Api {
  static const endpoint = 'https://jsonplaceholder.typicode.com';
  var client = new http.Client();

  Future<User> getUserProfile(int userId) async {
    // Get user profile for id
    var response = await client.get('$endpoint/users/$userId');
    // Convert and return
    return User.fromJson(json.decode(response.body));
  }

  Future<List<Activity>> getAllActivity(String activityType) async {
    QuerySnapshot itemSnapshot = await Firestore.instance
        .collection('Activity_' + activityType)
        .getDocuments();

    if(itemSnapshot.documents.isEmpty)
      return null;
    else
      return itemSnapshot.documents.map((activity) => new Activity.fromJson(activity.data)).toList();
  }

  Future<bool> savePost(Post post, File file) async{
    try {
      // compress media
      /*if(post.uploadMediaType == 'video') {
        print('File compress video starting... ' + DateTime.now().toString());
        final _flutterVideoCompress = FlutterVideoCompress();
        final info = await _flutterVideoCompress.compressVideo(
          file.path,
          quality: VideoQuality.DefaultQuality, // default(VideoQuality.DefaultQuality)
          deleteOrigin: false, // default(false)
        );
        file = info.file;
        print('File compress video success... ' + DateTime.now().toString());
      }*/


      // save media to storage
      print('File upload starting... ' + DateTime.now().toString());
      String postId = Uuid().v4();
      StorageUploadTask uploadTask = await FirebaseStorage.instance
          .ref()
          .child("post/" + post.user.name + '_' + post.user.id +"/" + post.activity.activityType + "_" + post.activity.id + "_" + postId)
          .putFile(file, StorageMetadata(contentType: post.uploadMediaType == 'image' ? 'image/jpeg' : 'video/mp4'));

      String downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      print('File upload success! ' + DateTime.now().toString());

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
      return true;
    }
    catch(e) {
      print('SavePost function error:' + e);
      return false;
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

  Future<List<Order>> getCurrentOrders(int futureDays) async {
    DateTime now = DateTime.now();
    String startDay, endDay;
    startDay = now.toString().substring(0,10);
    endDay = now.add(Duration(days: futureDays)).toString();

    QuerySnapshot itemSnapshot = await Firestore.instance
        .collection('Order')
        .orderBy('order_day')
        .startAt([startDay])
        .endAt([endDay + '\uf8ff'])
        .getDocuments();

    if(itemSnapshot.documents.isEmpty)
      return null;
    else
      return itemSnapshot.documents.map((item) => new Order.fromJson(item.data, 'currentOrders')).toList();
  }


  Future<bool> saveOrder(Order order) async{
    try {
      // prepare order data
      Map<String, dynamic> orderMap = null;
      String orderId = Uuid().v1();
      orderMap['id'] = orderId;

      // order -> batch
      var db = Firestore.instance;
      DocumentReference orderReference = db.collection("Order").document();
      WriteBatch batch = db.batch();
      batch.setData(orderReference, orderMap);

      // orderItemList -> batch
      List<Item> listItem = order.listItem;
      for (var item in listItem) {
        var itemMap = item.toJson();
        itemMap['order_id'] = orderId;
        print('itemmmmmmmmmmmmmmm: ' + item.name);
        DocumentReference itemReference = db.collection("OrderItem").document();
        batch.setData(itemReference, itemMap);
      }

      // execute batch
      print('1 before batch commit');
      await batch.commit().then((value) {
        print('2 Done?');
      }).catchError((error) {
        print('errory: ' + error);
      });
      print("3 after apiiiiiiiiiiii return:");
      return true;
    }
    catch(e) {
      print("error on save order: " + e);
      return false;
    }
  }

}