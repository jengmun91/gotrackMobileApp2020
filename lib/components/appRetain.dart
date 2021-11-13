import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

class AppRetainWidget extends StatelessWidget {
  const AppRetainWidget({Key key, this.child}) : super(key: key);

  final Widget child;

  // final _channel = const MethodChannel('com.example/app_retain');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('will pop');
        if (Platform.isAndroid) {
          if (Navigator.of(context).canPop()) {
            print('canpop');
            return true;
          } else {
            // print('sendToBackground');
            // _channel.invokeMethod('sendToBackground');
            // return false;
            return true;
          }
        } else {
          return true;
        }
      },
      child: child,
    );
  }
}
