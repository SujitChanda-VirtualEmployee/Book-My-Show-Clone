import 'package:book_my_show_clone/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../screens/init_screen.dart';
import '../../../screens/registration_screen.dart';
import '../../../services/firebaseServices/firebase_services.dart';
import '../../../services/sharedService/shared_preference_service.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/size_config.dart';
import 'components/otp_verify_sheet_content.dart';

class OTPVerificationSheet {
  static smsOtpDialog(
      {required BuildContext context,
      required String number,
      required String? verificationId}) {
    return showModalBottomSheet(
            isDismissible: false,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0)),
            ),
            backgroundColor: Colors.white,
            isScrollControlled: false,
            enableDrag: false,
            context: context,
            builder: (context) => OTPVerifySheetContent(number: number))
        .then((smsOtp) async {
      if (smsOtp != null) {
        EasyLoading.show(status: "Verifing ...");
        try {
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: verificationId!, smsCode: smsOtp);
          final User? user = (await FirebaseAuth.instance
                  .signInWithCredential(phoneAuthCredential))
              .user;
          if (user != null) {
            EasyLoading.showSuccess("Phone Number verified");
            if (kDebugMode) {
              print("Login Successful");
            }
            FirebaseServices.getUserById(user.uid).then((snapShot) {
              if (snapShot.exists) {
                SharedServices.addUserDataToSF(
                  userEmail: '${snapShot['email']}',
                  userName: '${snapShot['name']}',
                  userPhone: '${snapShot['number']}',
                  userPhoto: '${snapShot['profile_Pic_URL']}',
                );
                preferences!.setBool('_userNotificationStatus', true);
                Navigator.pushReplacementNamed(context, InitScreen.id);
              } else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationScreen(
                              phoneNumber: user.phoneNumber!,
                              uid: user.uid,
                            )));
              }
            });
          } else {
            if (kDebugMode) {
              print('Login failed');
              EasyLoading.showError("Phone Number\nverification Failed");
            }
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == "invalid-verification-code") {
            showToast(
                "You have entered Invalid Verification Code. Please try again");
            EasyLoading.dismiss();
          } else {
            showToast(e.message.toString());
            EasyLoading.dismiss();
          }
        }
      } else {
        showToast("  Please Enter the PIN Correctly!  ");
        EasyLoading.dismiss();
      }
    });
  }

  static showToast(String message) {
    Fluttertoast.cancel();
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: ColorPalette.secondary,
        textColor: Colors.white,
        fontSize: SizeConfig.textMultiplier * 2);
  }
}
