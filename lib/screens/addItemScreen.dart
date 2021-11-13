import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:gotrack_flutter/components/animationToolkit.dart';
import 'package:gotrack_flutter/components/trackingHistoryList.dart';
import 'package:gotrack_flutter/components/trackingNumberInput.dart';
import 'package:gotrack_flutter/globals.dart' as globals;
import 'package:gotrack_flutter/providers/trackingHistoryProvider.dart';
import 'package:gotrack_flutter/providers/trackingNumberInputProvider.dart';
import 'package:gotrack_flutter/services/gotrackAPI.dart' as gotrackAPI;
// import 'package:gotrack_flutter/models/debouncer.dart';
import 'package:gotrack_flutter/screens/trackingResultScreen.dart';
import 'package:gotrack_flutter/components/comfirmationDialog.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  UniqueKey uniqKey = UniqueKey();
  bool isTrackingNo = false;
  // final _debouncer = Debouncer(milliseconds: 500);

  void initState() {
    super.initState();
    if (globals.allCourier.length == 0) {
      gotrackAPI.getSupportCourier().then((value) {
        List temp = jsonDecode(value);
        for (var o in temp) globals.allCourierObj[o['code']] = o;
        setState(() {
          globals.allCourier = temp;
        });
      });
    }
  }

  void dispose() {
    super.dispose();
  }

  void refresh() {
    setState(() {
      uniqKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build2');
    return Scaffold(
      appBar: AppBar(
        title: Text("New shipment"),
        centerTitle: true,
      ),
      body: Container(
        // margin: EdgeInsets.only(bottom: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // tracking number text field and scanner
            Container(
              padding:
                  EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // tracking number text field
                  Expanded(
                    flex: 6,
                    child: Container(
                      child: TrackingNumberInput(key: uniqKey),
                    ),
                  ),
                  // paste button
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          try {
                            ClipboardData temp =
                                await Clipboard.getData('text/plain');
                            String text = temp.text;
                            Provider.of<TrackingNumberInputProvider>(context,
                                    listen: false)
                                .setText(text.toUpperCase());
                            refresh();
                          } catch (err) {
                            print('Caught error: $err');
                          }
                        },
                        tooltip: 'Paste',
                        iconSize: 20,
                        icon: Icon(Icons.paste),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(8)),
                        color: Colors.white,
                      ),
                      child: IconButton(
                        onPressed: () => _scan(),
                        iconSize: 25,
                        icon: Icon(CupertinoIcons.barcode_viewfinder),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // choose courier button
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: chooseCourierButton(),
            ),
            // track & track button
            Container(
              padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: RaisedButton(
                textColor: Colors.white,
                onPressed: () {
                  String inputTn = Provider.of<TrackingNumberInputProvider>(
                          context,
                          listen: false)
                      .text;
                  inputTn = inputTn.replaceAll(new RegExp(r"\s+"), "");
                  if (inputTn.length > 0) {
                    bool isExist = globals.trackingHistory.any((o) =>
                        o['tracking_no'] == inputTn &&
                        o['courier'] == globals.selectedCourier['code']);

                    //only add to tracking history when it not exist
                    if (!isExist) {
                      Provider.of<TrackingHistoryProvider>(context,
                              listen: false)
                          .insertIntoTrackingHostory(
                              inputTn, globals.selectedCourier['code']);
                    }

                    if (globals.selectedCourier.containsKey('code') &&
                        inputTn.length > 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackingResultScreen(
                              trackingNo: inputTn,
                              courier: globals.selectedCourier['code']),
                        ),
                      );
                      Provider.of<TrackingNumberInputProvider>(context,
                              listen: false)
                          .clear();
                      refresh();
                    }
                  }
                },
                child: Text(
                  'TRACK & TRACE',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            // tracking history title
            Container(
              padding: EdgeInsets.only(left: 15, top: 0, right: 15, bottom: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Text(
                      'Tracking History',
                      style: TextStyle(
                        color: Colors.red[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: FlatButton(
                      height: 25,
                      minWidth: 10,
                      onPressed: () {
                        showPlatformDialog(
                          context: context,
                          builder: (_) => ConfirmationDialog(
                            title: Text('Clear Tracking History'),
                            content: Text('Yes to continue, No to cancel'),
                            onYes: () {
                              Provider.of<TrackingHistoryProvider>(context,
                                      listen: false)
                                  .removeAllFromTrackingHostory();
                              Navigator.pop(context);
                            },
                            onNo: () => Navigator.pop(context),
                          ),
                        );
                      },
                      color: Colors.red[50],
                      child: Text(
                        'Clear All',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // tracking history scrollview
            Expanded(
              child: TrackingHistoryList(),
            ),
          ],
        ),
      ),
    );
  }

  Future _scan() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.DEFAULT);

      if (barcodeScanRes == '-1') {
      } else {
        Provider.of<TrackingNumberInputProvider>(context, listen: false)
            .setText(barcodeScanRes.toUpperCase());
        refresh();
      }
    } catch (err) {
      print('Caught error: $err');
    }
  }

  // Future _getSuggestCourier(String trackingNo) async {
  //   try {
  //     if (trackingNo.length > 0) {
  //       String json = await gotrackAPI.getSuggestCourier(trackingNo);
  //       if (json == null) {
  //       } else {
  //         List temp = jsonDecode(json);
  //         List temp2 = [];
  //         for (var each in temp) {
  //           if (globals.allCourierObj[each['textClass']] != null) {
  //             temp2.add(globals.allCourierObj[each['textClass']]);
  //           }
  //         }
  //         if (temp2.length > 0) {
  //           setState(() {
  //             globals.selectedCourier = temp2.first;
  //           });
  //         }
  //       }
  //     }
  //   } catch (err) {
  //     print('Caught error: $err');
  //   }
  // }

  displayCourier() {
    if (globals.selectedCourier.containsKey('code')) {
      return {
        'imageUrl': globals.selectedCourier['logo_url'],
        'name': globals.selectedCourier['name'],
      };
    } else if (globals.allCourier.length > 0) {
      String code = globals.allCourier[0]['code'].replaceAll('_', '-');
      String xsLogoUrl =
          "https://cdn.gotrack.my/courier/logo/xs/${code}_200x100.jpg";
      return {
        'imageUrl': xsLogoUrl,
        'name': globals.allCourier[0]['name'],
      };
    } else {
      return {
        'imageUrl': 'https://www.gotrack.my/goTrackLogo/goTrackLogo7b.png',
        'name': 'SELECT A COURIER',
      };
    }
  }

  chooseCourierButton() {
    return FlatButton(
      child: Row(children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            child: CachedNetworkImage(
              imageUrl: displayCourier()['imageUrl'],
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Text(displayCourier()['name'],
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                )),
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Container(
              child: Text(
                'Change',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: Icon(
              Icons.chevron_right,
              color: Colors.black45,
            ),
          ),
        ),
      ]),
      // open search courier page
      onPressed: () => showSearch(
        context: context,
        delegate: SearchPage(
          items: globals.allCourier,
          searchLabel: 'Search courier',
          showItemsOnEmpty: true,
          suggestion: Center(
            child: Text('Filter courier by name'),
          ),
          failure: Center(
            child: Text('No courier found :('),
          ),
          filter: (eachCourier) => [
            eachCourier['name'],
            eachCourier['code'],
          ],
          builder: (o) => ListTile(
            leading: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 44,
                minHeight: 44,
                maxWidth: 64,
                maxHeight: 64,
              ),
              child: CachedNetworkImage(
                imageUrl: o['logo_url'],
              ),
            ),
            title: Text(
              o['name'],
              textAlign: TextAlign.left,
            ),
            onTap: () {
              setState(() {
                globals.selectedCourier = o;
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Future<bool> checkIsTrackingNo() async {
    try {
      ClipboardData temp = await Clipboard.getData('text/plain');
      String text = temp.text;
      isTrackingNo =
          RegExp(r'^[a-zA-Z0-9]+$').hasMatch(text.toUpperCase().trim());
      return isTrackingNo;
    } catch (err) {
      return false;
    }
  }
}
