import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCJq0nNMF7Wl1VNvQ-NCzePjJ35fcisH4c",
            authDomain: "esof-kcfxqr.firebaseapp.com",
            projectId: "esof-kcfxqr",
            storageBucket: "esof-kcfxqr.appspot.com",
            messagingSenderId: "948297930183",
            appId: "1:948297930183:web:45ebb71b87aa4616d075e2"));
  } else {
    await Firebase.initializeApp();
  }
}
