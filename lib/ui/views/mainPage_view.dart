import 'package:education/core/classes/user.dart';
import 'package:education/core/services/authentication_service.dart';
import 'package:education/core/viewmodels/main_page_model.dart';
import 'package:education/locator.dart';
import 'package:education/ui/views/gallery_view.dart';
import 'package:education/ui/views/home_view.dart';
import 'package:education/ui/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    getRegisteredUserInfo();
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
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    children: <Widget>[
                      HomeView(),
                      GalleryView(),
                      ProfileView(),
                    ],
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        title: Text('Нүүр', style: GoogleFonts.kurale()),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.photo_library),
                        title: Text('Бүтээлүүд', style: GoogleFonts.kurale()),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        title: Text('Миний', style: GoogleFonts.kurale()),
                      ),
                    ],
                    selectedItemColor: Color(0xff36c1c8),
                    unselectedItemColor: Colors.grey[400],
                    currentIndex: _currentIndex,
                    onTap: (index) {
                      setState(() => _currentIndex = index);
                      _pageController.jumpToPage(index);
                    },
                    selectedFontSize: 13.0,
                    unselectedFontSize: 13.0,
                  ),
                  /*BottomNavyBar(
                      selectedIndex: _currentIndex,
                      onItemSelected: (index) {
                        setState(() => _currentIndex = index);
                        _pageController.jumpToPage(index);
                      },
                      items: <BottomNavyBarItem>[
                        BottomNavyBarItem(
                          title: Text('Нүүр', style: GoogleFonts.kurale()),
                          icon: Icon(Icons.home),
                          activeColor: Color(0xff36c1c8),
                          inactiveColor: Colors.grey[400],
                        ),
                        BottomNavyBarItem(
                          title: Text('Бүтээлүүд', style: GoogleFonts.kurale()),
                          icon: Icon(Icons.photo_library),
                          activeColor: Color(0xff36c1c8),
                          inactiveColor: Colors.grey[400],
                        ),
                        BottomNavyBarItem(
                          title: Text('Миний', style: GoogleFonts.kurale()),
                          icon: Icon(Icons.person),
                          activeColor: Color(0xff36c1c8),
                          inactiveColor: Colors.grey[400],
                        ),
                      ],
                    )*/
                ),
              ),
            ));
  }

  Future<void> getRegisteredUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username');
    print('Username exist on mainPage? ' + (username ?? 'null'));
    if(username != null) {
      setState(() {
        User user = new User(id: prefs.getString('id'), name: prefs.getString('username'), age: prefs.getInt('age'), registeredDate: prefs.getString('registeredDate'), type: prefs.getString('type'));
        final AuthenticationService _authenticationService = locator<AuthenticationService>();
        _authenticationService.addRegisteredUserInfoToStream(user);
      });
    }
  }

  Future<bool> onWillPop() {
    if(_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      _pageController.jumpToPage(0);
    } else {
      DateTime now = DateTime.now();
      if (currentBackPressTime != null && now.difference(currentBackPressTime) < Duration(seconds: 1)) {
        currentBackPressTime = now;
        SystemNavigator.pop();
      }
      currentBackPressTime = now;
    }
    return Future.value(false);
  }
}
