import 'dart:async';

import 'package:gotrack_flutter/globals.dart' as globals;
import 'package:gotrack_flutter/services/gotrackAPI.dart' as gotrackAPI;

void backgroundMain() async {
  print('background start');
  try {
    String deviceId = await globals.getDevideId();
    await gotrackAPI.checkActiveTracking(deviceId);
  } catch (err) {
    print(err);
  }
  print('background end');
}

Future getTracking(List activeTracking) async {
  await globals.preload();
  print(activeTracking);
  for (int i = 0; i < activeTracking.length; i++) {
    String trackingNo = activeTracking[i]['tracking_no'];
    String courier = activeTracking[i]['courier'];
    String newTracking = await gotrackAPI.getTracking(trackingNo, courier);
    print(newTracking);
  }
}
