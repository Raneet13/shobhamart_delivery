import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sm_delivery/models/address_response.dart';

class view_address_api {
  Future<AddressResponse> view_address({
    required String user_id,
  }) async {
    var uri = Uri.parse('http://odishasweets.in/jumbotail/API/view_address');

    Map<String, dynamic> body = {
      'user_id': user_id,
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
      return AddressResponse.fromJson(jsonResponse);
    } else {
      final jsonResponse =
          response.body.isNotEmpty ? json.decode(response.body) : {};
      print('Request failed with status: ${response.statusCode}.');
      return AddressResponse.fromJson(jsonResponse);
    }
  }
}

Stream<AddressResponse> addressDetailsStream(String user_id) async* {
  while (true) {
    yield await view_address_api().view_address(user_id: user_id);
    await Future.delayed(Duration(seconds: 10));
  }
}
