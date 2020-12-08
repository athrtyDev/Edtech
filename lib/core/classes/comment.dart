class Comment {
  String postId;
  String userId;
  String userName;
  String userProfilePic;
  String userType;
  String comment;
  DateTime date;

  Comment({this.postId, this.userId, this.userName, this.userProfilePic, this.userType, this.comment});

  Comment.fromJson(Map<String, dynamic> json) {
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