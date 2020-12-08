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
  ScrollController topScrollViewController;
  PageController _pageController;
  int _selectedPageTab;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    scrollViewController = ScrollController();
    /*scrollViewController.addListener(() {
      if (scrollViewController.position.maxScrollExtent == scrollViewController.offset)
        loadMorePosts();
    });*/
    topScrollViewController = ScrollController();
    _pageController = PageController();
    _selectedPageTab = 0;
  }

  @override
  void dispose() {
    super.dispose();
    if (scrollViewController != null) scrollViewController.dispose();
    if (topScrollViewController != null) topScrollViewController.dispose();
    if (_pageController != null) _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<GalleryModel>(
      onModelReady: (model) => model.loadPostsByUser(context),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _pageController.jumpToPage(0);
                          });
                        },
                        child: Container(
                          padding: _selectedPageTab == 0 ? EdgeInsets.fromLTRB(10, 5, 5, 5) : EdgeInsets.fromLTRB(12, 8, 7, 8),
                          width: MediaQuery.of(context).size.width/2,
                          height: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _selectedPageTab == 0 ? Color(0xff36c1c8) : Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Color(0xff36c1c8).withOpacity(0.7)),
                              /*boxShadow: [
                                BoxShadow(color: Colors.deepOrange.withOpacity(0.4), spreadRadius: 0.4, blurRadius: 9, offset: Offset(5, 5)),
                              ],*/
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 4),
                                  Icon(Icons.star, size: 25, color: _selectedPageTab == 0 ? Colors.white : Colors.grey[400]),
                                  SizedBox(width: 7),
                                  Text('Шилдэг бүтээлүүд', style:
                                  _selectedPageTab == 0 ? GoogleFonts.kurale(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700)
                                      : GoogleFonts.kurale(fontSize: 14, color: Colors.grey[400], fontWeight: FontWeight.w500)
                                  ),
                                ],
                              )
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _pageController.jumpToPage(1);
                          });
                        },
                        child: Container(
                          padding: _selectedPageTab == 1 ? EdgeInsets.fromLTRB(10, 5, 5, 5) : EdgeInsets.fromLTRB(12, 8, 7, 8),
                          width: MediaQuery.of(context).size.width/2,
                          height: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _selectedPageTab == 1 ? Color(0xff36c1c8) : Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Color(0xff36c1c8).withOpacity(0.7)),
                              /*boxShadow: [
                                BoxShadow(color: Colors.deepOrange.withOpacity(0.4), spreadRadius: 0.4, blurRadius: 9, offset: Offset(5, 5)),
                              ],*/
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 4),
                                  Icon(Icons.dashboard, size: 25, color: _selectedPageTab == 1 ? Colors.white : Colors.grey[400]),
                                  SizedBox(width: 7),
                                  Text('Бүх бүтээлүүд', style:
                                  _selectedPageTab == 1 ? GoogleFonts.kurale(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700)
                                      : GoogleFonts.kurale(fontSize: 14, color: Colors.grey[400], fontWeight: FontWeight.w500)
                                  ),
                                ],
                              )
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey[300], thickness: 5),
                  // GALLERY LIST
                  Expanded(
                    child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() => _selectedPageTab = index);
                        },
                        children: <Widget>[
                          // TOP POSTS GALLERY
                          ListView(
                            children: [
                              Container(
                                height: 170,
                                //color: Colors.green,
                                width: MediaQuery.of(context).size.width,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.asset('lib/ui/images/gallery_header.png'),
                                ),
                              ),
                              model.state == ViewState.Busy ? Container(height: 400, child: Center(child: CircularProgressIndicator())) :
                              model.listTopPosts == null ? Center(child: Image.asset('lib/ui/images/no_post.png', height: 350)) :
                              GridView.count(
                                controller: topScrollViewController,
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                crossAxisSpacing: 6,
                                mainAxisSpacing: 6,
                                children: model.listTopPosts.map((Post post) {
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
                          // ALL POSTS GALLERY
                          model.state == ViewState.Busy ? Container(height: 400, child: Center(child: CircularProgressIndicator())) :
                          model.listOtherPosts == null ? Center(child: Image.asset('lib/ui/images/no_post.png', height: 350)) :
                          GridView.count(
                            controller: scrollViewController,
                            crossAxisCount: 2,
                            //childAspectRatio: 1,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                            children: model.listOtherPosts.map((Post post) {
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
                ]),
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
