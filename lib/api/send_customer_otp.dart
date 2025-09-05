import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sm_delivery/constants.dart/constants.dart';
import 'package:sm_delivery/models/order_details_response.dart';

class send_custtomer_otp_api {
  Future<dynamic> otp_send({
    required String otp,
    required String user_contact,
  }) async {
    var uri = Uri.parse('$base_url/API/send_customer_otp');

    Map<String, dynamic> body = {
      'contact_no': user_contact,
      'otp': otp,
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
      print('delivery: $jsonResponse');
      return jsonResponse;
      // return orderDetailedResponse.fromJson(jsonResponse);
    } else {
      final jsonResponse =
          response.body.isNotEmpty ? json.decode(response.body) : {};
      print('Request failed with status: ${response.statusCode}.');
      return jsonResponse;
    }
  }
}
