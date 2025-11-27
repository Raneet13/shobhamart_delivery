import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sm_delivery/api/login.dart';
import 'package:sm_delivery/core/utils/shared_preference.dart';
import 'package:sm_delivery/firebase_options.dart';
import 'package:sm_delivery/localnotification.dart';
import 'package:sm_delivery/models/login_details/user_detail.dart';
import 'package:sm_delivery/screens/wrapper.dart';
import 'components/shopping_cart.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message.notification == null) {
    await LocalNotificationService.createanddisplaynotification(message);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
   FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);


  await SharedPreferencesService.initialize();
  final details = await FlutterLocalNotificationsPlugin()
      .getNotificationAppLaunchDetails();

  final payload = details?.notificationResponse?.payload;
  bool openedFromNotification = false;
  if (payload != null && payload.isNotEmpty) {
    LocalNotificationService.initialPayload = payload;
  openedFromNotification = true;
  }

runApp(MyApp(launchedFromNotification: openedFromNotification));

  // runApp(const MyApp());
}

class MyApp extends StatefulWidget {
 final bool launchedFromNotification;
  const MyApp({super.key, required this.launchedFromNotification});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   
    @override
  void initState() {
    super.initState();
    _initializeServices();
     WidgetsBinding.instance.addPostFrameCallback((_) async {
    // 🔹 Handle notification tap from terminated state
    
    if ( LocalNotificationService.initialPayload != null) {
      await LocalNotificationService.handleNotificationTap(
          LocalNotificationService.initialPayload!);
      LocalNotificationService.initialPayload = null;
    }
  });
  }
   Future<void> _initializeServices() async {
    await LocalNotificationService.initialize();
    _initFirebaseMessaging();
  }
  void _initFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request notification permission (iOS & Android 13+)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');

    // ✅ Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📩 Foreground message: ${message.notification?.title}");
      LocalNotificationService.createanddisplaynotification(message);
    });

    // ✅ Background → App opened
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("📲 App opened from background: ${message.data}");
      LocalNotificationService.handleNotificationTap(jsonEncode(message.data));
    });

    // ✅ Terminated → App launched by tapping notification
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      debugPrint("🚀 App launched from terminated state: ${initialMessage.data}");
      // LocalNotificationService.createanddisplaynotification(initialMessage);
       LocalNotificationService.handleNotificationTap(jsonEncode(initialMessage.data));
    }
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CartNotifier(),
          child: wrapper(),
        ),
        StreamProvider<userResponse?>(
          create: (context) => userDetailsStream(
              SharedPreferencesService.getString('username')!,
              SharedPreferencesService.getString('password')!),
          initialData: null,
          // child: wrapper(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: ThemeData(fontFamily: 'Roboto'),
        routes: {'/wrapper': (context) => wrapper()},
        initialRoute: '/wrapper',
      ),
    );
  }
}
