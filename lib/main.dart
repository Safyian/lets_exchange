import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lets_exchange/screens/splash.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  OneSignal.shared.setAppId('23ef2e1f-3ed9-474f-9975-d56982cbc641');
  // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  await OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true);
  await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
