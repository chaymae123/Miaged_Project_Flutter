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
    apiKey: 'AIzaSyBZpeRZSirhI7wFUtHfpT813b-bGaauzdw',
    appId: '1:205929577840:web:7e22c19c466b3b7deb23b5',
    messagingSenderId: '205929577840',
    projectId: 'miagedproject-29256',
    authDomain: 'miagedproject-29256.firebaseapp.com',
    storageBucket: 'miagedproject-29256.appspot.com',
    measurementId: 'G-QJ00FGQ6XM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAoLd8nj95gAb7ewVHoQYxg2IyA6guAJfA',
    appId: '1:205929577840:android:013189dd356f614beb23b5',
    messagingSenderId: '205929577840',
    projectId: 'miagedproject-29256',
    storageBucket: 'miagedproject-29256.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCem8jB8_lUQQmAtI4C9cYh5i3fBTTTL0A',
    appId: '1:205929577840:ios:aef8caae02f20267eb23b5',
    messagingSenderId: '205929577840',
    projectId: 'miagedproject-29256',
    storageBucket: 'miagedproject-29256.appspot.com',
    iosClientId: '205929577840-0djdq5h8prbokadaphtvheoce7j77318.apps.googleusercontent.com',
    iosBundleId: 'com.example.miagedProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCem8jB8_lUQQmAtI4C9cYh5i3fBTTTL0A',
    appId: '1:205929577840:ios:aef8caae02f20267eb23b5',
    messagingSenderId: '205929577840',
    projectId: 'miagedproject-29256',
    storageBucket: 'miagedproject-29256.appspot.com',
    iosClientId: '205929577840-0djdq5h8prbokadaphtvheoce7j77318.apps.googleusercontent.com',
    iosBundleId: 'com.example.miagedProject',
  );
}
