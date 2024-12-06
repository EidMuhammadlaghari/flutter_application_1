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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyCGixqekzEmUUSFBvP6GrPFsqwngwW0thU',
    appId: '1:688533847849:web:f360e6cdf459caf9974138',
    messagingSenderId: '688533847849',
    projectId: 'fyp-1bd7e',
    authDomain: 'fyp-1bd7e.firebaseapp.com',
    storageBucket: 'fyp-1bd7e.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAaLAmA3Xfm5EuFlfst3D4zr_d4g9TqP90',
    appId: '1:688533847849:android:4b9654bd5694ed1e974138',
    messagingSenderId: '688533847849',
    projectId: 'fyp-1bd7e',
    storageBucket: 'fyp-1bd7e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBlaoeDLuK-Wi7x4JX2CKRQufYENEMJd8k',
    appId: '1:688533847849:ios:9fe25292c5e9d38d974138',
    messagingSenderId: '688533847849',
    projectId: 'fyp-1bd7e',
    storageBucket: 'fyp-1bd7e.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBlaoeDLuK-Wi7x4JX2CKRQufYENEMJd8k',
    appId: '1:688533847849:ios:9fe25292c5e9d38d974138',
    messagingSenderId: '688533847849',
    projectId: 'fyp-1bd7e',
    storageBucket: 'fyp-1bd7e.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCGixqekzEmUUSFBvP6GrPFsqwngwW0thU',
    appId: '1:688533847849:web:edd02677a355ef83974138',
    messagingSenderId: '688533847849',
    projectId: 'fyp-1bd7e',
    authDomain: 'fyp-1bd7e.firebaseapp.com',
    storageBucket: 'fyp-1bd7e.firebasestorage.app',
  );
}
