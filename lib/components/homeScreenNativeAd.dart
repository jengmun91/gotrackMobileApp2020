import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:gotrack_flutter/models/admobManager.dart';

class HomeScreenNativeAd extends StatefulWidget {
  const HomeScreenNativeAd({Key key}) : super(key: key);

  @override
  _HomeScreenNativeAdState createState() => _HomeScreenNativeAdState();
}

class _HomeScreenNativeAdState extends State<HomeScreenNativeAd> {
  final _nativeAdController = NativeAdmobController();
  double adContainerHeight = 0;
  StreamSubscription _nativeAdsStateSubscription;

  void initState() {
    super.initState();
    _nativeAdController.setTestDeviceIds([
      "BFC5B9CC70D8FA9398C30867DE244995",
      "4D837A5799DB8C4D97E91A5CC2120DB3",
      "33575AD57D3CCAAA3C68A51E306A18E0",
      "42012f3e1072a2bd09781165cafad339",
    ]);
    _nativeAdsStateSubscription =
        _nativeAdController.stateChanged.listen(_onStateChanged);
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          adContainerHeight = 5;
        });
        break;

      case AdLoadState.loadCompleted:
        print('ad load done');
        setState(() {
          adContainerHeight = 90;
        });
        break;

      default:
        break;
    }
  }

  void dispose() {
    _nativeAdsStateSubscription.cancel();
    _nativeAdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: adContainerHeight,
      child: NativeAdmob(
        adUnitID: AdmobManager.nativeAdUnitId,
        loading: Container(),
        error: Container(),
        controller: _nativeAdController,
        type: NativeAdmobType.banner,
        options: NativeAdmobOptions(
          bodyTextStyle: NativeTextStyle(
            backgroundColor: Colors.white,
            color: Colors.white,
          ),
          ratingColor: Colors.yellow,
          // Others ...
        ),
      ),
    );
  }
}
