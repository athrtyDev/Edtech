import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education/core/classes/user.dart';

class AuthenticationService {
  StreamController<User> userController = StreamController<User>();

  Future<void> registerKid(User user) async {
    var result = await Firestore.instance
        .collection('User')
        .add(user.toJson());
    //userController.add(user);
  }

  void addRegisteredUserInfoToStream(User user) {
    userController.add(user);
  }

  Future<User> readCustomer(String name, String password) async {
    QuerySnapshot customerSnapshot = await Firestore.instance
        .collection('User')
        .where('name', isEqualTo: name)
        .where('password', isEqualTo: password)
        .getDocuments();

    if(customerSnapshot.documents.isEmpty) {
      return null;
    }
    else {
      User user = User.fromJson(customerSnapshot.documents[0].data);
      //userController.add(user);
      return user;
    }
  }

  Future<bool> checkUserNameExists(String name) async {
    QuerySnapshot customerSnapshot = await Firestore.instance
        .collection('User')
        .where('name', isEqualTo: name)
        .getDocuments();
    return customerSnapshot.documents.isNotEmpty;
  }
}
