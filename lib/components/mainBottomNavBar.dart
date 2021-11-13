import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:gotrack_flutter/providers/mainBottomNavBarProvider.dart';
import 'package:provider/provider.dart';

class MainBottomNavBar extends StatelessWidget {
  @override
  const MainBottomNavBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return PlatformNavBar(
    //   currentIndex: Provider.of<MainBottomNavBarProvider>(context).currentIndex,
    //   itemChanged: (index) {
    //     Provider.of<MainBottomNavBarProvider>(context, listen: false)
    //         .setCurrentIndex(index);
    //   },
    //   items: [
    //     BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Home'),
    //     BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Track New'),
    //     BottomNavigationBarItem(
    //         icon: Icon(Icons.settings_outlined), label: 'Settings')
    //   ],
    // );

    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.red,
      // showUnselectedLabels: false,
      currentIndex: Provider.of<MainBottomNavBarProvider>(context).currentIndex,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(PlatformIcons(context).search), label: 'Track'),
        BottomNavigationBarItem(
            icon: Icon(PlatformIcons(context).settings), label: 'Settings')
      ],
      onTap: (int index) {
        Provider.of<MainBottomNavBarProvider>(context, listen: false)
            .setCurrentIndex(index);
      },
    );
  }
}
