import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart/constants.dart';
import '../models/variation.dart';

class variation_api {
  Future<variationResponse> variation_details({
    required String user_id,
    required String variation_id,
  }) async {
    var uri = Uri.parse('$base_url/API/variation_dtls');

    Map<String, dynamic> body = {
      'user_id': user_id,
      'variation_id': variation_id,
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

      return variationResponse.fromJson(jsonResponse);
    } else {
      final jsonResponse =
          response.body.isNotEmpty ? json.decode(response.body) : {};
      print('Request failed with status: ${response.statusCode}.');
      return variationResponse.fromJson(jsonResponse);
    }
  }
}
