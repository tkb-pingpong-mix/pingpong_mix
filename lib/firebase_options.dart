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
    apiKey: 'AIzaSyDUN0by605847O4Ilg27SWsQ9KgX8Pof8s',
    appId: '1:603032301274:web:bb8660d1a764fbc8bfffe3',
    messagingSenderId: '603032301274',
    projectId: 'pingpong-mix-dev',
    authDomain: 'pingpong-mix-dev.firebaseapp.com',
    storageBucket: 'pingpong-mix-dev.appspot.com',
    measurementId: 'G-5ZCKF5H7XV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCTaPWqbR3CX48sbxieslgDV5nmPmRyqeM',
    appId: '1:603032301274:android:eb7b2740efb3b64ebfffe3',
    messagingSenderId: '603032301274',
    projectId: 'pingpong-mix-dev',
    storageBucket: 'pingpong-mix-dev.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBbAVEvmUt-0HWnGGXEPMtWEg86npwMxi8',
    appId: '1:603032301274:ios:95a4253a69d4dbcfbfffe3',
    messagingSenderId: '603032301274',
    projectId: 'pingpong-mix-dev',
    storageBucket: 'pingpong-mix-dev.appspot.com',
    iosBundleId: 'com.example.pingpongMix',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBbAVEvmUt-0HWnGGXEPMtWEg86npwMxi8',
    appId: '1:603032301274:ios:95a4253a69d4dbcfbfffe3',
    messagingSenderId: '603032301274',
    projectId: 'pingpong-mix-dev',
    storageBucket: 'pingpong-mix-dev.appspot.com',
    iosBundleId: 'com.example.pingpongMix',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDUN0by605847O4Ilg27SWsQ9KgX8Pof8s',
    appId: '1:603032301274:web:aaa4d26ecd8b0e38bfffe3',
    messagingSenderId: '603032301274',
    projectId: 'pingpong-mix-dev',
    authDomain: 'pingpong-mix-dev.firebaseapp.com',
    storageBucket: 'pingpong-mix-dev.appspot.com',
    measurementId: 'G-8NCQ4KJB09',
  );
}
