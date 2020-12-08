import 'dart:io';

class PickedMedia {
  String mediaStr;
  String type;        // image, video
  File storageFile;

  PickedMedia({this.mediaStr, this.type, this.storageFile});
}