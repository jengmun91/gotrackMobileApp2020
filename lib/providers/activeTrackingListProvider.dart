import 'package:flutter/material.dart';
import 'package:gotrack_flutter/globals.dart' as globals;
import 'package:gotrack_flutter/services/mutateGlobals.dart' as mutate;

class ActiveTrackingListProvider with ChangeNotifier {
  String searchText = '';
  List activeTracking = [...globals.activeTracking];
  UniqueKey uniqKey;

  void refresh() {
    activeTracking = [...globals.activeTracking];
    notifyListeners();
  }

  void setSearchText(String value) {
    searchText = value;
    notifyListeners();
  }

  void setActiveTracking(List list) {
    activeTracking = list;
    notifyListeners();
  }

  void insertIntoActiveTracking(String trackingNo, String courier, Map obj) {
    mutate.insertIntoActiveTracking(trackingNo, courier, obj);
    bool isExist = activeTracking
        .any((o) => o['tracking_no'] == trackingNo && o['courier'] == courier);

    if (!isExist) {
      activeTracking.insert(0, obj);
    }
    notifyListeners();
  }

  void removeFromActiveTracking(String trackingNo, String courier) {
    mutate.removeFromActiveTracking(trackingNo, courier);
    int index = activeTracking.indexWhere(
        (o) => o['tracking_no'] == trackingNo && o['courier'] == courier);
    if (index >= 0) {
      activeTracking.removeAt(index);
    }
    notifyListeners();
  }

  void updateFromActiveTracking(String trackingNo, String courier, Map obj) {
    mutate.updateFromActiveTracking(trackingNo, courier, obj);
    int index = activeTracking.indexWhere(
        (o) => o['tracking_no'] == trackingNo && o['courier'] == courier);
    if (index >= 0) {
      activeTracking[index] = obj;
    }
    notifyListeners();
  }
}
