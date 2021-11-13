import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gotrack_flutter/providers/activeTrackingListProvider.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';

import 'package:gotrack_flutter/globals.dart' as globals;
import 'package:gotrack_flutter/services/gotrackAPI.dart' as gotrackAPI;

class TrackingResultScreen extends StatefulWidget {
  TrackingResultScreen({
    this.trackingNo,
    this.courier,
  });

  final String trackingNo;
  final String courier;
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _TrackingResultScreenState createState() => _TrackingResultScreenState();
}

class _TrackingResultScreenState extends State<TrackingResultScreen> {
  double tnFontSize = 16.0;
  Color tnColor = Colors.black;
  Color tnIconColor = Colors.grey;
  List trackingResult = [];
  String trackingNo;
  String courier;
  Map tnAndCourier;
  Map trackingDetail;
  TextEditingController _remarkController;
  UniqueKey uniqKey = UniqueKey();

  Future getTrackingResultWaiting;
  Future getTrackingResult(trackingNo, courier) async {
    String temp = await gotrackAPI.getTracking(trackingNo, courier);
    Map trackingResultObj = jsonDecode(temp);
    if (trackingResultObj.containsKey(courier)) {
      trackingResult = trackingResultObj[courier];
      trackingResult = trackingResult.reversed.toList();
      Map temp = {
        'tracking_no': trackingNo,
        'courier': courier,
        'result': trackingResult.length > 0 ? trackingResult[0] : {},
        'remark': '',
      };
      Provider.of<ActiveTrackingListProvider>(context, listen: false)
          .insertIntoActiveTracking(trackingNo, courier, temp);
    } else {
      String tempDatetime = DateTime.now().toUtc().toString();
      Map temp = {
        'tracking_no': trackingNo,
        'courier': courier,
        'result': {
          "tracking_no": trackingNo,
          "courier": courier,
          "event_date": tempDatetime.toString(),
          "location": "",
          "message": "No status",
          "status": null
        },
        'remark': '',
      };
      Provider.of<ActiveTrackingListProvider>(context, listen: false)
          .insertIntoActiveTracking(trackingNo, courier, temp);
    }
    return trackingResultObj;
  }

