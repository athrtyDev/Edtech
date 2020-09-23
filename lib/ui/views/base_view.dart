import 'package:flutter/material.dart';
import 'package:education/locator.dart';
import 'package:provider/provider.dart';
import '../../core/viewmodels/base_model.dart';

class BaseView<T extends BaseModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Function(T) onModelReady;
  final Function(T) didUpdate;

  BaseView({this.builder, this.onModelReady, this.didUpdate});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  T model = locator<T>();

  @override
  void initState() {
    if(widget.onModelReady != null) {
      widget.onModelReady(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
        builder: (context) => model,
        child: Consumer<T>(builder: widget.builder));
  }

  @override
  void didUpdateWidget(BaseView<T> oldWidget) {
    if(widget.didUpdate != null) {
      widget.didUpdate(model);
    }
    super.didUpdateWidget(oldWidget);
  }
}