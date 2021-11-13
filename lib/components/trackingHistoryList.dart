import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gotrack_flutter/components/trackingHistoryListTile.dart';
import 'package:gotrack_flutter/providers/trackingHistoryProvider.dart';
import 'package:provider/provider.dart';

class TrackingHistoryList extends StatelessWidget {
  @override
  const TrackingHistoryList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trackingHistoryProv = Provider.of<TrackingHistoryProvider>(context);
    return ListView.separated(
      itemCount: trackingHistoryProv.trackingHistory.length,
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 2,
      ),
      itemBuilder: (BuildContext context, int index) {
        Map e = trackingHistoryProv.trackingHistory[index];
        bool last = trackingHistoryProv.trackingHistory.length == (index + 1);
        return Container(
          margin: last ? EdgeInsets.only(bottom: 20) : null,
          child: TrackingHistoryListTile(
            trackingNo: e['tracking_no'],
            courier: e['courier'],
          ),
        );
      },
    );
  }
}
