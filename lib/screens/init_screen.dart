import 'dart:developer';

import 'package:book_my_show_clone/screens/landingScreen/landing_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../services/providerService/location_provider.dart';
import '../utils/asset_images_strings.dart';
import '../utils/color_palette.dart';
import '../utils/size_config.dart';
import 'location_permission_screen.dart';

class InitScreen extends StatefulWidget {
  static const String id = 'init-screen';
  const InitScreen({Key? key}) : super(key: key);

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  String? currentLocation;
  late LocationProvider locationData;
  void locatePosition(BuildContext context) async {
    bool serviceEnabled;

    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacementNamed(
          context,
          LocationPermissionScreen.id,
          arguments: ["Alert!", "Location services are disabled."],
        );
      });
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacementNamed(
          context,
          LocationPermissionScreen.id,
          arguments: ["Alert!", "Location permissions are denied."],
        );
      });
      return Future.error('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacementNamed(
          context,
          LocationPermissionScreen.id,
          arguments: ["Alert!", "Location permissions are permanently denied."],
        );
      });
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition();
    setAddressLine(position);
  }

  setAddressLine(Position position) async {
    try {
      setState(() {
        locationData.loading = true;
      });
      await locationData.getCurrentPosition();
      if (locationData.permissionAllowed == true) {
        Future.delayed(const Duration(milliseconds: 100), () {
          Navigator.pushNamedAndRemoveUntil(
              context, LandingScreen.id, (route) => false);
        });
        setState(() {
          locationData.loading = false;
        });
      } else {
        // print('permission not allowed');
        setState(() {
          locationData.loading = false;
        });
      }
    } catch (e) {
      log("Location Error : $e");
      setState(() {
        currentLocation =
            'Please tap on location icon to get current location!';
      });
    }
  }

  @override
  void initState() {
    locationData = Provider.of<LocationProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => locatePosition(context));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primary,
      body: SizedBox(
        height: SizeConfig.fullHeight,
        width: SizeConfig.fullWidth,
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                AssetImageClass.splashAppLogo,
                width: SizeConfig.fullWidth / 1,
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: SizeConfig.heightMultiplier * 100,
                child: const CupertinoActivityIndicator(
                  animating: true,
                  color: ColorPalette.secondary,
                ))
          ],
        ),
      ),
    );
  }
}
