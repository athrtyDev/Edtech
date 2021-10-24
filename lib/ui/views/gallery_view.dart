import 'package:education/core/classes/post.dart';
import 'package:education/core/viewmodels/gallery_model.dart';
import 'package:education/ui/widgets/gallery_post_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';

class GalleryView extends StatefulWidget {
  GalleryView({Key key}) : super(key: key);

  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  _GalleryViewState({Key key});

  ScrollController scrollViewController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    scrollViewController = ScrollController();
    /*scrollViewController.addListener(() {
      if (scrollViewController.position.maxScrollExtent == scrollViewController.offset)
        loadMorePosts();
    });*/
  }

  @override
  void dispose() {
    super.dispose();
    if (scrollViewController != null) scrollViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<GalleryModel>(
      onModelReady: (model) => model.loadPostsByUser(context),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ListView(
            children: [
              model.state == ViewState.Busy
                  ? Container(height: 400, child: Center(child: CircularProgressIndicator()))
                  : model.listPosts == null
                      ? Center(child: Image.asset('lib/ui/images/no_post.png', height: 350))
                      : GridView.count(
                          controller: scrollViewController,
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          children: model.listPosts.map((Post post) {
                            return Hero(
                              tag: 'activity_' + post.postId,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Navigator.pushNamed(context, '/post_detail', arguments: post).then((value) => setState(() {}));
                                    });
                                  },
                                  child: GalleryPostWidget(post: post)),
                            );
                          }).toList(),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  loadMorePosts() async {
    if (!isLoading) {
      setState(() => isLoading = true);
      print('loooooooooooooooooooooading...');
      /*if (datas.length >= 79) {
        await Future.delayed(Duration(seconds: 3));
        setState(() => isLoading = false);
        await makeAnimation();
        scaffoldKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('Get max data!'),
          ),
        );
        return;
      }*/
      /*final newDatas = await fetchDatas(datas.length + 1, datas.length + 21);
      datas.addAll(newDatas);*/
      isLoading = false;
      setState(() {});
    }
  }
}
