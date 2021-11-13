import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:search_page/search_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gotrack_flutter/globals.dart' as globals;
import 'package:gotrack_flutter/services/mutateGlobals.dart' as mutate;
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  UniqueKey uniqKey = UniqueKey();
  bool switchValue = true;

  void initState() {
    super.initState();
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
    print('build3');
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Material(
            color: Colors.white,
            child: ListTile(
              // leading: Icon(Icons.person_outline, color: Colors.black87),
              title: Text('User ID'),
              subtitle: Text(
                globals.deviceId,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              onTap: () {
                Clipboard.setData(ClipboardData(text: globals.deviceId));
                Fluttertoast.showToast(
                  msg: "User ID has been copied to clipboard",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red[400],
                  textColor: Colors.white,
                  fontSize: 14.0,
                );
              },
            ),
          ),
          settingDivider(),
          // Material(
          //   color: Colors.white,
          //   child: ListTile(
          //     leading:
          //         Icon(Icons.notifications_outlined, color: Colors.black87),
          //     title: Text('Notification'),
          //     trailing: PlatformSwitch(
          //       onChanged: (bool value) {
          //         setState(() {
          //           switchValue = !switchValue;
          //         });
          //       },
          //       value: switchValue,
          //     ),
          //   ),
          // ),
          Material(
            color: Colors.white,
            child: ListTile(
              leading:
                  Icon(Icons.local_shipping_outlined, color: Colors.black87),
              title: Text('Default Courier'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withAlpha(40),
                          blurRadius: 6.0,
                          spreadRadius: 2.0,
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                    ),
                    width: 120,
                    child: Text(
                      globals.allCourierObj[globals.selectedCourier['code']]
                          ['name'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right),
                ],
              ),
              // trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                showSearch(
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
                        mutate.updatePreferCourier(o['code']);
                        setState(() {
                          globals.selectedCourier = o;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Material(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.privacy_tip, color: Colors.black87),
              title: Text('Privacy Policy'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                _launchURL('https://www.gotrack.my/privacy');
              },
            ),
          ),
          Material(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.article_outlined, color: Colors.black87),
              title: Text('Terms of Service'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                _launchURL('https://www.gotrack.my/terms');
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone_android, color: Colors.black87),
            title: Text('App Version'),
            // trailing: Icon(Icons.keyboard_arrow_right),
            trailing: Text(
                "${globals.packageInfo.version} (${globals.packageInfo.buildNumber})"),
            // isThreeLine: true,
            tileColor: Colors.white,
          ),
          Divider(),
          // Card(
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: <Widget>[
          //       ListTile(
          //         leading: Icon(Icons.phone_android, color: Colors.black87),
          //         title: Text('App Version'),
          //         // trailing: Icon(Icons.keyboard_arrow_right),
          //         subtitle: Text(
          //             "${globals.packageInfo.version} (${globals.packageInfo.buildNumber})"),
          //         // isThreeLine: true,
          //         tileColor: Colors.white,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget settingDivider() {
    return Divider(
      color: Colors.grey[300],
      // indent: 15,
      height: 1,
      thickness: 1.5,
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
