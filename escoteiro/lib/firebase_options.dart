// File generated manually with Firebase project configuration
// Project: aplicativo-8febe

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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA9uACvzQebzMlEj6JMm8YfXdmHxwDG-v0',
    appId: '1:565712688011:web:app_id_placeholder',
    messagingSenderId: '565712688011',
    projectId: 'aplicativo-8febe',
    authDomain: 'aplicativo-8febe.firebaseapp.com',
    storageBucket: 'aplicativo-8febe.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA9uACvzQebzMlEj6JMm8YfXdmHxwDG-v0',
    appId: '1:565712688011:android:app_id_placeholder',
    messagingSenderId: '565712688011',
    projectId: 'aplicativo-8febe',
    storageBucket: 'aplicativo-8febe.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA9uACvzQebzMlEj6JMm8YfXdmHxwDG-v0',
    appId: '1:565712688011:ios:app_id_placeholder',
    messagingSenderId: '565712688011',
    projectId: 'aplicativo-8febe',
    storageBucket: 'aplicativo-8febe.appspot.com',
    iosBundleId: 'com.example.escoteiro',
  );
}
