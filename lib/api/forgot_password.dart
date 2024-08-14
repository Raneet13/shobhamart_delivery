import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sm_delivery/constants.dart/constants.dart';
import 'package:sm_delivery/models/forgot_password_response.dart';
import 'package:sm_delivery/models/login_details/user_detail.dart';

class forgot_password_api {
  Future<forgotPasswordResponse> forgot_password({
    required String contact_no,
  }) async {
    var uri = Uri.parse('$base_url/API/forgot_password');

    Map<String, dynamic> body = {
      'contact_no': contact_no,
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
      return forgotPasswordResponse.fromJson(jsonResponse);
    } else {
      final jsonResponse =
          response.body.isNotEmpty ? json.decode(response.body) : {};
      print('Request failed with status: ${response.statusCode}.');
      return forgotPasswordResponse.fromJson(jsonResponse);
    }
  }
}
