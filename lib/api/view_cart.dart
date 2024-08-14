import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sm_delivery/constants.dart/constants.dart';

import '../models/view_cart_response.dart';

class view_cart_api {
  Future<viewCartResponse> view_cart({
    required String user_id,
  }) async {
    var uri = Uri.parse('$base_url/API/View_cart');

    Map<String, dynamic> body = {
      'user_id': user_id,
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
      print('view cart successful: $jsonResponse');
      return viewCartResponse.fromJson(jsonResponse);
    } else {
      final jsonResponse =
          response.body.isNotEmpty ? json.decode(response.body) : {};
      print('Request failed with status: ${response.statusCode}.');
      return viewCartResponse.fromJson(jsonResponse);
    }
  }
}
