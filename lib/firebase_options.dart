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
    apiKey: 'AIzaSyD0AeEQ2z8QyPpFdyCAZz9S_XqC7ux9t-A',
    appId: '1:175566289154:web:bba8dc1535f46de395ea1b',
    messagingSenderId: '175566289154',
    projectId: 'travelapp-e8adb',
    authDomain: 'travelapp-e8adb.firebaseapp.com',
    storageBucket: 'travelapp-e8adb.appspot.com',
    measurementId: 'G-VXSB7ETKZN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyASJd9FGVSY0u2d770p5QxP9aZjPDO1PSM',
    appId: '1:175566289154:android:729c5293ea9d7dd095ea1b',
    messagingSenderId: '175566289154',
    projectId: 'travelapp-e8adb',
    storageBucket: 'travelapp-e8adb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB9ChGceHPGE3ZyLsNI9Cl-LshcB-a5igo',
    appId: '1:175566289154:ios:097a183479167a4795ea1b',
    messagingSenderId: '175566289154',
    projectId: 'travelapp-e8adb',
    storageBucket: 'travelapp-e8adb.appspot.com',
    iosBundleId: 'com.example.travelapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB9ChGceHPGE3ZyLsNI9Cl-LshcB-a5igo',
    appId: '1:175566289154:ios:a2ff8eaedcc8bb3495ea1b',
    messagingSenderId: '175566289154',
    projectId: 'travelapp-e8adb',
    storageBucket: 'travelapp-e8adb.appspot.com',
    iosBundleId: 'com.example.travelapp.RunnerTests',
  );
}
