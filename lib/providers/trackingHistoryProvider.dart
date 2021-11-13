import 'package:flutter/material.dart';
import 'package:gotrack_flutter/globals.dart' as globals;
import 'package:gotrack_flutter/services/mutateGlobals.dart' as mutate;

class TrackingHistoryProvider with ChangeNotifier {
  List trackingHistory = [...globals.trackingHistory];
  UniqueKey uniqKey;

  void refresh() {
    trackingHistory = [...globals.trackingHistory];
    notifyListeners();
  }

  void setActiveTracking(List list) {
    trackingHistory = list;
    notifyListeners();
  }

  void insertIntoTrackingHostory(String trackingNo, String courier) {
    mutate.insertIntoTrackingHostory(trackingNo, courier);
    trackingHistory.insert(
      0,
      {
        'tracking_no': trackingNo,
        'courier': courier,
      },
    );
    if (trackingHistory.length > 20) {
      Iterable temp = globals.trackingHistory.take(20);
      globals.trackingHistory = temp.toList();
    }
    notifyListeners();
  }

  void removeFromTrackingHostory(String trackingNo, String courier) {
    mutate.removeFromTrackingHostory(trackingNo, courier);
    for (int i = 0; i < trackingHistory.length; i++) {
      if (trackingHistory[i]['tracking_no'] == trackingNo &&
          trackingHistory[i]['courier'] == courier) {
        trackingHistory.removeAt(i);
      }
    }
    notifyListeners();
  }

  void removeAllFromTrackingHostory() {
    mutate.removeAllFromTrackingHostory();
    trackingHistory.clear();
    notifyListeners();
  }
}
