// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBrl6QNHq1vdgvS9V353HliV9r3LJMJfxA',
    appId: '1:957120408982:web:0e690dea8674c2c2b9c1b7',
    messagingSenderId: '957120408982',
    projectId: 'bookmyshowclone-db2ce',
    authDomain: 'bookmyshowclone-db2ce.firebaseapp.com',
    storageBucket: 'bookmyshowclone-db2ce.appspot.com',
    measurementId: 'G-14G88VM4ZE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAzbjxpX-em_rrhpesV6XStCr8hBphjUqY',
    appId: '1:957120408982:android:d71af0e23e5b60b1b9c1b7',
    messagingSenderId: '957120408982',
    projectId: 'bookmyshowclone-db2ce',
    storageBucket: 'bookmyshowclone-db2ce.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAJ3wQVY9HwEUMyQRZ_dMKf27F_QmWmJic',
    appId: '1:957120408982:ios:37d64d748d15f1d3b9c1b7',
    messagingSenderId: '957120408982',
    projectId: 'bookmyshowclone-db2ce',
    storageBucket: 'bookmyshowclone-db2ce.appspot.com',
    androidClientId: '957120408982-nsnint38dmraugiqdr30eiqe9kmqutrc.apps.googleusercontent.com',
    iosClientId: '957120408982-pd21vfitc8gsofli8uq5hbiaubh73kft.apps.googleusercontent.com',
    iosBundleId: 'com.example.movieHallTicketBookingSystem',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAJ3wQVY9HwEUMyQRZ_dMKf27F_QmWmJic',
    appId: '1:957120408982:ios:37d64d748d15f1d3b9c1b7',
    messagingSenderId: '957120408982',
    projectId: 'bookmyshowclone-db2ce',
    storageBucket: 'bookmyshowclone-db2ce.appspot.com',
    androidClientId: '957120408982-nsnint38dmraugiqdr30eiqe9kmqutrc.apps.googleusercontent.com',
    iosClientId: '957120408982-pd21vfitc8gsofli8uq5hbiaubh73kft.apps.googleusercontent.com',
    iosBundleId: 'com.example.movieHallTicketBookingSystem',
  );
}