import 'package:education/core/services/tool.dart';

class InterfaceDynamic {
  String homeActivityInfo;
  String homeDanceUrl;
  String homeDiscoverUrl;
  String homeDiyUrl;
  String homeGreeting;
  String homePosterUrl;
  String appVersion;

  InterfaceDynamic({this.homeActivityInfo, this.homeDanceUrl, this.homeDiscoverUrl, this.homeDiyUrl,
                      this.homeGreeting, this.homePosterUrl, this.appVersion});

  InterfaceDynamic.fromJson(Map<String, dynamic> json) {
    homeActivityInfo = Tool.nullEmptyString(json['homeActivityInfo']);
    homeDanceUrl = Tool.nullEmptyString(json['homeDanceUrl']);
    homeDiscoverUrl = Tool.nullEmptyString(json['homeDiscoverUrl']);
    homeDiyUrl = Tool.nullEmptyString(json['homeDiyUrl']);
    homeGreeting = Tool.nullEmptyString(json['homeGreeting']);
    homePosterUrl = Tool.nullEmptyString(json['homePosterUrl']);
    appVersion = Tool.nullEmptyString(json['appVersion']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['homeActivityInfo'] = this.homeActivityInfo ?? '';
    data['homeDanceUrl'] = this.homeDanceUrl ?? '';
    data['homeDiscoverUrl'] = this.homeDiscoverUrl ?? '';
    data['homeDiyUrl'] = this.homeDiyUrl ?? '';
    data['homeGreeting'] = this.homeGreeting ?? '';
    data['homePosterUrl'] = this.homePosterUrl ?? '';
    data['appVersion'] = this.appVersion ?? '';
    return data;
  }
}