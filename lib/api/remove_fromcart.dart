import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart/constants.dart';

class remove_fromcart_api {
  Future<removeFromCartResponse> remove_fromcart({
    required String cart_id,
  }) async {
    var uri = Uri.parse('$base_url/API/Remove_cart');

    Map<String, dynamic> body = {
      'cart_id': cart_id,
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
      print('Item Removed successful: $jsonResponse');
      return removeFromCartResponse.fromJson(jsonResponse);
    } else {
      final jsonResponse =
          response.body.isNotEmpty ? json.decode(response.body) : {};
      print('Request failed with status: ${response.statusCode}.');
      return removeFromCartResponse.fromJson(jsonResponse);
    }
  }
}

class removeFromCartResponse {
  int status;
  bool error;
  removeFromCartResponseMessage messages;

  removeFromCartResponse({
    required this.status,
    required this.error,
    required this.messages,
  });

  factory removeFromCartResponse.fromJson(Map<String, dynamic> json) {
    return removeFromCartResponse(
      status: json['status'] ?? 0,
      error: json['error'] ?? false,
      messages: removeFromCartResponseMessage.fromJson(json['messages'] ?? {}),
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

class removeFromCartResponseMessage {
  String responseCode;
  String status;

  removeFromCartResponseMessage({
    required this.responseCode,
    required this.status,
  });

  factory removeFromCartResponseMessage.fromJson(Map<String, dynamic> json) {
    return removeFromCartResponseMessage(
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
