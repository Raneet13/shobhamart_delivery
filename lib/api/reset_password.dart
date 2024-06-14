import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sm_delivery/models/reset_password_response.dart';

class reset_password_api {
  Future<resetPasswordResponse> reset_password({
    required String contact_no,
    required String password,
  }) async {
    var uri = Uri.parse('http://odishasweets.in/jumbotail/API/reset_password');

    Map<String, dynamic> body = {
      'contact_no': contact_no,
      'new_password': password,
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
      return resetPasswordResponse.fromJson(jsonResponse);
    } else {
      final jsonResponse =
          response.body.isNotEmpty ? json.decode(response.body) : {};
      print('Request failed with status: ${response.statusCode}.');
      return resetPasswordResponse.fromJson(jsonResponse);
    }
  }
}
