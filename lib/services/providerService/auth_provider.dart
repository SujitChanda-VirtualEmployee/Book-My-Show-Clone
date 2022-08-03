import 'package:book_my_show_clone/main.dart';
import 'package:book_my_show_clone/utils/color_palette.dart';
import 'package:book_my_show_clone/utils/custom_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';

import '../../screens/init_screen.dart';
import '../../screens/registration_screen.dart';
import '../../utils/size_config.dart';
import '../../widgets/customSheets/OTPVerificationSheet/components/otp_verify_sheet_content.dart';
import '../../widgets/customSheets/OTPVerificationSheet/otp_verification_sheet.dart';
import '../firebaseServices/firebase_services.dart';
import '../sharedService/shared_preference_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String smsOtp = "";
  String? verificationId;
  String error = '';
  bool otpSubmit = false;
  //bool loading = false;
  bool paymentSuccess = false;
  String? screen;
  double? latitude;
  double? longitude;
  String? address;
  String? location;
  String? username;
  String? phoneNumber;
  String? email;
  String? uid;

  final pinputFocusNode = FocusNode();
  final defaultPinTheme = PinTheme(
    width: 60,
    height: 60,
    margin: const EdgeInsets.only(left: 5, right: 5),
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: ColorPalette.secondary),
      borderRadius: BorderRadius.circular(50),
    ),
  );

  Future<void> verifyPhone(
      {required BuildContext context, required String number}) async {
    // ignore: prefer_function_declarations_over_variables
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) {};

    // ignore: prefer_function_declarations_over_variables
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      if (kDebugMode) {
        print(e.code);
      }
      EasyLoading.showError("Phone Number\nverification Failed");
      error = e.toString();
      notifyListeners();
    };

    // ignore: prefer_function_declarations_over_variables
    final PhoneCodeSent smsOtpSend = (String verId, int? resendToken) async {
      verificationId = verId;
      if (kDebugMode) {
        print(number);
      }
      EasyLoading.showSuccess("Sending OTP Successfully");
      notifyListeners();
      OTPVerificationSheet.smsOtpDialog(
          context: context, number: number, verificationId: verificationId);
    };

    try {
      _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsOtpSend,
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
      );
    } catch (e) {
      error = e.toString();

      notifyListeners();
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
