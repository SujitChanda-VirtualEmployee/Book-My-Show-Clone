
import 'package:book_my_show_clone/utils/color_palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../screens/init_screen.dart';
import '../../screens/registration_screen.dart';
import '../firebaseServices/firebase_services.dart';
import '../sharedService/shared_preference_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseServices _services = FirebaseServices();
  String smsOtp = "";
  String? verificationId;
  String error = '';
  bool otpSubmit = false;
  bool loading = false;
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

  //DocumentSnapshot snapshot;
  final TextEditingController _pinEditingController = TextEditingController();
  final PinDecoration _pinDecoration = const BoxLooseDecoration(
    gapSpace: 8,
    radius: Radius.circular(50.0),
    textStyle: TextStyle(color: Colors.black, fontSize: 20),
    hintText: '******',
    hintTextStyle: TextStyle(color: Colors.grey, fontSize: 20),
    strokeColorBuilder: FixedColorBuilder(ColorPalette.primary),
  );

  Future<void> verifyPhone(
      {required BuildContext context, required String number}) async {
    loading = true;
    notifyListeners();

    // ignore: prefer_function_declarations_over_variables
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      loading = true;
      notifyListeners();
    };

    // ignore: prefer_function_declarations_over_variables
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      loading = true;
      if (kDebugMode) {
        print(e.code);
      }
      error = e.toString();
      notifyListeners();
    };

    // ignore: prefer_function_declarations_over_variables
    final PhoneCodeSent smsOtpSend = (String verId, int? resendToken) async {
      verificationId = verId;
      if (kDebugMode) {
        print(number);
      }
      loading = false;
      notifyListeners();
      smsOtpDialog(context, number);
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
      loading = false;
      notifyListeners();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  smsOtpDialog(BuildContext context, String number) {
    loading = false;
    notifyListeners();
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
            builder: (context) => StatefulBuilder(
                    builder: (BuildContext context, StateSetter state) {
                  return Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                      top: 16,
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 5,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'OTP Sent to $number',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          "Enter 6 digit OTP received as SMS",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.grey[500], fontSize: 10),
                        ),
                        const SizedBox(height: 20.0),
                        SizedBox(
                          height: 50,
                          child: PinFieldAutoFill(
                            codeLength: 6,
                            autoFocus: true,
                            decoration: _pinDecoration,
                            controller: _pinEditingController,
                            //currentCode: _code,
                            onCodeSubmitted: (code) {
                              smsOtp = code;
                              otpSubmit = true;
                              notifyListeners();
                            },
                            onCodeChanged: (code) async {
                              if (code!.length == 6) {
                                smsOtp = code;
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                smsOtp = code;
                                otpSubmit = true;
                                notifyListeners();
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 30.0),
                      ],
                    ),
                  );
                }))

        // showCupertinoDialog(
        //     barrierDismissible: false,
        //     context: context,
        //     builder: (BuildContext context) {
        //       return CupertinoAlertDialog(
        //         title: Column(
        //           children: [
        //             Text('Verification Code'),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             Text(
        //               'Enter 6 digit OTP received as SMS',
        //               style: TextStyle(color: Colors.grey, fontSize: 12),
        //             ),
        //             SizedBox(
        //               height: 10,
        //             ),
        //           ],
        //         ),
        //         content: Container(
        //           height: 50,
        //           child: PinFieldAutoFill(
        //             codeLength: 6,
        //             autoFocus: true,
        //             decoration: _pinDecoration,
        //             controller: _pinEditingController,
        //             //currentCode: _code,
        //             onCodeSubmitted: (code) {
        //               this.smsOtp = code;
        //               otpSubmit = true;
        //               notifyListeners();
        //             },
        //             onCodeChanged: (code) async {
        //               if (code!.length == 6) {
        //                 this.smsOtp = code;
        //                 FocusScope.of(context).requestFocus(FocusNode());
        //                 this.smsOtp = code;
        //                 otpSubmit = true;
        //                 notifyListeners();
        //                 Navigator.of(context, rootNavigator: true).pop();
        //               }
        //             },
        //           ),
        //         ),
        //       );
        //     })

        .whenComplete(() async {
      loading = true;
      notifyListeners();
      if (smsOtp.length == 6 && otpSubmit)
        // ignore: curly_braces_in_flow_control_structures
        try {
          // Navigator.of(context).pop();

          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: verificationId!, smsCode: smsOtp);
          final User? user =
              (await _auth.signInWithCredential(phoneAuthCredential)).user;
          if (user != null) {
            if (kDebugMode) {
              print("Login SuccessFul");
            }
            _services.getUserById(user.uid).then((snapShot) {
              if (snapShot.exists) {
                //user data already exists

                if (screen == 'Login') {
                  username = "${snapShot['name']}";
                  phoneNumber = '${snapShot["number"]}';
                  email = '${snapShot['email']}';
                  notifyListeners();
                  SharedServices.addUserDataToSF(
                    userEmail: '${snapShot['email']}',
                    userName: '${snapShot['name']}',
                    userPhone: '${snapShot['number']}',
                    userPhoto: '${snapShot['profile_Pic_URL']}',
                  );
                  Navigator.pushReplacementNamed(context, InitScreen.id);
                } else {
                  //need to update new selected address
                  //  updateUser(id: user.uid, number: user.phoneNumber);

                }
              } else {
                // user data does not exists
                // will create new data in db
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationScreen(
                              phoneNumber: user.phoneNumber!,
                              uid: user.uid,
                            )));

                // createUser(id: user.uid, number: user.phoneNumber);
                // Navigator.pushReplacementNamed(context, LandingPage.idScreen);
              }
            });
          } else {
            if (kDebugMode) {
              print('Login failed');
            }
          }
        } catch (e) {
          error = 'Invalid OTP';
          loading = false;
          notifyListeners();

          if (kDebugMode) {
            print(e.toString());
          }
        }
      loading = false;
      notifyListeners();
    });
  }
}
