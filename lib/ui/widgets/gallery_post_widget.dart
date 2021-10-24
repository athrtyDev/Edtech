import 'package:cached_network_image/cached_network_image.dart';
import 'package:education/core/classes/post.dart';
import 'package:education/core/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GalleryPostWidget extends StatefulWidget {
  final Post post;

  GalleryPostWidget({@required this.post});

  @override
  _GalleryPostWidgetState createState() => _GalleryPostWidgetState();
}

class _GalleryPostWidgetState extends State<GalleryPostWidget> {
  _GalleryPostWidgetState({Key key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/post_detail', arguments: widget.post).then((value) => setState(() {}));
        },
        child: Stack(children: [
          // IMAGE, VIDEO
          Column(
            children: [
              // USER INFO
              Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 10),
                child: Row(
                  children: [
                    // PROFILE IMAGE
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.pink.withOpacity(0.7)),
                      ),
                      padding: EdgeInsets.all(2),
                      //width: 40,
                      height: 25,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                        child: Row(
                          children: [
                            Icon(Icons.person, color: Colors.black54, size: 15),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // USER NAME
                    Text(widget.post.userName, style: GoogleFonts.kurale(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              // MEDIA
              Expanded(
                  child: Container(
                    color: Colors.red,
                    width: MediaQuery.of(context).size.width,
                    child: widget.post.coverDownloadUrl != null
                        ? CachedNetworkImage(
                            imageUrl: widget.post.coverDownloadUrl,
                            fit: BoxFit.fitHeight,
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          )
                        : Center(
                            child: Icon(Icons.ondemand_video, size: 70, color: Color(0xff36c1c8)),
                          ),
              )),
              // CHALLENGE NAME
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 2, 0, 2),
                    child: Container(
                        child: Text(widget.post.activity.name,
                            style: GoogleFonts.kurale(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500))),
                  )
                ],
              ),
              // CHALLENGE TYPE, DIFFICULTY
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: widget.post.activity.activityType == 'diy'
                              ? Colors.blue.withOpacity(0.7)
                              : (widget.post.activity.activityType == 'discover'
                                  ? Colors.orange.withOpacity(0.7)
                                  : (widget.post.activity.activityType == 'dance' ? Colors.red.withOpacity(0.7) : Colors.blue.withOpacity(0.6))),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      margin: EdgeInsets.fromLTRB(5, 2, 5, 4),
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      //width: 40,
                      height: 25,
                      child: Center(
                          child: Text(
                              widget.post.activity.activityType == 'diy'
                                  ? 'Бүтээл'
                                  : (widget.post.activity.activityType == 'discover'
                                      ? 'Өөрийгөө нээ'
                                      : (widget.post.activity.activityType == 'dance' ? 'Бүжиг' : '')),
                              style: GoogleFonts.kurale(color: Colors.white, fontSize: 14)))),
                ],
              ),
              Divider(thickness: 4, color: Colors.grey[200]),
            ],
          ),
          // LIKE, COMMENT
          Positioned(
            right: 1,
            bottom: 15,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (widget.post.isUserLiked) {
                    widget.post.dislikePost(widget.post, Provider.of<User>(context).id);
                  } else {
                    widget.post.likePost(widget.post, Provider.of<User>(context).id);
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                width: 73,
                height: 30,
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.post.isUserLiked
                        ? Image.asset('lib/ui/images/icon_love_liked.png', height: 13)
                        : Image.asset('lib/ui/images/icon_love.png', height: 13),
                    SizedBox(width: 4),
                    Text(widget.post.likeCount == null ? '0' : widget.post.likeCount.toString(),
                        style: GoogleFonts.kurale(color: Colors.black54, fontSize: 16)),
                    SizedBox(width: 10),
                    Icon(Icons.comment, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text((widget.post.listComment == null || widget.post.listComment.isEmpty) ? '0' : widget.post.listComment.length.toString(),
                        style: GoogleFonts.kurale(color: Colors.black54, fontSize: 16)),
                  ],
                )),
              ),
            ),
          ),
        ]));
  }
}
