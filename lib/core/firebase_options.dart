
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {

  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
  /// Production mode
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCX4ut6XUyJewFRSBmpFRErrkKGJGRPaiY',
    appId: '1:756208192158:android:d33a3ecd344d6922a7498f',
    messagingSenderId: '756208192158',
    projectId: 'my-neber-development',
    storageBucket: 'my-neber-development.appspot.com',
  );
















}
