import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:gotrack_flutter/components/activeTrackingListTile.dart';
import 'package:gotrack_flutter/components/homeScreenNativeAd.dart';
import 'package:gotrack_flutter/providers/activeTrackingListProvider.dart';
import 'package:provider/provider.dart';

class ActiveTrackingList extends StatelessWidget {
  @override
  ActiveTrackingList({
    Key key,
  }) : super(key: key);

  Widget _statusTitleBar(String status, String count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            status,
            style: TextStyle(
              color: Colors.red[600],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('  '),
          Badge(
            badgeContent: Text(
              count,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _computeList(BuildContext context) {
    final activeTrackingListProv =
        Provider.of<ActiveTrackingListProvider>(context);
    List<Widget> finalList = [];
    List pendingList = [];
    List receivedList = [];
    for (Map o in activeTrackingListProv.activeTracking) {
      if (o['result'] != null && o['result'].containsKey('status')) {
        if (o['result']['status'] != null &&
            o['result']['status'] == 'delivered') {
          receivedList.add(o);
        } else {
          pendingList.add(o);
        }
      } else {
        pendingList.add(o);
      }
    }

    try {
      if (activeTrackingListProv.searchText.length > 0) {
        pendingList = pendingList
            .where((o) =>
                o['tracking_no']
                    .toLowerCase()
                    .contains(activeTrackingListProv.searchText) ||
                o['remark']
                    .toLowerCase()
                    .contains(activeTrackingListProv.searchText))
            .toList();

        receivedList = receivedList
            .where((o) =>
                o['tracking_no']
                    .toLowerCase()
                    .contains(activeTrackingListProv.searchText) ||
                o['remark']
                    .toLowerCase()
                    .contains(activeTrackingListProv.searchText))
            .toList();
      }
    } catch (err) {
      print('filter error');
    }

    if (pendingList.length > 0) {
      finalList.add(_statusTitleBar('PENDING', '${pendingList.length}'));
      pendingList.forEach((o) {
        // finalList.add(_trackingTile(o));
        finalList.add(ActiveTrackingListTile(activeTrackingObj: o));
      });
    }

    if (pendingList.length > 0 && false) {
      finalList.add(const HomeScreenNativeAd());
    }

    if (receivedList.length > 0) {
      finalList.add(_statusTitleBar('RECEIVED', '${receivedList.length}'));
      receivedList.forEach((o) {
        // finalList.add(_trackingTile(o));
        finalList.add(ActiveTrackingListTile(activeTrackingObj: o));
      });
    }

    finalList.add(Container(
      height: 60,
    ));
    return finalList;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _computeList(context),
    );
  }
}
