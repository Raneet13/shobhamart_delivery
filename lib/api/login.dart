import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sm_delivery/constants.dart/constants.dart';
import 'package:sm_delivery/models/login_details/user_detail.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class login_api {
   Future<String?> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    return token;
    // deviceTokenToSendPushNotification = token.toString();
    // print("Token Value ${token.toString()}");
  }
  Future<userResponse> login_user({
    required String username,
    required String password,
  }) async {
    var token = await getDeviceTokenToSendNotification();
    var uri = Uri.parse('$base_url/API/deliveryboy_login');
    Map<String, dynamic> body = {
      'username': username,
      'password': password,
      'device_token':token
    };

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return userResponse.fromJson(jsonResponse);
    } else {
      final jsonResponse =
          response.body.isNotEmpty ? json.decode(response.body) : {};
      print('Request failed with status: ${response.statusCode}.');
      return userResponse.fromJson(jsonResponse);
    }
  }
}

Stream<userResponse> userDetailsStream(
    String username, String password) async* {
  while (true) {
    yield await login_api().login_user(username: username, password: password);
    await Future.delayed(Duration(seconds: 10));
  }
}
