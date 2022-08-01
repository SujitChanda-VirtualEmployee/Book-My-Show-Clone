import 'package:book_my_show_clone/main.dart';
import 'package:flutter/foundation.dart';

class SharedServices {
  static addUserDataToSF({
    required String userName,
    required String userPhone,
    required String userEmail,
    required String userPhoto,
    String? userDob,
    bool? userIdentity,
    bool? userMarriageStatus,
  }) {
    preferences!.setString('_userName', userName);
    preferences!.setString('_userPhoto', userPhoto);
    preferences!.setString('_userEmail', userEmail);
    preferences!.setString('_userPhone', userPhone);
    if (userDob != null) {
      preferences!.setString('_userDOB', userDob);
    }
    if (userIdentity != null) {
      preferences!.setBool('_userIdentity', userIdentity);
    }
    if (userMarriageStatus != null) {
      preferences!.setBool('_userMarriageStatus', userMarriageStatus);
    }

    if (kDebugMode) {
      print("User Data Added to SharedPreferences");
    }
  }
}
