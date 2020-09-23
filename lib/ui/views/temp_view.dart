import 'package:flutter/material.dart';
import 'package:education/core/enums/view_state.dart';
import 'package:education/ui/views/base_view.dart';
import 'package:flutter/foundation.dart';
import 'package:education/core/viewmodels/home_model.dart';

class TempView extends StatefulWidget {
  TempView({Key key}) : super(key: key);

  @override
  _TempViewState createState() => _TempViewState();
}

class _TempViewState extends State<TempView> {
  _TempViewState({Key key});

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
        builder: (context, model, child) => Scaffold(
                body: SafeArea(
                    child: model.state == ViewState.Busy
                        ? Container(child: Center(child: CircularProgressIndicator()))
                        : Container()
                ),
              ),
            );
  }
}