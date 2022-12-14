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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBJLjU62Coyb1t8dj_OvM_WoFI7-nXfFWI',
    appId: '1:348006578830:web:a9b2308a3a9feda07267df',
    messagingSenderId: '348006578830',
    projectId: 'bellani-talents',
    authDomain: 'bellani-talents.firebaseapp.com',
    storageBucket: 'bellani-talents.appspot.com',
    measurementId: 'G-L470CPJY2Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCFTy3i3fJmKeKqK-UFZUSxfVI0XOZhVmI',
    appId: '1:348006578830:android:01784f87c229318d7267df',
    messagingSenderId: '348006578830',
    projectId: 'bellani-talents',
    storageBucket: 'bellani-talents.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBpTqrwzOGUBOmm9CvHJt5SlNki2rXjIdA',
    appId: '1:348006578830:ios:b41da684971de81b7267df',
    messagingSenderId: '348006578830',
    projectId: 'bellani-talents',
    storageBucket: 'bellani-talents.appspot.com',
    androidClientId: '348006578830-g195jbqhuk0vaqj6iihif72t4saajael.apps.googleusercontent.com',
    iosClientId: '348006578830-bv3vlcqq5rkq9h9ktarcvt0vf3i2rnu1.apps.googleusercontent.com',
    iosBundleId: 'bellani.talents',
  );
}
