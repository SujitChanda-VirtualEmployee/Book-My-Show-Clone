import 'package:book_my_show_clone/utils/color_palette.dart';
import 'package:book_my_show_clone/utils/size_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../services/providerService/auth_provider.dart';
import '../../widgets/customer_loader.dart';
import '../../widgets/onboard_screen.dart';
import '../../widgets/rounded_icon_btn.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome-screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final SmsAutoFill autoFill = SmsAutoFill();
  TextEditingController phoneNumberController =  TextEditingController();
  late String completePhoneNumber;
  bool isValid2 = false;
  bool isValid = false;
  bool numberSubmit = false;

  String? validateMobile(String value) {
    if (value.isEmpty) {
      return "*Mobile Number is Required";
    } else if (value.length < 10 || value.length > 10) {
      return "*Enter valid Number";
    } else {
      return null;
    }
  }

  Future<void> validatePhone(StateSetter updateState) async {
    if (kDebugMode) {
      print("in validate : ${phoneNumberController.text.length}");
    }
    if (phoneNumberController.text.length > 9 &&
        phoneNumberController.text.length < 11) {
      updateState(() {
        isValid = true;
      });
      if (kDebugMode) {
        print(isValid);
      }
    } else {
      updateState(() {
        isValid = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    void validatePhoneNumber(BuildContext context) async {
      // if (Platform.isAndroid) {
      //   try {
      //     completePhoneNumber = (await _autoFill.hint)!;
      //     setState(() {
      //       phoneNumberController.text = completePhoneNumber.substring(3);
      //     });
      //   } catch (e) {
      //     if (kDebugMode) {
      //       print(e.toString());
      //     }
      //   }
      // }

      showModalBottomSheet(
          isDismissible: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)),
          ),
          backgroundColor: Colors.white,
          isScrollControlled: true,
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
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'OTP Verification',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "* You need to verify your Phone Number via OTP Verification process to Register / Login to your account.",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.grey[500], fontSize: 10),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (val) => validateMobile(val!),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontSize: 18),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 15, right: 15),
                                prefix: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("+91",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color: Colors.grey,
                                            fontSize: 17,
                                          )),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      width: 0.2,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(30.0),
                                    ),
                                    gapPadding: 1),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    width: 0.5,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(30.0),
                                  ),
                                ),
                                labelText: " Mobile Number",
                                labelStyle:
                                    Theme.of(context).textTheme.bodyText1,
                                hintText: 'Mobile Number *',
                                hintStyle:
                                    Theme.of(context).textTheme.bodyText1,
                              ),
                              //maxLength: 10,

                              keyboardType: TextInputType.number,
                              controller: phoneNumberController,
                              autofocus: true,
                              onChanged: (text) {
                                validatePhone(state);
                              },
                              autovalidateMode: AutovalidateMode.always,
                              autocorrect: false,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Visibility(
                              visible: phoneNumberController.text.length > 9 &&
                                  phoneNumberController.text.length < 11,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: RoundedIconBtn(
                                  bgColor: Colors.white,
                                  showShadow: true,
                                  radius: 26,
                                  icon: Icons.send_outlined,
                                  iconColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  iconSize: 25,
                                  press: () {
                                    if (kDebugMode) {
                                      print("IsValid : $isValid");
                                      print("IsValid2 : $isValid2");
                                    }

                                    state(() {
                                      numberSubmit = true;
                                    });
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                ),
                              ))
                        ],
                      ),
                    ],
                  ),
                );
              })).whenComplete(() {
        if (phoneNumberController.text.length == 10 && numberSubmit) {
          if (kDebugMode) {
            print(phoneNumberController.text);
          }
          setState(() {
            auth.loading = true;
          });
          String number = '+91${phoneNumberController.text}';

          auth
              .verifyPhone(
            context: context,
            number: number,
          )
              .then((value) {
            phoneNumberController.clear();
          });
        } else {
          phoneNumberController.clear();
        }
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorPalette.primary,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Column(
              children: [
                const Expanded(
                  child: OnBaordScreen(),
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: ColorPalette.secondary,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text.rich(
                            TextSpan(
                                text: 'A Clone of ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: ColorPalette.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: ' Book My Show App',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: ColorPalette.primary,
                                        ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Container(),
                                  ),
                                  TextSpan(
                                    text:
                                        '  made with Flutter, Firebase and OMDB ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: ColorPalette.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Container(),
                                  )
                                ]),
                            textAlign: TextAlign.center),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  // side: BorderSide(color: bgColor, width: 0.0),
                                  borderRadius: BorderRadius.circular(8)),
                              primary: ColorPalette.primary,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "LOGIN",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        letterSpacing: 2,
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                auth.screen = 'Login';
                              });

                              validatePhoneNumber(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible: auth.loading,
              child: glassLoading(),
            )
          ],
        ),
      ),
    );
  }
}

//Lets do a restart.
