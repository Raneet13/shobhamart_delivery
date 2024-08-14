// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart/constants.dart';
import '../models/customer_detailed_response.dart';

class verify_api {
  Future<user_details> verify_user({
    required String phone,
  }) async {
    var uri = Uri.parse('$base_url/API/VerifyOTP');
    Map<String, dynamic> body = {
      'contact': phone,
    };
    if (phone.length == 10) {
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
        print('User registration successful: $jsonResponse');
        return user_details.fromJson(jsonResponse);
      } else {
        final jsonResponse =
            response.body.isNotEmpty ? json.decode(response.body) : {};
        print('Request failed with status: ${response.statusCode}.');
        return user_details.fromJson(jsonResponse);
      }
    } else
      return user_details(
        status: 0,
        error: false,
        messages: Messages(
          responsecode: '',
          status: UserStatus(
            userId: '',
            fullname: null,
            email: null,
            contact: '',
            status: null,
            lat: null,
            lng: null,
            storeImage: null,
            storeName: null,
            isLoggedIn: false,
          ),
        ),
      );
  }
}

Stream<user_details> userDetailsStream(String phone) async* {
  while (true) {
    yield await verify_api().verify_user(phone: phone);
    await Future.delayed(Duration(seconds: 10));
  }
}
