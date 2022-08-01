
import 'package:book_my_show_clone/screens/welcomScreen/welcome_screen.dart';
import 'package:book_my_show_clone/utils/asset_images_strings.dart';
import 'package:book_my_show_clone/utils/color_palette.dart';
import 'package:book_my_show_clone/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../services/firebaseServices/firebase_services.dart';
import '../../services/sharedService/shared_preference_service.dart';
import '../init_screen.dart';
import '../registration_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  late FirebaseServices _userServices;
 

  @override
  void initState() {
    super.initState();

    _userServices =  FirebaseServices();
    Future.delayed(const Duration(milliseconds: 4000), () {
      if (FirebaseAuth.instance.currentUser != null) {
        _userServices.getUserById(user!.uid).then((snapShot) {
          if (snapShot.exists) {
            if (kDebugMode) {
              print("UserName :  ${snapShot['name']}");
            }
            SharedServices.addUserDataToSF(
              userName: '${snapShot['name']}',
              userPhone: '${snapShot['number']}',
              userEmail: '${snapShot['email']}',
              userPhoto: '${snapShot['profile_Pic_URL']}',
            );
            Navigator.pushReplacementNamed(context, InitScreen.id);
          } else {
            if (kDebugMode) {
              print("Registration needed");
            }
            //user data does not exists
            //will create new data in db
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => RegistrationScreen(
                          phoneNumber: user!.phoneNumber!,
                          uid: user!.uid,
                        )));
          }
        });
      } else {
        Navigator.popAndPushNamed(context, WelcomeScreen.id);
        if (kDebugMode) {
          print("WELCOME SCREEN");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primary,
      body: SizedBox(
        height: SizeConfig.fullHeight,
        width: SizeConfig.fullWidth,
        child: Center(
          child: Image.asset(
            AssetImageClass.splashAppLogo,
            width: SizeConfig.fullWidth / 1,
          ),
        ),
      ),
    );
  }
}
