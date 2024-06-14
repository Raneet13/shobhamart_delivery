import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sm_delivery/models/order_details_response.dart';
import 'package:sm_delivery/models/update_qty_response.dart';

class update_quantity_api {
  Future<OrderQuantityUpdateResponse> update_quantity({
    required String orders_id,
    required String qty,
  }) async {
    var uri = Uri.parse('http://odishasweets.in/jumbotail/API/update_order');

    Map<String, dynamic> body = {
      'orders_id': orders_id,
      'qty': qty,
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
      return OrderQuantityUpdateResponse.fromJson(jsonResponse);
    } else {
      final jsonResponse =
          response.body.isNotEmpty ? json.decode(response.body) : {};
      print('Request failed with status: ${response.statusCode}.');
      return OrderQuantityUpdateResponse.fromJson(jsonResponse);
    }
  }
}
