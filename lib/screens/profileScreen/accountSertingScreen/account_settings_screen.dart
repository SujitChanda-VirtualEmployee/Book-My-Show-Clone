import 'package:book_my_show_clone/screens/mapScreen/map_screen.dart';
import 'package:book_my_show_clone/screens/welcomScreen/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../services/providerService/location_provider.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/custom_styles.dart';
import '../../../utils/size_config.dart';

class AccountSettingScreen extends StatefulWidget {
  static const String id = "account_setting_screen";
  const AccountSettingScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  String onlineStatus = "You won't get notifications from Book My Show";

  @override
  void initState() {
    if (preferences!.getBool('_userNotificationStatus')!) {
      onlineStatus = "You will get notifications from Book My Show";
    } else {
      onlineStatus = "You won't get notifications from Book My Show";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorPalette.secondary,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ColorPalette.white,
            )),
        centerTitle: true,
        title: Text(
          "Account & Settings",
          style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
              color: ColorPalette.white,
              fontSize: SizeConfig.textMultiplier * 2),
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.heightMultiplier * 18,
        ),
        ListTile(
          leading: Icon(
            Icons.my_location_rounded,
            color: Colors.black,
            size: SizeConfig.heightMultiplier * 35,
          ),
          tileColor: ColorPalette.white,
          dense: true,
          onTap: () {
            Navigator.pushNamed(context, MapScreen.id);
          },
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black,
            size: SizeConfig.heightMultiplier * 25,
          ),
          title: Text('My Location',
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 2)),
          subtitle: Consumer<LocationProvider>(
              builder: (context, locProvider, child) {
            return Text(
                "${locProvider.pickUpLocation.locality}, ${locProvider.pickUpLocation.city} ",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                    color: ColorPalette.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.textMultiplier * 1.5));
          }),
        ),
        const Divider(
          thickness: 1,
          height: 0,
        ),
        ListTile(
          leading: Icon(
            Icons.notifications_none_rounded,
            color: Colors.black,
            size: SizeConfig.heightMultiplier * 35,
          ),
          tileColor: ColorPalette.white,
          dense: true,
          onTap: () {
            preferences!.setBool('_userNotificationStatus',
                !preferences!.getBool('_userNotificationStatus')!);
            if (preferences!.getBool('_userNotificationStatus')!) {
              onlineStatus = "You will get notifications from Book My Show";
            } else {
              onlineStatus = "You won't get notifications from Book My Show";
            }
            setState(() {});
          },
          contentPadding:
              const EdgeInsets.only(right: 5.0, left: 15, top: 8, bottom: 8),
          trailing: CupertinoSwitch(
            activeColor: ColorPalette.primary,
            trackColor: ColorPalette.dark,
            value: preferences!.getBool('_userNotificationStatus')!,
            onChanged: (newValue) => setState(() {
              preferences!.setBool('_userNotificationStatus', newValue);
              if (preferences!.getBool('_userNotificationStatus')!) {
                onlineStatus = "You will get notifications from Book My Show";
              } else {
                onlineStatus = "You won't get notifications from Book My Show";
              }
            }),
          ),
          title: Text('Notification',
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 2)),
          subtitle: Text(onlineStatus,
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 1.4)),
        ),
        const Divider(
          thickness: 1,
          height: 0,
        ),
        ListTile(
          leading: Icon(
            Icons.delete_outline_rounded,
            color: Colors.black,
            size: SizeConfig.heightMultiplier * 35,
          ),
          tileColor: ColorPalette.white,
          dense: true,
          onTap: () {
            Navigator.pushNamed(context, MapScreen.id);
          },
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black,
            size: SizeConfig.heightMultiplier * 25,
          ),
          title: Text('Delete My Account',
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 2)),
          subtitle: Text("Your Account will be deleted Permanently",
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 1.5)),
        ),
        const Divider(
          thickness: 1,
          height: 0,
        ),
        ListTile(
          leading: Icon(
            Icons.power_settings_new_rounded,
            color: Colors.black,
            size: SizeConfig.heightMultiplier * 35,
          ),
          tileColor: ColorPalette.white,
          dense: true,
          onTap: () {
            showDialog();
          },
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black,
            size: SizeConfig.heightMultiplier * 25,
          ),
          title: Text('Sign Out',
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 2)),
          subtitle: Text("Sign out from Current Account",
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 1.5)),
        ),
      ],
    );
  }

  showDialog() {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Confirm Logout?',
                style: TextStyle(
                    color: ColorPalette.primary,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.bold)),
            content: const Text('\nAre you sure you want to Logout?\n',
                style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 0.6,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
            actions: [
              CupertinoDialogAction(
                  child: Text(
                    "NO",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(false);
                  }),
              CupertinoDialogAction(
                  child: Text(
                    "YES",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(true);
                  })
            ],
          );
        }).then((value) {
      if (value != null && value == true) {
        FirebaseAuth.instance.signOut();
        preferences!.clear();
        Navigator.pushNamedAndRemoveUntil(
            context, WelcomeScreen.id, (route) => false);
      }
    });
  }
}
