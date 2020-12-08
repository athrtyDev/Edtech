import 'dart:math';

import 'package:education/core/classes/media.dart';

class Activity {
  String id;
  String name;
  String instruction;
  int age;
  int skill;                // biyluuleed awah onoo. Herew 0 baiwal app deer haruulahgui
  String difficulty;        // 0-easy; 1-medium; 2-hard
  int postCount;            // posts from other kids
  //String mediaUrl;        // old. used before carousel media
  String mediaUrlAll;       // combined all media urls
  String mediaUrlAllMeta;   // combined all media urls' info
  String coverImageUrl;     // get form storage
  //String mediaType;       // image or video
  bool autoPlay;
  int version;              // cache version. Updates cache when version mismatches
  // tuslah
  String activityType;      // diy, discover, dance
  List<Media> listMedia;
  String cachePathCoverImg;
  var rng = new Random();

  Activity({this.id, this.name, this.instruction, this.skill, this.difficulty, this.postCount, this.coverImageUrl,
    this.autoPlay, this.mediaUrlAll, this.mediaUrlAllMeta, this.cachePathCoverImg});

  Activity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? null;
    name = json['name'] ?? '';
    instruction = json['instruction'] ?? '';
    age = json['age'] != null ? int.tryParse(json['age'].toString()) : null;
    skill = json['skill'] != null ? int.tryParse(json['skill'].toString()) : null;
    difficulty = json['difficulty'] ?? '';
    //mediaType = json['mediaType'] ?? '';
    postCount = json['postCount'] != null ? int.tryParse(json['postCount'].toString()) : null;
    mediaUrlAll = json['mediaUrlAll'] ?? null;
    mediaUrlAllMeta = json['mediaUrlAllMeta'] ?? null;
    coverImageUrl = json['coverImageUrl'] ?? null;
    autoPlay = json['autoPlay'] ?? false;
    version = json['version'] != null ? int.tryParse(json['version'].toString()) : 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['instruction'] = this.instruction;
    data['skill'] = this.skill;
    data['age'] = this.age;
    //data['mediaType'] = this.mediaType;
    data['difficulty'] = this.difficulty;
    data['postCount'] = this.postCount;
    data['mediaUrlAll'] = this.mediaUrlAll;
    data['mediaUrlAllMeta'] = this.mediaUrlAllMeta;
    data['coverImageUrl'] = this.coverImageUrl;
    data['autoPlay'] = this.autoPlay;
    data['version'] = this.version;
    return data;
  }
}