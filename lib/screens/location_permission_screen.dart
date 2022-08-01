import 'dart:developer';
import 'dart:io';

import 'package:book_my_show_clone/screens/landingScreen/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import '../services/providerService/location_provider.dart';
import '../utils/asset_images_strings.dart';
import '../utils/color_palette.dart';
import '../utils/custom_styles.dart';
import '../utils/size_config.dart';

class LocationPermissionScreen extends StatefulWidget {
  static const String id = 'locationPermission-screen';
  final String title;
  final String body;
  const LocationPermissionScreen(
      {Key? key, required this.title, required this.body})
      : super(key: key);

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  String? currentLocation;
  late LocationProvider locationData;
  void locatePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        locatePosition();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await permission_handler.openAppSettings();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setAddressLine(position);
  }

  setAddressLine(Position position) async {
    try {
      await locationData.getCurrentPosition();
      if (locationData.permissionAllowed == true) {
        Future.delayed(const Duration(milliseconds: 100), () {
          Navigator.pushNamedAndRemoveUntil(
              context, LandingScreen.id, (route) => false);
        });
        if (mounted) {
          setState(() {
            locationData.loading = false;
          });
        }
      } else {
        //  print('permission not allowed');
        if (mounted) {
          setState(() {
            locationData.loading = false;
          });
        }
      }
    } catch (e) {
      log("Location Error : $e");
      if (mounted) {
        setState(() {
          currentLocation =
              'Please tap on location icon to get current location!';
        });
      }
    }
  }

  displaySnackNat(String title, String body) {
    Fluttertoast.showToast(
        msg: body,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: ColorPalette.secondary,
        textColor: Colors.white,
        fontSize: SizeConfig.textMultiplier * 1.7);
  }

  @override
  void initState() {
    locationData = Provider.of<LocationProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => displaySnackNat(widget.title, widget.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 1),
              Text(
                "Need Location Permission!",
                style: CustomStyleClass.onboardingHeadingStyle,
              ),
              brandLogo(),
              Platform.isAndroid
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("This app needs location data to enable \n",
                            style: CustomStyleClass.onboardingBodyTextStyle
                                .copyWith(
                                    color: ColorPalette.secondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.textMultiplier * 2)),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(AssetImageClass.checkOnIcon,
                                  width: 20, height: 20),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                    "Display Nearest Movie Theatres in your area",
                                    style: CustomStyleClass
                                        .onboardingBodyTextStyle
                                        .copyWith(
                                            color: ColorPalette.secondary,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                SizeConfig.textMultiplier * 2)),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: Row(
                            children: [
                              Image.asset(AssetImageClass.checkOnIcon,
                                  width: 20, height: 20),
                              const SizedBox(width: 5),
                              Text("Exact location and",
                                  style: CustomStyleClass
                                      .onboardingBodyTextStyle
                                      .copyWith(
                                          color: ColorPalette.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              SizeConfig.textMultiplier * 2))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: Row(
                            children: [
                              Image.asset(AssetImageClass.checkOnIcon,
                                  width: 20, height: 20),
                              const SizedBox(width: 5),
                              Text("Routes to reach there",
                                  style: CustomStyleClass
                                      .onboardingBodyTextStyle
                                      .copyWith(
                                          color: ColorPalette.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              SizeConfig.textMultiplier * 2))
                            ],
                          ),
                        ),
                        Text(
                            "\nThis app dose not collect your location when not in use.\n\n"
                            "Please Select 'Allow only while using the app' or 'Ask every time' option From Location Permission Section.",
                            style: CustomStyleClass.onboardingBodyTextStyle
                                .copyWith(
                                    color: ColorPalette.secondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.textMultiplier * 2))
                      ],
                    )
                  : Text(
                      "For a reliable ride, Safe Ride SF collects location data from the time you open the app untill a trip ends, This improves pickup, support, and more. Need Location Permission to get your Current Location to set Pickup location.",
                      textAlign: TextAlign.center,
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: ColorPalette.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.textMultiplier * 2)),
              _signUpButton(),
              const SizedBox(height: 1),
            ]),
      ),
    );
  }

  Widget brandLogo() {
    return Center(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: Colors.transparent,
        child: SizedBox(
            width: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                AssetImageClass.splashAppLogo,
                fit: BoxFit.cover,
              ),
            )),
      ),
    );
  }

  Widget _signUpButton() {
    return Center(
      child: SizedBox(
        height: SizeConfig.heightMultiplier * 65,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                // side: BorderSide(color: bgColor, width: 0.0),
                borderRadius: BorderRadius.circular(50)),
            elevation: 3,
            primary: ColorPalette.primary,
          ),
          child: Text("ACCEPT",
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 20, color: Colors.white, letterSpacing: 1.5)),
          onPressed: () {
            locatePosition();
          },
        ),
      ),
    );
  }
}
