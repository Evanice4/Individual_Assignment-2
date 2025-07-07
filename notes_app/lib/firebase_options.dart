import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD3AnM52pdl7DtmFN8PKfCGVzpyLxptw84',
    appId: '1:997695311497:android:ea55d7fe942fcbca850058',
    messagingSenderId: '997695311497',
    projectId: 'notes-d4f24',
    storageBucket: 'notes-d4f24.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBx0KE4QXd4ZG1ZFXGem8hMO29WWdm2qQw',
    appId: '1:843610532723:ios:e4f87210aa514b3d2cf306',
    messagingSenderId: '843610532723',
    projectId: 'note-application-a3e8f',
    storageBucket: 'note-application-a3e8f.firebasestorage.app',
    iosBundleId: 'com.example.noteApplication',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDHkAOtSes9-9FEfY1mnB4R4VcYu2jAcEY',
    appId: '1:997695311497:web:574908621f4624c8850058',
    messagingSenderId: '997695311497',
    projectId: 'notes-d4f24',
    authDomain: 'notes-d4f24.firebaseapp.com',
    storageBucket: 'notes-d4f24.firebasestorage.app',
    measurementId: 'G-K6XN8JY7K1',
  );

}