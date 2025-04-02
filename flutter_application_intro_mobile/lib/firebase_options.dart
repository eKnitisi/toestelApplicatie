// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyCLHEoUi-Ed1ogys3B1MI_fRGnor6XMLJg',
    appId: '1:549597755348:web:54d9954baf6163e6608841',
    messagingSenderId: '549597755348',
    projectId: 'intromobiletoestelapp',
    authDomain: 'intromobiletoestelapp.firebaseapp.com',
    storageBucket: 'intromobiletoestelapp.firebasestorage.app',
    measurementId: 'G-QZVDRZMRRS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDNqenDIfNbLm4QBxMe3nSXyh53YRi62I0',
    appId: '1:549597755348:android:d123dfff97c04a64608841',
    messagingSenderId: '549597755348',
    projectId: 'intromobiletoestelapp',
    storageBucket: 'intromobiletoestelapp.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCLHEoUi-Ed1ogys3B1MI_fRGnor6XMLJg',
    appId: '1:549597755348:web:7698027385565623608841',
    messagingSenderId: '549597755348',
    projectId: 'intromobiletoestelapp',
    authDomain: 'intromobiletoestelapp.firebaseapp.com',
    storageBucket: 'intromobiletoestelapp.firebasestorage.app',
    measurementId: 'G-HE0F8G3ZV5',
  );
}
