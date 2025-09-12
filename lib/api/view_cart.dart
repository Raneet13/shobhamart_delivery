import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:sm_delivery/api/checkout.dart';
import 'package:sm_delivery/constants.dart/constants.dart';

import '../models/single_product_response.dart';
import '../models/view_cart_response.dart';

class view_cart_api {
  Future<viewCartResponse> view_cart({
    required String user_id,
  }) async {
    var uri = Uri.parse('$base_url/API/View_cart');

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
      print('view cart successful: $jsonResponse');
      return viewCartResponse.fromJson(jsonResponse);
    } else {
      final jsonResponse =
          response.body.isNotEmpty ? json.decode(response.body) : {};
      print('Request failed with status: ${response.statusCode}.');
      return viewCartResponse.fromJson(jsonResponse);
    }
  }
Future<bool> checkout_api({
  required String orderId,
  required List<UserProductResponse> product,
}) async {
  try {
    Dio dio = Dio();
    String url = 'https://sobhamart.com/API/updateOrderData';

    FormData formData = FormData();

    // Always required field
    formData.fields.add(MapEntry('order_id', orderId));

    if (product.isNotEmpty) {
      for (int i = 0; i < product.length; i++) {
        formData.fields.add(MapEntry('product_id[$i]', product[i].productId ?? ""));
        formData.fields.add(MapEntry('variation_id[$i]', product[i].variation ?? ""));
        formData.fields.add(MapEntry('qty[$i]', "${product[i].qty}"));
        formData.fields.add(MapEntry('price[$i]', product[i].price ?? ""));
        formData.fields.add(MapEntry('productname[$i]', product[i].productName ?? ""));
        formData.fields.add(MapEntry('user_id[$i]', product[i].userId ?? ""));
        formData.fields.add(MapEntry('address_id[$i]', product[i].addressId ?? ""));
        formData.fields.add(MapEntry('payment_mode[$i]', product[i].paymentMode ?? ""));
        formData.fields.add(MapEntry('deliveryboy_id[$i]', product[i].deliveryboyId ?? ""));
        formData.fields.add(MapEntry('otp[$i]', product[i].otp ?? ""));

        // img field (unindexed)otp
        if (product[i].img != null && product[i].img!.isNotEmpty) {
          formData.fields.add(MapEntry('img[$i]', product[i].img!));
        }
        if (product[i].couponCode != null && product[i].couponCode!.isNotEmpty) {
        formData.fields.add(MapEntry('coupon_code[$i]', product[i].couponCode!));
      }
      }

      // coupon_code (unindexed, only once)
      
    }

    // Debug: print all fields
    formData.fields.forEach((e) => print('${e.key} => ${e.value}'));

    Response response = await dio.post(
      url,
      data: formData,
      options: Options(
        headers: {
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    print('Status: ${response.statusCode}');
    print('Response: ${response.data}');

    return response.statusCode == 200;
  } on DioException catch (e) {
  // The request was made and the server responded with a status code
  // that falls out of the range of 2xx and is also not 304.
  if (e.response != null) {
    print(e.response?.data);
  } else {
    // Something happened in setting up or sending the request that triggered an Error
    print(e.requestOptions);
    print(e.message);
  }
  return false;
  } on SocketException {
      print("No Internet");
      return false;
      // throw FetchDataException("No internet");
    }catch (e) {
    print('Error: $e');
    return false;
  }
}}
