import 'package:education/core/classes/activity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/core/viewmodels/activity_home_model.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flutter/foundation.dart';

class ActivityHomeView extends StatefulWidget {
  String activityType;
  ActivityHomeView({@required this.activityType});

  @override
  _ActivityHomeViewState createState() => _ActivityHomeViewState();
}

class _ActivityHomeViewState extends State<ActivityHomeView> {
  _ActivityHomeViewState({Key key});

  ScrollController scrollViewController;

  @override
  void initState() {
    super.initState();
    scrollViewController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ActivityHomeModel>(
      onModelReady: (model) => model.getActivityList(widget.activityType),
      builder: (context, model, child) => WillPopScope(
          onWillPop: () {
            Navigator.of(context).pushNamedAndRemoveUntil('/mainPage', (Route<dynamic> route) => false);
            return new Future.value(true);
          },
          child: Scaffold(
            backgroundColor: model.allActivity == null ? Colors.white : Colors.grey[300],
            body: SafeArea(
              child: model.state == ViewState.Busy
                  ? Container(child: Center(child: CircularProgressIndicator()))
                  : Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: model.allActivity == null ? Center(child: Image.asset('lib/ui/images/no_post.png', height: 450)) :
                      GridView.count(
                        controller: scrollViewController,
                        crossAxisCount: 2,
                        //childAspectRatio: 1,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        crossAxisSpacing: 6.0,
                        mainAxisSpacing: 8.0,
                        children: model.allActivity.map((Activity activity) {
                          return Hero(
                            tag: 'activity_' + activity.id,
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    activity.activityType = widget.activityType;
                                    Navigator.pushNamed(context, '/activity_instruction', arguments: activity);
                                  });
                                },
                                child: Stack(children: [
                                  Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child: Container(
                                                width: (MediaQuery.of(context).size.width - 6) / 2,
                                                child: activity.coverImageUrl == null
                                                    ? Center(child: Image.asset('lib/ui/images/loading.gif'))
                                                    : Image.network(activity.coverImageUrl, fit: BoxFit.cover)
                                            )),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(5, 2, 0, 2),
                                              child: Container(
                                                  child: Text(activity.name,
                                                      style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600))),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(20))),
                                                margin: EdgeInsets.fromLTRB(5, 2, 5, 4),
                                                padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                                                //width: 40,
                                                height: 25,
                                                child: Center(child: Text(widget.activityType == 'diy' ? 'Бүтээл' : (widget.activityType == 'discover' ? 'Өөрийгөө нээ' : (widget.activityType == 'dance' ? 'Бүжиг' : '')),
                                                    style: TextStyle(color: Colors.white, fontSize: 11)))),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(0, 0, 10, 3),
                                              child: activity.difficulty == 'easy' ? Image.asset('lib/ui/images/icon_easy.png', height: 20)
                                                  : (activity.difficulty == 'medium' ? Image.asset('lib/ui/images/icon_medium.png', height: 20)
                                                    : (activity.difficulty == 'hard' ? Image.asset('lib/ui/images/icon_hard.png', height: 20) : Text(''))),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ])),
                          );
                        }).toList(),
                      ),
                    ),
            ),
          )),
    );
  }
}
