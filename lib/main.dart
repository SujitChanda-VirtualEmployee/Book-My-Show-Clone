import 'package:book_my_show_clone/screens/splashScreen/splash_screen.dart';
import 'package:book_my_show_clone/services/providerService/api_data_provider.dart';
import 'package:book_my_show_clone/services/providerService/auth_provider.dart';
import 'package:book_my_show_clone/services/providerService/location_provider.dart';
import 'package:book_my_show_clone/utils/app_theme.dart';
import 'package:book_my_show_clone/utils/color_palette.dart';
import 'package:book_my_show_clone/utils/routes.dart';
import 'package:book_my_show_clone/utils/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

SharedPreferences? preferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configLoading();
  preferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Stripe.publishableKey =
      "pk_test_51BTUDGJAJfZb9HEBwDg86TN1KNprHjkfipXmEDMb0gSCassK5T3ZfxsAbcgKVmAIXF7oZ6ItlZZbXO6idTHE67IM007EwQ4uN3";
  Stripe.merchantIdentifier = "Book My Show";
  await Stripe.instance.applySettings();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ApiDataProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..indicatorWidget = const CupertinoActivityIndicator(
      color: Colors.black,
      radius: 20,
    )
    ..radius = 8.0
    ..boxShadow = [
      const BoxShadow(
          offset: Offset(0.7, 0.7),
          color: ColorPalette.secondary,
          blurRadius: 2,
          spreadRadius: 2)
    ]
    ..maskColor = ColorPalette.secondary.withOpacity(0.5)
    ..maskType = EasyLoadingMaskType.custom
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: ColorPalette.secondary,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return GetMaterialApp(
      title: 'Bokok My Show',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      builder: EasyLoading.init(),
      home: LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return const SplashScreen();
          });
        },
      ),
      onGenerateRoute: RouteGenerator.generateRoutes,
    );
  }
}
