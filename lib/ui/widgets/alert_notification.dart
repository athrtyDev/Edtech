import 'package:flutter/material.dart';

class AlertWidget extends StatelessWidget {
  AlertWidget(
      {Key key,
      @required this.title,
      @required this.content,
      @required this.actionText1,
      @required this.actionRoute1,
        this.actionText2,
        this.actionRoute2})
      : super(key: key);

  final String title;
  final String content;
  final String actionText1;
  final String actionRoute1;
  final String actionText2;
  final String actionRoute2;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        FlatButton(
          child: Text(actionText1),
          onPressed: () {
            if(actionRoute1 != null && actionRoute1 != '')
              Navigator.pushNamed(context, actionRoute1);
            else
              Navigator.pop(context);
          },
        ),
        actionText2 != null
            ? FlatButton(
                child: Text(actionText2),
                onPressed: () {
                  if(actionRoute2 != null && actionRoute2 != '')
                    Navigator.pushNamed(context, actionRoute2);
                  else
                    Navigator.pop(context);
                },
              )
            : Container(),
      ],
    );
  }
}
