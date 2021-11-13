import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          // DrawerHeader(
          //   child: Text(
          //     globals.deviceId,
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   decoration: BoxDecoration(
          //     color: mainColor,
          //   ),
          // ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Image.asset(
              'assets/splash/splashScreen.png',
              // width: 20.0,
              height: 100.0,
              fit: BoxFit.scaleDown,
            ),
          ),
          Divider(color: Colors.grey),
          // ListTile(
          //   title: Text('Item 1'),
          //   onTap: () {
          //     // Update the state of the app
          //     // ...
          //     print('item 1');
          //     Navigator.pop(context);
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => AddItemScreen(),
          //       ),
          //     );
          //     // Then close the drawer
          //   },
          // ),
          // Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.privacy_tip_outlined, color: Colors.black87),
            title: Text('Privacy Policy'),
            // selected: _selectedDestination == 1,
            onTap: () => _launchURL('https://www.gotrack.my/privacy'),
          ),
          ListTile(
            leading: Icon(Icons.article_outlined, color: Colors.black87),
            title: Text('Terms of Service'),
            // selected: _selectedDestination == 1,
            onTap: () => _launchURL('https://www.gotrack.my/terms'),
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined, color: Colors.black87),
            title: Text('Settings'),
            // selected: _selectedDestination == 1,
            // onTap: () => selectDestination(1),
          ),
        ],
      ),
    );
  }

  // void selectDestination(int index) {
  //   setState(() {
  //     _selectedDestination = index;
  //   });
  // }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true, enableJavaScript: true);
    } else {
      throw 'Could not launch $url';
    }
  }
}
