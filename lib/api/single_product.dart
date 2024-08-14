import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart/constants.dart';
import '../models/single_product_response.dart';

class single_product_api {
  Future<SingleProductResponse> single_product_details({
    required String user_id,
    required String product_id,
  }) async {
    var uri = Uri.parse('$base_url/API/SingleProduct');

    Map<String, dynamic> body = {
      'user_id': user_id,
      'product_id': product_id,
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
      print('catagory registration successful: $jsonResponse');
      return SingleProductResponse.fromJson(jsonResponse);
    } else {
      final jsonResponse =
          response.body.isNotEmpty ? json.decode(response.body) : {};
      print('Request failed with status: ${response.statusCode}.');
      return SingleProductResponse.fromJson(jsonResponse);
    }
  }

  singleProductDetails({required String userId, required String productId}) {}
}
