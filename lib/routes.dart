import 'package:flutter/widgets.dart';
import 'package:gotrack_flutter/screens/homeScreen.dart';
import 'package:gotrack_flutter/screens/addItemScreen.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => HomeScreen(title: 'Gotrack.my'),
  "/AddItem": (BuildContext context) => AddItemScreen(),
};
