import 'dart:math';

class Activity {
  String id;
  String name;
  String instruction;
  int age;
  int skill;             // science, cooking, build, intellectual, social etc
  String difficulty;           // 0-easy; 1-medium; 2-hard
  int postCount;            // posts from other kids
  String mediaUrl;          // get form storage
  String coverImageUrl;     // get form storage
  String mediaType;
  bool autoPlay;
  // tuslah
  String activityType;      // diy, discover, dance
  var rng = new Random();

  Activity({this.id, this.name, this.instruction, this.skill, this.difficulty, this.postCount, this.coverImageUrl,
    this.mediaUrl, this.mediaType, this.autoPlay});

  Activity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? null;
    name = json['name'] ?? '';
    instruction = json['instruction'] ?? '';
    age = json['age'] != null ? int.tryParse(json['age'].toString()) : null;
    skill = json['skill'] != null ? int.tryParse(json['skill'].toString()) : null;
    difficulty = json['difficulty'] ?? '';
    mediaType = json['mediaType'] ?? '';
    postCount = json['postCount'] != null ? int.tryParse(json['postCount'].toString()) : null;
    mediaUrl = json['mediaUrl'] ?? null;
    coverImageUrl = json['coverImageUrl'] ?? null;
    autoPlay = json['autoPlay'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['instruction'] = this.instruction;
    data['skill'] = this.skill;
    data['age'] = this.age;
    data['mediaType'] = this.mediaType;
    data['difficulty'] = this.difficulty;
    data['postCount'] = this.postCount;
    data['mediaUrl'] = this.mediaUrl;
    data['coverImageUrl'] = this.coverImageUrl;
    data['autoPlay'] = this.autoPlay;
    return data;
  }
}