  _displayDialog(Map tnAndCourier) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 6,
            backgroundColor: Colors.transparent,
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 24),
                  Text(
                    "Add Parcel description".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'e.g. Name, Grocery, Phone',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, right: 15, left: 15),
                      child: TextFormField(
                        controller: _remarkController,
                        maxLines: 1,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Parcel Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      )),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      RaisedButton(
                        color: Colors.white,
                        child: Text(
                          "Save".toUpperCase(),
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                        onPressed: () {
                          String remark = _remarkController.text.trim();
                          setState(() {
                            trackingDetail['remark'] = remark;
                          });
                          Map temp = {
                            'tracking_no': trackingNo,
                            'courier': courier,
                            'result': trackingResult.length > 0
                                ? trackingResult[0]
                                : {},
                            'remark': remark,
                          };
                          Provider.of<ActiveTrackingListProvider>(context,
                                  listen: false)
                              .updateFromActiveTracking(
                            tnAndCourier['tracking_no'],
                            tnAndCourier['courier'],
                            temp,
                          );
                          return Navigator.of(context).pop(true);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void refresh() {
    setState(() {
      uniqKey = UniqueKey();
    });
  }

  void initState() {
    super.initState();

    trackingNo = widget.trackingNo;
    courier = widget.courier;
    tnAndCourier = {
      'tracking_no': trackingNo,
      'courier': courier,
    };
    trackingDetail = globals.activeTracking.firstWhere(
        (o) =>
            o['tracking_no'] == tnAndCourier['tracking_no'] &&
            o['courier'] == tnAndCourier['courier'],
        orElse: () => {
              'tracking_no': widget.trackingNo,
              'courier': widget.courier,
            });
    _remarkController =
        TextEditingController(text: trackingDetail['remark'] ?? '');
    getTrackingResultWaiting = getTrackingResult(trackingNo, courier);
  }

  @override
  Widget build(BuildContext context) {
    print('build3');
    return Scaffold(
      appBar: AppBar(
        title: Text('Status by Gotrack.my'),
      ),
      body: Container(
        // margin: EdgeInsets.only(bottom: 60),
        color: Colors.white60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 90,
              child: Card(
                child: ListTile(
                  leading: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 44,
                      minHeight: 44,
                      maxWidth: 64,
                      maxHeight: 64,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: globals.allCourierObj[tnAndCourier['courier']]
                          ['logo_url'],
                    ),
                  ),
                  title: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTapDown: (TapDownDetails details) {
                      setState(() {
                        tnColor = Colors.black12;
                        tnIconColor = tnColor;
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      setState(() {
                        tnColor = Colors.black;
                        tnIconColor = Colors.grey;
                      });
                      Clipboard.setData(
                          ClipboardData(text: tnAndCourier['tracking_no']));
                      Fluttertoast.showToast(
                        msg:
                            "${tnAndCourier['tracking_no']} has been copied to clipboard",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red[400],
                        textColor: Colors.white,
                        fontSize: 14.0,
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 5, right: 5, bottom: 5),
                          child: Text(
                            tnAndCourier['tracking_no'],
                            style:
                                TextStyle(color: tnColor, fontSize: tnFontSize),
                          ),
                        ),
                        Container(
                          child: Icon(
                            Icons.copy,
                            size: 14,
                            color: tnIconColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _displayDialog(trackingDetail);
                    },
                    child: Container(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                                text: trackingDetail['remark'] != null &&
                                        trackingDetail['remark'].length > 0
                                    ? trackingDetail['remark']
                                    : 'Add remark? '),
                            WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.0),
                                child: Icon(
                                  Icons.edit,
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: getTrackingResultWaiting,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  // AsyncSnapshot<Your object type>
                  var finalChild;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    finalChild =
                        Center(child: PlatformCircularProgressIndicator());
                  } else {
                    Color lineColor = Color.fromRGBO(16, 196, 82, 1);
                    List trackingResultTemp = [];
                    if (snapshot.hasError) {
                      lineColor = Colors.grey;
                      trackingResultTemp.add({
                        'message': 'No Status',
                        'event_date': DateTime.now().toIso8601String(),
                        'location': '',
                      });
                    } else {
                      trackingResultTemp = [...trackingResult];
                      if (trackingResult.length == 0) {
                        lineColor = Colors.grey;
                        trackingResultTemp.add({
                          'message': 'No Status',
                          'event_date': DateTime.now().toIso8601String(),
                          'location': '',
                        });
                      }
                    }
                    finalChild = ListView(
                      padding: EdgeInsets.only(top: 10),
                      children: trackingResultTemp.map<Widget>((o) {
                        DateTime eventDateUTC8 =
                            DateTime.parse(o['event_date']).toLocal();
                        String formattedTime =
                            DateFormat('hh:mm a').format(eventDateUTC8);
                        String formattedDate =
                            DateFormat('MMM dd, y').format(eventDateUTC8);
                        // print(formattedDate);

                        return TimelineTile(
                          beforeLineStyle:
                              LineStyle(color: lineColor, thickness: 1),
                          afterLineStyle:
                              LineStyle(color: lineColor, thickness: 1),
                          hasIndicator: true,
                          // isFirst: true,
                          indicatorStyle: IndicatorStyle(
                            height: 18,
                            width: 18,
                            color: lineColor,
                            indicatorXY: 0.3,
                            iconStyle: IconStyle(
                              iconData: Icons.circle,
                              color: Colors.white,
                              fontSize: 6,
                            ),
                          ),
                          alignment: TimelineAlign.manual,
                          lineXY: 0.06,
                          endChild: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 15,
                            ),
                            constraints: BoxConstraints(
                              minHeight: 100,
                            ),
                            // color: Colors.lightGreenAccent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topLeft,
                                  // color: Colors.amber,
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: Colors.grey,
                                        decoration: TextDecoration.none,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: formattedDate + ' ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' ' + formattedTime,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 7),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromRGBO(240, 240, 240, 1),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          o['message'],
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text(
                                          o['location'],
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // startChild: Container(
                          //   margin: EdgeInsets.symmetric(
                          //     vertical: 5,
                          //     horizontal: 5,
                          //   ),
                          //   // child: Text(timeago.format(
                          //   //     DateTime.parse(o['event_date']).toLocal())),
                          //   // child: Text(),
                          //   color: Colors.amberAccent,
                          // ),
                        );
                      }).toList(),
                    );
                  }
                  return RefreshIndicator(
                    child: finalChild,
                    onRefresh: () async {
                      setState(() {
                        getTrackingResultWaiting =
                            getTrackingResult(trackingNo, courier);
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
