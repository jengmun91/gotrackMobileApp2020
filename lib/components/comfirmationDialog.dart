import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ConfirmationDialog extends StatelessWidget {
  ConfirmationDialog({
    @required this.onYes,
    @required this.onNo,
    this.title,
    this.content,
  });
  final GestureTapCallback onYes;
  final GestureTapCallback onNo;
  final Text title;
  final Text content;

  @override
  Widget build(BuildContext context) {
    // Widget cancelButton = FlatButton(
    //   child: Text("No"),
    //   onPressed: onNo,
    // );
    // Widget continueButton = FlatButton(
    //   child: Text("Yes"),
    //   onPressed: onYes,
    // );

    // return AlertDialog(
    //   title: title,
    //   content: content,
    //   actions: [
    //     cancelButton,
    //     continueButton,
    //   ],
    // );

    return PlatformAlertDialog(
      title: title,
      content: content,
      actions: <Widget>[
        PlatformDialogAction(
          child: Text("No"),
          onPressed: onNo,
        ),
        PlatformDialogAction(
          child: Text("Yes"),
          onPressed: onYes,
        ),
      ],
    );
  }
}
