import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: "AIzaSyD_zSV6NixpO-2amn7rEmchVLtKBLfgu-4",
        authDomain: "readora-e331b.firebaseapp.com",
        projectId: "readora-e331b",
        storageBucket: "readora-e331b.appspot.com",
        messagingSenderId: "742798402849",
        appId: "1:742798402849:web:7828ce437693cd4f0fca60",
        measurementId: "G-34XVB6QDPE",
      );
    }
    throw UnsupportedError("Platform not supported");
  }
}