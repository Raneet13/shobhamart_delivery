import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sm_delivery/constants.dart/constants.dart';
import 'package:sm_delivery/models/order_delivery_response';

class order_delivery_status_api {
  Future<OrderDeliveryResponse> order_delivery_status({
    required String orderid,
    required String status,
  }) async {
    var uri = Uri.parse('$base_url/API/updateorderstatus');

    Map<String, dynamic> body = {
      'orderid': orderid,
      'status': status,
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
      return OrderDeliveryResponse.fromJson(jsonResponse);
    } else {
      final jsonResponse =
          response.body.isNotEmpty ? json.decode(response.body) : {};
      print('Request failed with status: ${response.statusCode}.');
      return OrderDeliveryResponse.fromJson(jsonResponse);
    }
  }
}
