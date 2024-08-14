import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart/constants.dart';

class add_tocart_api {
  Future<addToCartResponse> add_tocart({
    required String user_id,
    required String product_id,
    required String quantity,
    required String variation_id,
  }) async {
    var uri = Uri.parse('$base_url/API/addto_to_cart');

    Map<String, dynamic> body = {
      'user_id': user_id,
      'product_id': product_id,
      'qty': quantity,
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
      print('catagory registration successful: $jsonResponse');
      return addToCartResponse.fromJson(jsonResponse);
    } else {
      final jsonResponse =
          response.body.isNotEmpty ? json.decode(response.body) : {};
      print('Request failed with status: ${response.statusCode}.');
      return addToCartResponse.fromJson(jsonResponse);
    }
  }
}

class addToCartResponse {
  int status;
  bool error;
  addToCartResponseMessage messages;

  addToCartResponse({
    required this.status,
    required this.error,
    required this.messages,
  });

  factory addToCartResponse.fromJson(Map<String, dynamic> json) {
    return addToCartResponse(
      status: json['status'] ?? 0,
      error: json['error'] ?? false,
      messages: addToCartResponseMessage.fromJson(json['messages'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'error': error,
      'messages': messages.toJson(),
    };
  }
}

class addToCartResponseMessage {
  String responseCode;
  String status;

  addToCartResponseMessage({
    required this.responseCode,
    required this.status,
  });

  factory addToCartResponseMessage.fromJson(Map<String, dynamic> json) {
    return addToCartResponseMessage(
      responseCode: json['responsecode'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'responsecode': responseCode,
      'status': status,
    };
  }
}
