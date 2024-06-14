import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sm_delivery/models/order_response.dart';

class order_api {
  Future<orderResponse> order({
    required String delivery_boy_id,
  }) async {
    var uri = Uri.parse(
        'http://odishasweets.in/jumbotail/API/delivery_boy_allorders');

    Map<String, dynamic> body = {
      'delivery_boy_id': delivery_boy_id,
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
      return orderResponse.fromJson(jsonResponse);
    } else {
      final jsonResponse =
          response.body.isNotEmpty ? json.decode(response.body) : {};
      print('Request failed with status: ${response.statusCode}.');
      return orderResponse.fromJson(jsonResponse);
    }
  }
}
