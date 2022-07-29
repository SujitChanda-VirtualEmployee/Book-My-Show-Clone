import 'package:book_my_show_clone/utils/asset_images_strings.dart';
import 'package:book_my_show_clone/utils/color_palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../services/firebaseServices/push_notification_service.dart';
import '../buzzScreen/buzz_screen.dart';
import '../homeScreen/home_screen.dart';
import '../profileScreen/profile_screen.dart';

class LandingScreen extends StatefulWidget {
  static const String id = "landing-screen";
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late PersistentTabController controller;
  late bool hideNavBar;
  late FirebaseNotifcation firebase;

  List<Widget> _buildScreen() {
    return const [
      HomeScreen(),
      BuzzScreen(),
      ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const ImageIcon(
          AssetImage(
            AssetImageClass.appLogo,
          ),
          size: 30,
        ),
        title: "Home",
        activeColorPrimary: ColorPalette.primary,
        inactiveColorPrimary: ColorPalette.secondary,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.dot_radiowaves_right),
        title: "Buzz",
        activeColorPrimary: ColorPalette.primary,
        inactiveColorPrimary: ColorPalette.secondary,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person_sharp),
        title: "Add",
        activeColorPrimary: ColorPalette.primary,
        inactiveColorPrimary: ColorPalette.secondary,
      ),
    ];
  }

  handleAsync() async {
    await firebase.initialize(context);
    await firebase.subscribeToTopic('user');
    await firebase.getToken();
  }

  @override
  void initState() {
    super.initState();
    controller = PersistentTabController(initialIndex: 0);
    hideNavBar = false;
    firebase = FirebaseNotifcation(context: context);
    handleAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PersistentTabView(
      context,
      navBarHeight: 60,
      controller: controller,
      screens: _buildScreen(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      stateManagement: true,
      resizeToAvoidBottomInset: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(0),
        colorBehindNavBar: ColorPalette.white,
        border: Border.all(color: Colors.black45),
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(microseconds: 200),
      ),
      navBarStyle: NavBarStyle.style12,
    ));
  }
}
