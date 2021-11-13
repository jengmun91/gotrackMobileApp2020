import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gotrack_flutter/providers/activeTrackingListProvider.dart';
import 'package:gotrack_flutter/providers/trackingNumberInputProvider.dart';
import 'package:gotrack_flutter/screens/settingScreen/index.dart';

//import OneSignal
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'package:sentry/sentry.dart';

import 'package:gotrack_flutter/globals.dart' as globals;
import 'package:gotrack_flutter/theme/style.dart';
import 'package:gotrack_flutter/screens/homeScreen.dart';
import 'package:gotrack_flutter/screens/addItemScreen.dart';
import 'package:gotrack_flutter/screens/trackingResultScreen.dart';

import 'components/mainBottomNavBar.dart';
import 'providers/mainBottomNavBarProvider.dart';
import 'providers/trackingHistoryProvider.dart';

final sentry = SentryClient(
    dsn:
        "https://702fa73f9e5b498491b66722d6aa2a6e@o458281.ingest.sentry.io/5455562");

Future initOneSignal() async {
  //Remove this method to stop OneSignal Debugging
  await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  print('onesignal start');
  await OneSignal.shared.init(
    "8a22d93c-3746-4e93-9943-d82a0a6b7711",
    iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false,
    },
  );
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);

  if (globals.deviceId != null) {
    OneSignal.shared.setExternalUserId(globals.deviceId);
    print('device id: ' + globals.deviceId);
  }
  print('onesignal end');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await globals.getDevideId();
    initOneSignal();
    await globals.getPackageInfo();
    await globals.preload();
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<MainBottomNavBarProvider>(
            create: (_) => MainBottomNavBarProvider()),
        ChangeNotifierProvider<ActiveTrackingListProvider>(
            create: (_) => ActiveTrackingListProvider()),
        ChangeNotifierProvider<TrackingHistoryProvider>(
            create: (_) => TrackingHistoryProvider()),
        ChangeNotifierProvider<TrackingNumberInputProvider>(
            create: (_) => TrackingNumberInputProvider()),
      ],
      child: MyApp(),
    ));
  } catch (error, stackTrace) {
    await sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  const MyApp({Key key}) : super(key: key);

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(title: 'Gotrack.my'),
    AddItemScreen(),
    SettingScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainBtmNavBarProv = Provider.of<MainBottomNavBarProvider>(context);
    return MaterialApp(
      title: 'Gotrack.my',
      theme: appTheme(),
      home: Scaffold(
        body: _widgetOptions.elementAt(
            Provider.of<MainBottomNavBarProvider>(context).currentIndex),
        bottomNavigationBar: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity > 0) {
              if (mainBtmNavBarProv.currentIndex - 1 >= 0)
                mainBtmNavBarProv
                    .setCurrentIndex(mainBtmNavBarProv.currentIndex - 1);
            } else if (details.primaryVelocity < 0) {
              if (mainBtmNavBarProv.currentIndex + 1 < _widgetOptions.length)
                mainBtmNavBarProv
                    .setCurrentIndex(mainBtmNavBarProv.currentIndex + 1);
            }
          },
          child: MainBottomNavBar(),
        ),
      ),
    );
  }

  Widget mainScreen() {
    return MaterialApp(
      title: 'Gotrack.my',
      theme: appTheme(),
      // home: HomeScreen(title: 'Flutter Demo Home Page'),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(title: 'Gotrack.my'),
        '/AddItem': (context) => AddItemScreen(),
        '/TrackingResult': (context) => TrackingResultScreen(),
      },
    );
  }
}
