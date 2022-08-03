import 'package:book_my_show_clone/screens/buzzScreen/buzz_screen.dart';
import 'package:book_my_show_clone/screens/profileScreen/profile_screen.dart';
import 'package:book_my_show_clone/screens/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/movie_details_model.dart';
import '../models/purchase_history_model.dart';
import '../screens/homeScreen/home_screen.dart';
import '../screens/init_screen.dart';
import '../screens/landingScreen/landing_screen.dart';
import '../screens/location_permission_screen.dart';
import '../screens/mapScreen/map_screen.dart';
import '../screens/mediaDetailsScreen/media_details_screen.dart';

import '../screens/paymentScreen/payment_screen.dart';
import '../screens/paymentScreen/payment_success.dart';
import '../screens/profileScreen/accountSertingScreen/account_settings_screen.dart';
import '../screens/profileScreen/editProfileScreen/edit_profile_screen.dart';
import '../screens/profileScreen/purchaseHistoryScreen/components/history_details_screen.dart';
import '../screens/profileScreen/purchaseHistoryScreen/purchase_history_screen.dart';
import '../screens/searchScreen/search_screen.dart';
import '../screens/selectMovieHallScreen/select_movie_hall_screen.dart';
import '../screens/splashScreen/splash_screen.dart';
import '../screens/ticketBookingScreen/ticket_booking_screen.dart';
import '../screens/welcomScreen/welcome_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoutes(
    RouteSettings settings,
  ) {
    final args = settings.arguments;
    switch (settings.name) {
      case SplashScreen.id:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case HomeScreen.id:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case BuzzScreen.id:
        return MaterialPageRoute(builder: (context) => const BuzzScreen());
      case InitScreen.id:
        return MaterialPageRoute(builder: (context) => const InitScreen());
      case EditProfileScreen.id:
        return MaterialPageRoute(
            builder: (context) => const EditProfileScreen());
      case AccountSettingScreen.id:
        return MaterialPageRoute(
            builder: (context) => const AccountSettingScreen());
      case MapScreen.id:
        return MaterialPageRoute(builder: (context) => const MapScreen());

      case LocationPermissionScreen.id:
        if (args is List<String>) {
          return CupertinoPageRoute(
              builder: (context) => LocationPermissionScreen(
                    title: args[0],
                    body: args[1],
                  ));
        }
        return _errorRoutes();

      case MediaDetailsScreen.id:
        if (args is List<dynamic>) {
          return CupertinoPageRoute(
              builder: (context) => MediaDetailsScreen(
                    title: args[0],
                    mediaId: args[1],
                    mediaType: args[2],
                  ));
        }
        return _errorRoutes();
      case TicketBookingScreen.id:
        if (args is List<dynamic>) {
          return CupertinoPageRoute(
              builder: (context) => TicketBookingScreen(
                    movieDetailsData: args[0],
                    theatreDetailsData: args[1],
                    selectedDate: args[2],
                    selectedTime: args[3],
                    ticketCount: args[4],
                  ));
        }
        return _errorRoutes();

      case LandingScreen.id:
        return CupertinoPageRoute(builder: (context) => const LandingScreen());
      case WelcomeScreen.id:
        return CupertinoPageRoute(builder: (context) => const WelcomeScreen());
      case SearchScreen.id:
        return CupertinoPageRoute(builder: (context) => const SearchScreen());

      case RegistrationScreen.id:
        if (args is List<dynamic>) {
          return CupertinoPageRoute(
              builder: (context) => RegistrationScreen(
                    phoneNumber: args[0],
                    uid: args[1],
                  ));
        }
        return _errorRoutes();

      case SelectMovieHallScreen.id:
        if (args is MovieDetailsModel) {
          return CupertinoPageRoute(
              builder: (context) => SelectMovieHallScreen(
                    movieDetailsData: args,
                  ));
        }
        return _errorRoutes();

      case ProfileScreen.id:
        return CupertinoPageRoute(builder: (context) => const ProfileScreen());
      case PurchaseHistoryScreen.id:
        return CupertinoPageRoute(
            builder: (context) => const PurchaseHistoryScreen());
      case HistoryDetailsScreen.id:
        if (args is PurchaseHistoryModel) {
          return CupertinoPageRoute(
              builder: (context) => HistoryDetailsScreen(
                    model: args,
                  ));
        }
        return _errorRoutes();

      case PaymentScreen.id:
        if (args is List<dynamic>) {
          return CupertinoPageRoute(
              builder: (context) => PaymentScreen(
                    chairList: args[4],
                    movieDetailsData: args[0],
                    selectedDate: args[2],
                    selectedTime: args[3],
                    theatreDetailsData: args[1],
                  ));
        }
        return _errorRoutes();

      case PaymentSuccessScreen.id:
        if (args is List<dynamic>) {
          return CupertinoPageRoute(
              builder: (context) => PaymentSuccessScreen(
                    chairList: args[4],
                    movieDetailsData: args[0],
                    selectedDate: args[2],
                    selectedTime: args[3],
                    theatreDetailsData: args[1],
                    orderID: args[5],
                  ));
        }
        return _errorRoutes();

      default:
        return _errorRoutes();
    }
  }

  static Route<dynamic> _errorRoutes() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Page not found!")),
      );
    });
  }
}
