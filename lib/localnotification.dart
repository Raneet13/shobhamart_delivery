import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sm_delivery/api/login.dart';
import 'package:sm_delivery/api/order.dart';
import 'package:sm_delivery/core/utils/shared_preference.dart';
import 'package:sm_delivery/main.dart';
import 'package:sm_delivery/models/order_details_response.dart';
import 'package:sm_delivery/models/order_response.dart';
import 'package:sm_delivery/screens/delivery_detailed_screen/delivery_detailed_screen.dart';



class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
       static String? initialPayload;

  /// 🔹 Call this in `main()` before runApp()
  static Future<void> initialize() async {
    // Request permission (Android 13+)
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap
    //   onDidReceiveNotificationResponse: (response) async{
    //     // Handle tap actions here
    //         try {
    //   debugPrint("Notification clicked!");
    //   debugPrint("Notification payload: ${response.payload}");

    //   if (response.payload == null || response.payload!.isEmpty) return;

    //   // ✅ Decode JSON directly
    //   Map<String, dynamic> data = jsonDecode(response.payload!);

    //   String orderId = data['order_id'] ?? '';
    //   debugPrint("Order ID: $orderId");

    //   if (orderId.isNotEmpty) {
    //      final number = SharedPreferencesService.getString("user_id");
    // final token =SharedPreferencesService.getString("token_id");

    //   final userDetails = await verify_api().verify_user(phone: number??"",deviceToken:token??"" );
  
    //     final orders = await get_single_orders_api().get_single_orders(order_id: orderId);

    //     if (orders != null &&
    //       orders.data != null &&
    //       orders.data.orderDetails != null && userDetails !=null) {
    //     debugPrint("✅ Order data loaded successfully");

    //     // ✅ Only navigate if order details are present
    //     navigatorKey.currentState?.push(
    //       MaterialPageRoute(
    //         builder: (context) => order_detailed_screen(
    //           all_order_response: orders.data.orderDetails,
    //           user:userDetails
    //         ),
    //       ),
    //     );
    //   } else {
    //     debugPrint("⚠️ Order data is null or incomplete, not navigating");
    //   }
    //   }
    // } catch (e, s) {
    //   debugPrint("Error parsing notification payload: $e\n$s");
    // }
    //   }
    
    );
    
  
    // 🔹 Create a high-importance notification channel manually
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'sobhamartdelivery', // same as manifest
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );
  await _notificationsPlugin
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.createNotificationChannel(channel);
    
  }

static Future<void> _onNotificationTap(
      NotificationResponse response) async {
       
    if (response.payload == null || response.payload!.isEmpty) return;
    await handleNotificationTap(response.payload!);
  }

  static Future<void> handleNotificationTap(String payload) async {
     print(payload);
     try {
     
    // Decode payload from notification
    final Map<String, dynamic> data = jsonDecode(payload);

    final String appointmentId = data['order_id']?.toString() ?? "";
    if (appointmentId.isEmpty) {
      debugPrint("❌ order_id missing in payload");
      return;
    }

    // Call API
       final username = SharedPreferencesService.getString("username");
    final password = SharedPreferencesService.getString("password");
       final userDetails = 
       await login_api().login_user(username: username!, password: password!);
    orderResponse orderDetails =await order_api()
          .order(delivery_boy_id: userDetails.messages.status.userId,order_id: data["order_id"]);


    // print("🟣 API Response Runtime → ${apiResponse.runtimeType}");
    // print("🟣 API Response → $apiResponse");

    // // Convert API response to Map
    // Map<String, dynamic> jsonMap;

    // if (apiResponse is Map<String, dynamic>) {
    //   jsonMap = apiResponse;
    // } else {
    //   debugPrint("❌ API returned an unsupported type");
    //   return;
    // }

    // // Parse into Model
    // final bookingData = OrderListModel.fromJson(jsonMap);

    // final appointment = bookingData.messages?.appointments?.first;
    // if (appointment == null) {
    //   debugPrint("❌ No appointment data found");
    //   return;
    // }

    // SUCCESS → Navigate to details page
    navigatorKey.currentState?.pushAndRemoveUntil(
  MaterialPageRoute(
    builder: (_) => delivery_detailed_screen(orderresponse: orderDetails.data?[0]??Datum(),userDetails: userDetails),
  ),
  (route) => false,   // removes all other screens (Splash, MainScreen, EmptyPage)
);

//     // navigatorKey.currentState?.push(
//     //   MaterialPageRoute(
//     //     builder: (_) => customerDetails(
//     //       orderItem: appointment,
//     //       fromNotification: true,
//     //     ),
//     //   ),
//     // );

    debugPrint("✅ Navigation executed successfully");

  } catch (e, s) {
    debugPrint("❌ Error in handleNotificationTap: $e\n$s");
  }
  }

  /// 🔹 Create and display notification
  static Future<void> createanddisplaynotification(RemoteMessage message) async {
    try {
      final notification = message.notification;
      final android = message.notification?.android;
      final data = message.data;

      if (notification == null) return;

      int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // 🔹 If image exists in notification payload, display it
     StyleInformation? styleInformation;

        if (android?.imageUrl != null || notification.android?.imageUrl != null) {
          final imageUrl = android?.imageUrl ?? notification.android?.imageUrl;
          styleInformation = BigPictureStyleInformation(
            FilePathAndroidBitmap(await _downloadAndSaveFile(imageUrl!, 'notif')),
            contentTitle: notification.title,
            summaryText: notification.body,
          );
        } else {
          styleInformation = BigTextStyleInformation(
            notification.body ?? '',
            contentTitle: notification.title ?? '',
            summaryText: notification.body ?? '',
          );
        }

      final androidDetails = AndroidNotificationDetails(
        'sobhamartdelivery',
        'Push Notifications',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        playSound: true,
        enableVibration: true,
        styleInformation: styleInformation,
        // icon: '@drawable/ic_stat_notification',
        // largeIcon: const DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
        // largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        // actions: [
        //   AndroidNotificationAction('accept', 'Accept'),
        //   AndroidNotificationAction('reject', 'Reject'),
        // ],
      );

      final details = NotificationDetails(android: androidDetails);

      await _notificationsPlugin.show(
        id,
        notification.title,
        notification.body,
        details,
        payload:jsonEncode(data??{}),
      );
    } catch (e) {
      debugPrint('Notification error: $e');
    }
  }

  /// 🔹 Helper: download image to local file for BigPictureStyleInformation
  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final Directory directory = Directory.systemTemp;
    final String filePath = '${directory.path}/$fileName';
    final File file = File(filePath);
    final HttpClient httpClient = HttpClient();

    final HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    final HttpClientResponse response = await request.close();
    final bytes = await consolidateHttpClientResponseBytes(response);
    await file.writeAsBytes(bytes);
    return filePath;
  }
}