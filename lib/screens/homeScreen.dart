import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gotrack_flutter/components/activeTrackingList.dart';

import 'package:gotrack_flutter/providers/activeTrackingListProvider.dart';

import 'package:gotrack_flutter/globals.dart' as globals;
import 'package:gotrack_flutter/providers/mainBottomNavBarProvider.dart';
import 'package:gotrack_flutter/providers/trackingNumberInputProvider.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchTnController;
  UniqueKey uniqKey = UniqueKey();

  void initState() {
    super.initState();
    _searchTnController = TextEditingController(text: '');
    globals.screenRefreshMapping['homeScreen'] = refresh;
  }

  void dispose() {
    _searchTnController.clear();
    _searchTnController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {
      uniqKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build1');
    final activeTrackingListProv =
        Provider.of<ActiveTrackingListProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Text(widget.title),
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 40,
              ),
              child: Container(
                // margin: EdgeInsets.only(top: 15),
                color: Theme.of(context).primaryColor,
                child: TextField(
                    cursorColor: Theme.of(context).dividerColor,
                    cursorWidth: 1.5,
                    controller: _searchTnController,
                    autofocus: false,
                    onChanged: (text) {
                      activeTrackingListProv.setSearchText(text);
                    },
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Theme.of(context).dividerColor,
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).primaryColor,
                      filled: true,
                      hintText: 'Tracking No or Remark',
                      hintStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).dividerColor,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      suffixIcon: IconButton(
                        iconSize: 20,
                        onPressed: () {
                          _searchTnController.clear();
                          activeTrackingListProv.setSearchText('');
                        },
                        icon: Icon(Icons.clear),
                        color: Theme.of(context).dividerColor,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                        color: Theme.of(context).dividerColor,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        // margin: EdgeInsets.only(bottom: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await globals.preload();
                  activeTrackingListProv.refresh();
                },
                child: ActiveTrackingList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () async {
            try {
              String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                  "#ff6666", "Cancel", true, ScanMode.DEFAULT);

              if (barcodeScanRes == '-1') {
              } else {
                Provider.of<TrackingNumberInputProvider>(context, listen: false)
                    .setText(barcodeScanRes.toUpperCase());
                Provider.of<MainBottomNavBarProvider>(context, listen: false)
                    .setCurrentIndex(1);
              }
            } catch (err) {
              print('Caught error: $err');
            }
          },
          tooltip: 'Track',
          child: Icon(CupertinoIcons.barcode_viewfinder),
        ),
      ),
    );
  }
}
