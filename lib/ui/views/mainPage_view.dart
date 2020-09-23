import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:education/core/viewmodels/main_page_model.dart';
import 'package:education/ui/views/home_view.dart';
import 'package:education/ui/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flutter/foundation.dart';

class MainPageView extends StatefulWidget {
  MainPageView({Key key}) : super(key: key);

  @override
  _MainPageViewState createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  _MainPageViewState({Key key});

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  PageController _pageController;
  DateTime currentBackPressTime;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BaseView<MainPageModel>(
        //onModelReady: (model) => model.initHomeView(widget.uploadingPost),
        builder: (context, model, child) => WillPopScope(
              onWillPop: onWillPop,
              child: SafeArea(
                child: Scaffold(
                    backgroundColor: Colors.white,
                    body: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() => _currentIndex = index);
                      },
                      children: <Widget>[
                        HomeView(),
                        Container(color: Colors.green),
                        ProfileView(),
                      ],
                    ),
                    bottomNavigationBar: BottomNavyBar(
                      selectedIndex: _currentIndex,
                      onItemSelected: (index) {
                        setState(() => _currentIndex = index);
                        _pageController.jumpToPage(index);
                      },
                      items: <BottomNavyBarItem>[
                        BottomNavyBarItem(
                          title: Text('Нүүр'),
                          icon: Icon(Icons.home),
                          activeColor: Colors.deepOrange,
                          inactiveColor: Colors.black54,
                        ),
                        BottomNavyBarItem(
                          title: Text('Gallery'),
                          icon: Icon(Icons.photo_library),
                          activeColor: Colors.deepOrange,
                          inactiveColor: Colors.black54,
                        ),
                        BottomNavyBarItem(
                          title: Text('Profile'),
                          icon: Icon(Icons.person),
                          activeColor: Colors.deepOrange,
                          inactiveColor: Colors.black54,
                        ),
                      ],
                    )),
              ),
            ));
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime != null && now.difference(currentBackPressTime) < Duration(seconds: 1)) {
      currentBackPressTime = now;
      SystemNavigator.pop();
      return Future.value(false);
    }
    currentBackPressTime = now;
    return Future.value(false);
  }
}