import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gotrack_flutter/providers/activeTrackingListProvider.dart';
import 'package:gotrack_flutter/screens/trackingResultScreen.dart';
import 'package:intl/intl.dart';
import 'package:gotrack_flutter/globals.dart' as globals;
import 'package:provider/provider.dart';

class ActiveTrackingListTile extends StatelessWidget {
  @override
  const ActiveTrackingListTile({
    Key key,
    @required this.activeTrackingObj,
  }) : super(key: key);
  final Map activeTrackingObj;

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    String formattedTime = '';
    if (activeTrackingObj.containsKey('result') &&
        activeTrackingObj['result'].containsKey('event_date')) {
      if (activeTrackingObj['result']['event_date'] != null) {
        DateTime eventDateUTC8 =
            DateTime.parse(activeTrackingObj['result']['event_date']).toLocal();
        formattedDate = DateFormat('dd MMM y').format(eventDateUTC8);
        formattedTime = DateFormat('hh:mm a').format(eventDateUTC8);
      }
    }
    return Container(
      margin: EdgeInsets.only(bottom: 3),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.20,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrackingResultScreen(
                    trackingNo: activeTrackingObj['tracking_no'],
                    courier: activeTrackingObj['courier']),
              ),
            );
          },
          child: Ink(
            color: Colors.white,
            child: ListTile(
              leading: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 54,
                  minHeight: 54,
                  maxWidth: 54,
                  maxHeight: 54,
                ),
                child: CachedNetworkImage(
                  imageUrl: globals.allCourierObj[activeTrackingObj['courier']]
                      ['logo_url'],
                ),
              ),
              title: Text(
                activeTrackingObj['tracking_no'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      activeTrackingObj.containsKey('result')
                          ? activeTrackingObj['result']['message'] ??
                              'No status'
                          : 'No status',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    child: Text(
                      activeTrackingObj['remark'] ?? '',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              trailing: Container(
                width: 80,
                child: Text(
                  '$formattedDate $formattedTime',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    height: 1.3,
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ),
              isThreeLine: true,
            ),
          ),
        ),
        actions: <Widget>[],
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              Provider.of<ActiveTrackingListProvider>(context, listen: false)
                  .removeFromActiveTracking(activeTrackingObj['tracking_no'],
                      activeTrackingObj['courier']);
            },
          ),
        ],
      ),
    );
  }
}
