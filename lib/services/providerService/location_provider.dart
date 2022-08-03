import 'package:book_my_show_clone/models/address.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../main.dart';

class LocationProvider with ChangeNotifier {
  double latitude = 37.421632;
  double longitude = 12.084664;
  bool permissionAllowed = false;

  Address pickUpLocation = Address();
  bool loading = false;

  Future<Position> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude = position.latitude;
    longitude = position.longitude;
    List<Placemark> placemark =
        await placemarkFromCoordinates(latitude, longitude);

    final addresses =
        ' ${placemark[0].street}, ${placemark[0].subLocality}, ${placemark[0].locality}, ${placemark[0].country}, ${placemark[0].postalCode}';
    pickUpLocation.placeFormattedAddress = addresses;
    pickUpLocation.street = "${placemark[0].street}";
    pickUpLocation.locality = "${placemark[0].subLocality}";
    pickUpLocation.country = "${placemark[0].country}";
    pickUpLocation.stateOrProvince = "${placemark[0].administrativeArea}";
    pickUpLocation.city = "${placemark[0].locality}";
    pickUpLocation.postalCode = '${placemark[0].postalCode}';

    permissionAllowed = true;

    notifyListeners();

    return position;
  }

  void onCameraMove(CameraPosition cameraPosition) async {
    latitude = cameraPosition.target.latitude;
    longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  void getLatLng(double latitude, double longitude) {
    this.latitude = latitude;
    this.longitude = longitude;
    notifyListeners();
  }

  Future<void> getMoveCamera() async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(latitude, longitude);
    final addresses =
        ' ${placemark[0].street}, ${placemark[0].subLocality}, ${placemark[0].locality}, ${placemark[0].country}, ${placemark[0].postalCode}';
    pickUpLocation.placeFormattedAddress = addresses;
    pickUpLocation.street = "${placemark[0].street}";
    pickUpLocation.locality = "${placemark[0].subLocality}";
    pickUpLocation.country = "${placemark[0].country}";
    pickUpLocation.stateOrProvince = "${placemark[0].administrativeArea}";
    pickUpLocation.city = "${placemark[0].locality}";
    pickUpLocation.postalCode = '${placemark[0].postalCode}';

    notifyListeners();
  }

  Future<void> savePrefs() async {
    preferences!.setDouble('latitude', latitude);
    preferences!.setDouble('longitude', longitude);
    preferences!.setString('address', pickUpLocation.placeFormattedAddress!);
  }
}
