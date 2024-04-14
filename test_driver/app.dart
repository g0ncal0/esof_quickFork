import 'package:esof/backend/firebase/firebase_config.dart';
import 'package:esof/backend/stripe/payment_manager.dart';
import 'package:esof/flutter_flow/flutter_flow_theme.dart';
import 'package:firebase_core/firebase_core.dart';

import '../lib/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';


Future<void> main() async {
  // This line enables the extension
  enableFlutterDriverExtension();

  // Call the `main()` function of your app or call `runApp` with any widget you
  // are interested in testing.
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  try {
    Firebase.initializeApp();
  } catch(e) {
    print(e);
  }

  await initFirebase();

  await FlutterFlowTheme.initialize();

  await initializeStripe();

  runApp(const QuickFork());
}