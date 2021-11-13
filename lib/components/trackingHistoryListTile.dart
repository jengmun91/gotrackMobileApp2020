import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gotrack_flutter/providers/trackingHistoryProvider.dart';
import 'package:gotrack_flutter/screens/trackingResultScreen.dart';
import 'package:gotrack_flutter/globals.dart' as globals;
import 'package:provider/provider.dart';

class TrackingHistoryListTile extends StatelessWidget {
  @override
  const TrackingHistoryListTile({
    Key key,
    @required this.trackingNo,
    @required this.courier,
  }) : super(key: key);
  final String trackingNo;
  final String courier;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: ListTile(
        enabled: true,
        leading: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 44,
            minHeight: 44,
            maxWidth: 54,
            maxHeight: 54,
          ),
          child: CachedNetworkImage(
            imageUrl: globals.allCourierObj[courier]['logo_url'],
          ),
        ),
        title: Text(
          trackingNo,
          textAlign: TextAlign.left,
        ),
        trailing: IconButton(
          icon: Icon(CupertinoIcons.xmark_circle),
          color: Colors.black26,
          iconSize: 20,
          onPressed: () {
            Provider.of<TrackingHistoryProvider>(context, listen: false)
                .removeFromTrackingHostory(trackingNo, courier);
            // setState(() {
            //   mutate.removeFromTrackingHostory(trackingNo, courier);
            // });
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrackingResultScreen(
                  trackingNo: trackingNo, courier: courier),
            ),
          );
        },
      ),
    );
  }
}
