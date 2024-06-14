import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sm_delivery/models/order_details_response.dart';

class order_detailed_api {
  Future<orderDetailedResponse> order_detailed({
    required String order_id,
  }) async {
    var uri = Uri.parse('http://odishasweets.in/jumbotail/API/getSingleOrder');

    Map<String, dynamic> body = {
      'order_id': order_id,
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
      return orderDetailedResponse.fromJson(jsonResponse);
    } else {
      final jsonResponse =
          response.body.isNotEmpty ? json.decode(response.body) : {};
      print('Request failed with status: ${response.statusCode}.');
      return orderDetailedResponse.fromJson(jsonResponse);
    }
  }
}
