class Like {
  String postId;
  String likedUserId;

  Like({this.postId, this.likedUserId});

  Like.initial()
      : postId = null,
        likedUserId = null;

  Like.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    likedUserId = json['likedUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postId'] = this.postId ?? null;
    data['likedUserId'] = this.likedUserId ?? null;
    return data;
  }
}