import 'package:book_my_show_clone/screens/buzzScreen/buzz_screen.dart';
import 'package:book_my_show_clone/screens/profileScreen/profile_screen.dart';
import 'package:book_my_show_clone/screens/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/movie_details_model.dart';
import '../screens/homeScreen/home_screen.dart';
import '../screens/init_screen.dart';
import '../screens/landingScreen/landing_screen.dart';
import '../screens/location_permission_screen.dart';
import '../screens/mediaDetailsScreen/media_details_screen.dart';

import '../screens/paymentScreen/payment_screen.dart';
import '../screens/paymentScreen/payment_success.dart';
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

      // case OnboardingScreen.id:
      //   return CupertinoPageRoute(
      //       builder: (context) => const OnboardingScreen());
      // case LoginScreen.id:
      //   return CupertinoPageRoute(builder: (context) => const LoginScreen());
      // case SignupScreen.id:
      //   return CupertinoPageRoute(builder: (context) => const SignupScreen());
      // case ForgotPasswordScreen.id:
      //   return CupertinoPageRoute(
      //       builder: (context) => const ForgotPasswordScreen());
      // case OtpVerificationScreen.id:
      //   if (args is NavigationFrom) {
      //     return CupertinoPageRoute(
      //         builder: (context) => OtpVerificationScreen(from: args));
      //   }
      //   return _errorRoutes();

      // case ResetPasswordScreen.id:
      //   return CupertinoPageRoute(
      //       builder: (context) => const ResetPasswordScreen());
      // case LocationPermissionScreen.id:
      //   if (args is List<String>) {
      //     return CupertinoPageRoute(
      //         builder: (context) => LocationPermissionScreen(
      //               title: args[0],
      //               body: args[1],
      //             ));
      //   }
      //   return _errorRoutes();
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

      // case SettingsScreen.id:
      //   return CupertinoPageRoute(builder: (context) => const SettingsScreen());
      // case HistoryScreen.id:
      //   return CupertinoPageRoute(builder: (context) => const HistoryScreen());
      // case NotificationScreen.id:
      //   return CupertinoPageRoute(
      //       builder: (context) => const NotificationScreen());
      // case ChangePasswordScreen.id:
      //   return CupertinoPageRoute(
      //       builder: (context) => const ChangePasswordScreen());
      // case RatingScreen.id:
      //   return CupertinoPageRoute(builder: (context) => const RatingScreen());
      // case ContactUsScreen.id:
      //   return CupertinoPageRoute(
      //       builder: (context) => const ContactUsScreen());
      // case AboutUsScreen.id:
      //   return CupertinoPageRoute(builder: (context) => const AboutUsScreen());
      case ProfileScreen.id:
        return CupertinoPageRoute(builder: (context) => const ProfileScreen());
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
                  ));
        }
        return _errorRoutes();

      // case UpdateProfileScreen.id:
      //   return CupertinoPageRoute(
      //       builder: (context) => const UpdateProfileScreen());
      // case PaymentMethodScreen.id:
      //   return CupertinoPageRoute(
      //       builder: (context) => const PaymentMethodScreen());
      // case AddNewCardScreen.id:
      //   return CupertinoPageRoute(
      //       builder: (context) => const AddNewCardScreen());

      // case ManageVehicleScreen.id:
      //   if (args is NavigationFrom) {
      //     return CupertinoPageRoute(
      //         builder: (context) => ManageVehicleScreen(from: args));
      //   }
      //   return _errorRoutes();

      // case ManageDocumentScreen.id:
      //   if (args is NavigationFrom) {
      //     return CupertinoPageRoute(
      //         builder: (context) => ManageDocumentScreen(from: args));
      //   }
      //   return _errorRoutes();

      // case ManageAccountScreen.id:
      //   return CupertinoPageRoute(
      //       builder: (context) => const ManageAccountScreen());
      // case NewBookingDetailsScreen.id:
      //   return CupertinoPageRoute(
      //       builder: (context) => const NewBookingDetailsScreen());
      // case RideVerifyPinScreen.id:
      //   return CupertinoPageRoute(
      //       builder: (context) => const RideVerifyPinScreen());
      // case RideCompleteScreen.id:
      //   return CupertinoPageRoute(
      //       builder: (context) => const RideCompleteScreen());
      // case RideRatingScreen.id:
      //   return CupertinoPageRoute(
      //       builder: (context) => const RideRatingScreen());
      // case WalletScreen.id:
      //   return CupertinoPageRoute(builder: (context) => const WalletScreen());
      // case UpdateAccountScreen.id:
      //   return CupertinoPageRoute(
      //       builder: (context) => const UpdateAccountScreen());
      // case DisplayVehicleScreen.id:
      //   return CupertinoPageRoute(
      //       builder: (context) => const DisplayVehicleScreen());
      //  case DisplayDocumentScreen.id:
      //   return CupertinoPageRoute(
      //       builder: (context) => const DisplayDocumentScreen());
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
