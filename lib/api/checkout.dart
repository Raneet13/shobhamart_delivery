import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sm_delivery/models/order_delivery_response';
import 'package:sm_delivery/models/order_details_response.dart';
import '../constants.dart/constants.dart';

class checkout_api {
  Future<OrderDeliveryResponse> checkout({
    required String user_id,
    required String vendor_id,
    required String coupon_code,
    required num cupon_price,
    required String order_id,
    required String paymentmode,
    required num paid_amount,
    required String transaction_id,
    required List<String> product_name,
    required List<int> qty,
    required List<String> product_image,
    required List<num> sale_price,
    required List<int> variation_id,
    required String paid_intrest,
  }) async {
    var uri = Uri.parse('$base_url/API/deliveryboycheckout');

    Map<String, dynamic> body = {
      'user_id': user_id,
      'deliveryboy_id': vendor_id,
      'cupon_code': coupon_code,
      'cupon_price': cupon_price,
      'order_id': order_id,
      'paymentmode': paymentmode,
      'paid_amount': paid_amount,
      'transaction_id': transaction_id,
      'product_name': product_name,
      'qty': qty,
      'product_image': product_image,
      'sale_price': sale_price,
      'variation_id': variation_id,
      'paid_intrest': paid_intrest
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
      return OrderDeliveryResponse.fromJson(jsonResponse);
    } else {
      final jsonResponse =
          response.body.isNotEmpty ? json.decode(response.body) : {};
      print('Request failed with status: ${jsonResponse}.');
      return OrderDeliveryResponse.fromJson(jsonResponse);
    }
  }
}
