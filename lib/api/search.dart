import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart/constants.dart';
import '../models/search_response.dart';

class search_api {
  Future<searchProductResponse> search({
    required String query,
  }) async {
    var uri = Uri.parse('$base_url/API/search');

    Map<String, dynamic> body = {
      'product_name': query,
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
      return searchProductResponse.fromJson(jsonResponse);
    } else {
      final jsonResponse =
          response.body.isNotEmpty ? json.decode(response.body) : {};
      print('Request failed with status: ${response.statusCode}.');
      return searchProductResponse.fromJson(jsonResponse);
    }
  }
}
