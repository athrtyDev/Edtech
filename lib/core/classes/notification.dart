class Notification {
  String id;
  String postId;
  String userId;
  String userName;
  String userProfilePic;
  String userType;
  String comment;
  DateTime date;

  Notification({this.id, this.postId, this.userId, this.userName, this.userProfilePic, this.userType, this.comment});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['postId'];
    userId = json['userId'];
    userName = json['userName'];
    userProfilePic = json['userProfilePic'];
    userType = json['userType'];
    comment = json['comment'];
    date = json['date'] == null ? (DateTime.parse(json['date'].toDate().toString())) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['postId'] = this.postId;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['userProfilePic'] = this.userProfilePic;
    data['userType'] = this.userType;
    data['comment'] = this.comment;
    data['date'] = this.date ?? DateTime.now();
    return data;
  }
}