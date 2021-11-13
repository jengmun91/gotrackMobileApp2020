import 'dart:convert';

import 'package:gotrack_flutter/globals.dart' as globals;
import 'package:gotrack_flutter/services/gotrackAPI.dart' as gotrackAPI;

void insertIntoTrackingHostory(String trackingNo, String courier) {
  globals.trackingHistory.insert(
    0,
    {
      'tracking_no': trackingNo,
      'courier': courier,
    },
  );
  if (globals.trackingHistory.length > 20) {
    Iterable temp = globals.trackingHistory.take(20);
    globals.trackingHistory = temp.toList();
  }
  globals.prefs
      .setString('trackingHistory', jsonEncode(globals.trackingHistory));
}

void removeFromTrackingHostory(String trackingNo, String courier) {
  for (int i = 0; i < globals.trackingHistory.length; i++) {
    if (globals.trackingHistory[i]['tracking_no'] == trackingNo &&
        globals.trackingHistory[i]['courier'] == courier) {
      globals.trackingHistory.removeAt(i);
    }
  }
  globals.prefs
      .setString('trackingHistory', jsonEncode(globals.trackingHistory));
}

void removeAllFromTrackingHostory() {
  globals.trackingHistory.clear();
  globals.prefs
      .setString('trackingHistory', jsonEncode(globals.trackingHistory));
}

void insertIntoActiveTracking(String trackingNo, String courier, Map obj) {
  // globals.activeTracking = [];
  bool isExist = globals.activeTracking
      .any((o) => o['tracking_no'] == trackingNo && o['courier'] == courier);

  if (!isExist) {
    globals.activeTracking.insert(
      0,
      obj,
    );
    globals.prefs
        .setString('activeTracking', jsonEncode(globals.activeTracking));

    gotrackAPI.setActiveTracking(globals.deviceId, globals.activeTracking);
  }
}

void removeFromActiveTracking(String trackingNo, String courier) {
  int index = globals.activeTracking.indexWhere(
      (o) => o['tracking_no'] == trackingNo && o['courier'] == courier);
  if (index >= 0) {
    globals.activeTracking.removeAt(index);
    globals.prefs
        .setString('activeTracking', jsonEncode(globals.activeTracking));

    gotrackAPI.setActiveTracking(globals.deviceId, globals.activeTracking);
  }
}

void updateFromActiveTracking(String trackingNo, String courier, Map obj) {
  int index = globals.activeTracking.indexWhere(
      (o) => o['tracking_no'] == trackingNo && o['courier'] == courier);
  if (index >= 0) {
    globals.activeTracking[index] = obj;
    globals.prefs
        .setString('activeTracking', jsonEncode(globals.activeTracking));

    gotrackAPI.setActiveTracking(globals.deviceId, globals.activeTracking);
  }
}

void updatePreferCourier(String courier) {
  globals.prefs.setString('preferCourier', courier);
}

void updateNotificationSetting(Map setting) {}
