import 'dart:async';
import 'package:book_my_show_clone/utils/color_palette.dart';
import 'package:book_my_show_clone/utils/custom_styles.dart';
import 'package:book_my_show_clone/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../services/providerService/auth_provider.dart';
import '../../services/providerService/location_provider.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';

  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng currentLocation = const LatLng(37.421632, 122.084664);
  GoogleMapController? _mapController;
  Completer<GoogleMapController> _controller = Completer();

  // List<Prediction>? searchResults = [];
  bool isValid2 = false;
  bool isValid = false;
  bool numberSubmit = false;
  bool bottomBarVisibility = true;
  bool showAddresshints = false;
  // final placesService = PlacesService();
  String? validateMobile(String value) {
    if (value.length == 0) {
      return "*Mobile Number is Required";
    } else if (value.length < 10 || value.length > 10) {
      return "*Enter valid Number";
    } else {
      return null;
    }
  }

  bool _locating = false;
  bool _loggedIn = false;
  User? user;

  @override
  void initState() {
    //check user logged in or not , while opening map screen
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
    if (user != null) {
      setState(() {
        _loggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);

    setState(() {
      currentLocation = LatLng(Provider.of<LocationProvider>(context).latitude,
          Provider.of<LocationProvider>(context).longitude);
    });

    Future<void> _goToTheLake() async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: currentLocation,
        zoom: 18,
      )));
    }

    void onCreated(GoogleMapController controller) {
      _controller.complete(controller);
      _mapController = controller;
      _goToTheLake();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: const Icon(Icons.my_location_rounded,
              color: ColorPalette.primary),
          onPressed: () {
            locationData.getCurrentPosition().then((value) {
              _mapController!
                  .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(value.latitude, value.longitude),
                zoom: 18,
              )));
              setState(() {});
            });
          }),
      bottomNavigationBar: Visibility(
        visible: bottomBarVisibility,
        child: Container(
          decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black38,
                    offset: Offset(0.7, 0.7),
                    spreadRadius: 1,
                    blurRadius: 2)
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(width: 80, height: 2, color: Colors.grey),
                ),
              ),
              _locating
                  ? const LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(ColorPalette.primary),
                    )
                  : Container(),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_history,
                        color: ColorPalette.primary,
                      ),
                      Expanded(
                        child: Text(
                            _locating
                                ? ' Locating....'
                                : locationData.pickUpLocation.city == null
                                    ? ' Locating...'
                                    : " ${locationData.pickUpLocation.street!}, ${locationData.pickUpLocation.locality!}, ${locationData.pickUpLocation.city!} ",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: CustomStyleClass.onboardingBodyTextStyle
                                .copyWith(
                                    color: ColorPalette.secondary,
                                    fontSize: SizeConfig.textMultiplier * 2,
                                    fontWeight: FontWeight.bold)),
                      )
                    ],
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    _locating
                        ? ''
                        : locationData.pickUpLocation.city == null
                            ? ''
                            : locationData
                                .pickUpLocation.placeFormattedAddress!,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width -
                      40, //40 is padding from bothe side . thats 20 each side
                  child: AbsorbPointer(
                    absorbing: _locating ? true : false,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: _locating ? Colors.grey : ColorPalette.primary,
                      ),
                      onPressed: () {
                        locationData.savePrefs();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'CONFIRM LOCATION',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              key: widget.key,
              initialCameraPosition: CameraPosition(
                target: currentLocation,
                zoom: 18,
              ),
              zoomControlsEnabled: false,
              minMaxZoomPreference: const MinMaxZoomPreference(1.5, 20.8),
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              // padding: EdgeInsets.only(
              //   bottom: MediaQuery.of(context).size.height * 0.25,
              //   top: MediaQuery.of(context).size.height * 0.6,
              // ),
              mapType: MapType.normal,
              mapToolbarEnabled: true,
              onCameraMove: (CameraPosition position) {
                setState(() {
                  _locating = true;
                });
                locationData.onCameraMove(position);
              },
              onMapCreated: onCreated,
              onCameraIdle: () {
                setState(() {
                  _locating = false;
                });
                locationData.getMoveCamera();
              },
            ),
            Center(
              child: SpinKitPulse(
                color: ColorPalette.primary.withOpacity(0.5),
                size: 100.0,
              ),
            ),
            Center(
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 40),
                child: Image.asset(
                  'assets/200w.webp',
                ),
              ),
            ),

            // Positioned(
            //   bottom: 0.0,
            //   child:
            // ),
          ],
        ),
      ),
    );
  }
}

// now will go back to Admin Web
