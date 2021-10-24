import 'package:cached_network_image/cached_network_image.dart';
import 'package:education/core/classes/post.dart';
import 'package:education/core/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GalleryPostMinimalWidget extends StatefulWidget {
  final Post post;

  GalleryPostMinimalWidget({@required this.post});

  @override
  _GalleryPostMinimalWidgetState createState() => _GalleryPostMinimalWidgetState();
}

class _GalleryPostMinimalWidgetState extends State<GalleryPostMinimalWidget> {
  _GalleryPostMinimalWidgetState({Key key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/post_detail', arguments: widget.post).then((value) => setState(() {}));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              child: Stack(children: [
                // IMAGE, VIDEO
                // MEDIA
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 180,
                    height: 160,
                    child: widget.post.coverDownloadUrl != null
                        ? CachedNetworkImage(
                      imageUrl: widget.post.coverDownloadUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                        : Center(
                      child: Icon(Icons.ondemand_video, size: 70, color: Color(0xff36c1c8)),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(5, 5, 0, 10),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
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
                          height: 17,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                            child: Row(
                              children: [
                                Icon(Icons.person, color: Colors.black54, size: 11),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 3),
                        // USER NAME
                        Text(widget.post.userName, style: GoogleFonts.kurale(fontSize: 10, color: Colors.black87, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
              child: Text(widget.post.activity.name,
                  style: GoogleFonts.kurale(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500)),

            ),
          ],
        )
    );
  }
}
