import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sm_delivery/models/login_details/user_detail.dart';

class login_api {
  Future<userResponse> login_user({
    required String username,
    required String password,
  }) async {
    var uri =
        Uri.parse('http://odishasweets.in/jumbotail/API/deliveryboy_login');

    Map<String, dynamic> body = {
      'username': username,
      'password': password,
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
