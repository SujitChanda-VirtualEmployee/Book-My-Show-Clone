import 'dart:async';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart' as mapLauncher;
import '../../../models/hall_details_model.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/custom_styles.dart';
import '../../../utils/size_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TileInfoSheetContent extends StatefulWidget {
  final CinemaHallClass hallData;
  const TileInfoSheetContent({Key? key, required this.hallData})
      : super(key: key);

  @override
  State<TileInfoSheetContent> createState() => _TileInfoSheetContentState();
}

class _TileInfoSheetContentState extends State<TileInfoSheetContent>
    with SingleTickerProviderStateMixin {
  LatLng currentLocation = const LatLng(25.69893, 32.6421);
  GoogleMapController? mapController;
  final Completer<GoogleMapController> _controller = Completer();

  void launchMap(
      {required double lat, required double lng, required String title}) async {
    final availableMap = await mapLauncher.MapLauncher.installedMaps;

    await availableMap.first.showDirections(
        destination: mapLauncher.Coords(lat, lng), destinationTitle: title);
    // .showMarker(coords: mapLauncher.Coords(lat, lng), title: title);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      currentLocation = LatLng(widget.hallData.lat, widget.hallData.lng);
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

      setState(() {
        mapController = controller;
      });
      _goToTheLake();
    }

    return Container(
      height: widget.hallData.covidSecure
          ? SizeConfig.fullHeight / 1.25
          : SizeConfig.fullHeight / 1.6,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: ColorPalette.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [
        SizedBox(
          height: SizeConfig.heightMultiplier * 10,
        ),
        Container(
          height: 2,
          width: SizeConfig.fullWidth / 3.5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorPalette.secondary),
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.hallData.hallName,
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: SizeConfig.textMultiplier * 2,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.all(10),
          clipBehavior: Clip.antiAlias,
          elevation: 1,
          child: AspectRatio(
            aspectRatio: 1 / 0.5,
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
                  mapType: MapType.normal,
                  mapToolbarEnabled: false,
                  onMapCreated: onCreated,
                ),
                Positioned.fill(
                    child: Container(
                  color: ColorPalette.white.withOpacity(0.2),
                )),
                mapController != null
                    ? Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 50),
                          child: Image.asset(
                            "assets/200w.webp",
                            height: 60,
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12, bottom: 12, left: 8, right: 5),
          width: SizeConfig.fullWidth,
          child: Row(children: [
            const Icon(
              EvaIcons.pinOutline,
              color: ColorPalette.secondary,
            ),
            SizedBox(
              width: SizeConfig.widthMultiplier * 30,
            ),
            Expanded(
              child: Text(widget.hallData.address,
                  maxLines: 2,
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                    color: ColorPalette.secondary,
                    fontSize: SizeConfig.textMultiplier * 1.4,
                  )),
            ),
            SizedBox(
              width: SizeConfig.widthMultiplier * 5,
            ),
            IconButton(
                onPressed: () {
                  launchMap(
                      lat: widget.hallData.lat,
                      lng: widget.hallData.lng,
                      title: widget.hallData.hallName);
                },
                icon: const Icon(
                  EvaIcons.navigation2Outline,
                  color: ColorPalette.primary,
                ))
          ]),
        ),
        const Divider(
          height: 0,
          thickness: 1,
        ),
        Visibility(
          visible: widget.hallData.covidSecure,
          child: Container(
            padding: const EdgeInsets.only(top: 5),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            width: SizeConfig.fullWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.checkmark_shield_fill,
                      color: Colors.green,
                      size: 20,
                    ),
                    Text(" My Safety First",
                        style:
                            CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: ColorPalette.secondary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          fontSize: SizeConfig.textMultiplier * 1.8,
                        )),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 30,
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 90,
                  width: SizeConfig.fullWidth,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      direction: Axis.vertical,
                      runAlignment: WrapAlignment.start,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: ColorPalette.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(3)),
                            child: Text("Thermal Scanning",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                  color: ColorPalette.secondary,
                                  letterSpacing: 0.5,
                                  fontSize: SizeConfig.textMultiplier * 1.5,
                                ))),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: ColorPalette.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(3)),
                            child: Text("Sanitization Before Every Show",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                  color: ColorPalette.secondary,
                                  letterSpacing: 0.5,
                                  fontSize: SizeConfig.textMultiplier * 1.5,
                                ))),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: ColorPalette.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(3)),
                            child: Text("Packaged Food and Beverage",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                  color: ColorPalette.secondary,
                                  letterSpacing: 0.5,
                                  fontSize: SizeConfig.textMultiplier * 1.5,
                                ))),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: ColorPalette.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(3)),
                            child: Text("Limited Ocupency in Restrooms",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                  color: ColorPalette.secondary,
                                  letterSpacing: 0.5,
                                  fontSize: SizeConfig.textMultiplier * 1.5,
                                ))),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: ColorPalette.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(3)),
                            child: Text("Contactless Security Checks",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                  color: ColorPalette.secondary,
                                  letterSpacing: 0.5,
                                  fontSize: SizeConfig.textMultiplier * 1.5,
                                ))),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: ColorPalette.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(3)),
                            child: Text("In-Cinema Social Distancing",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                  color: ColorPalette.secondary,
                                  letterSpacing: 0.5,
                                  fontSize: SizeConfig.textMultiplier * 1.5,
                                ))),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: ColorPalette.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(3)),
                            child: Text("Daily Temperature Checks for Staff",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                  color: ColorPalette.secondary,
                                  letterSpacing: 0.5,
                                  fontSize: SizeConfig.textMultiplier * 1.5,
                                ))),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: ColorPalette.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(3)),
                            child: Text("Disposable 3D Glasses",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                  color: ColorPalette.secondary,
                                  letterSpacing: 0.5,
                                  fontSize: SizeConfig.textMultiplier * 1.5,
                                ))),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: ColorPalette.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(3)),
                            child: Text("Hand Sanitizers Available",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                  color: ColorPalette.secondary,
                                  letterSpacing: 0.5,
                                  fontSize: SizeConfig.textMultiplier * 1.5,
                                ))),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: ColorPalette.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(3)),
                            child: Text("Contactless Food Service",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                  color: ColorPalette.secondary,
                                  letterSpacing: 0.5,
                                  fontSize: SizeConfig.textMultiplier * 1.5,
                                ))),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: ColorPalette.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(3)),
                            child: Text("Deep Cleaning of Restrooms",
                                style: CustomStyleClass.onboardingBodyTextStyle
                                    .copyWith(
                                  color: ColorPalette.secondary,
                                  letterSpacing: 0.5,
                                  fontSize: SizeConfig.textMultiplier * 1.5,
                                ))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 5),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          width: SizeConfig.fullWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Available Facilities",
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                    color: ColorPalette.secondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    fontSize: SizeConfig.textMultiplier * 1.8,
                  )),
              SizedBox(
                height: SizeConfig.heightMultiplier * 30,
              ),
              Container(
                width: SizeConfig.fullWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: ColorPalette.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.install_mobile_sharp,
                            color: ColorPalette.secondary,
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 5,
                          ),
                          SizedBox(
                            height: 30,
                            width: 60,
                            child: Center(
                              child: Text("MTicket",
                                  textAlign: TextAlign.center,
                                  style: CustomStyleClass
                                      .onboardingBodyTextStyle
                                      .copyWith(
                                    color: ColorPalette.secondary,
                                    fontSize: SizeConfig.textMultiplier * 1.4,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 50,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: ColorPalette.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_parking_outlined,
                            color: ColorPalette.secondary,
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 5,
                          ),
                          SizedBox(
                            height: 30,
                            width: 60,
                            child: Center(
                              child: Text("Parking\nFacility",
                                  textAlign: TextAlign.center,
                                  style: CustomStyleClass
                                      .onboardingBodyTextStyle
                                      .copyWith(
                                    color: ColorPalette.secondary,
                                    fontSize: SizeConfig.textMultiplier * 1.4,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 50,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: ColorPalette.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.lunch_dining_outlined,
                            color: ColorPalette.secondary,
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 5,
                          ),
                          SizedBox(
                            height: 30,
                            width: 60,
                            child: Center(
                              child: Text("Food Court",
                                  textAlign: TextAlign.center,
                                  style: CustomStyleClass
                                      .onboardingBodyTextStyle
                                      .copyWith(
                                    color: ColorPalette.secondary,
                                    fontSize: SizeConfig.textMultiplier * 1.4,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 50,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: ColorPalette.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.gamepad_outlined,
                            color: ColorPalette.secondary,
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 5,
                          ),
                          SizedBox(
                            height: 30,
                            width: 60,
                            child: Center(
                              child: Text("Gaming Zone",
                                  textAlign: TextAlign.center,
                                  style: CustomStyleClass
                                      .onboardingBodyTextStyle
                                      .copyWith(
                                    color: ColorPalette.secondary,
                                    fontSize: SizeConfig.textMultiplier * 1.4,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 50,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: ColorPalette.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.wheelchair_pickup,
                            color: ColorPalette.secondary,
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 5,
                          ),
                          SizedBox(
                            height: 30,
                            width: 60,
                            child: Center(
                              child: Text("Wheel Chair Facility",
                                  textAlign: TextAlign.center,
                                  style: CustomStyleClass
                                      .onboardingBodyTextStyle
                                      .copyWith(
                                    color: ColorPalette.secondary,
                                    fontSize: SizeConfig.textMultiplier * 1.4,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 50,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: ColorPalette.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.fastfood_outlined,
                            color: ColorPalette.secondary,
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 5,
                          ),
                          SizedBox(
                            height: 30,
                            width: 60,
                            child: Center(
                              child: Text("F & B",
                                  textAlign: TextAlign.center,
                                  style: CustomStyleClass
                                      .onboardingBodyTextStyle
                                      .copyWith(
                                    color: ColorPalette.secondary,
                                    fontSize: SizeConfig.textMultiplier * 1.4,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.widthMultiplier * 50,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: ColorPalette.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.chair_outlined,
                            color: ColorPalette.secondary,
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 5,
                          ),
                          SizedBox(
                            height: 30,
                            width: 60,
                            child: Center(
                              child: Text("Recliner Seats",
                                  textAlign: TextAlign.center,
                                  style: CustomStyleClass
                                      .onboardingBodyTextStyle
                                      .copyWith(
                                    color: ColorPalette.secondary,
                                    fontSize: SizeConfig.textMultiplier * 1.4,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
