import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/single_product_response.dart';

class SharedPreferencesService {
  static SharedPreferences? _prefs;

  static Future initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<void> storeUserProductResponses(
      List<UserProductResponse> responses) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString =
        jsonEncode(responses.map((response) => response.toJson()).toList());
    await prefs.setString('user_product_responses', jsonString);
    print('Saved JSON string: $jsonString');
  }

  Future<List<UserProductResponse>> getUserProductResponses(
      String userId, String orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('user_product_responses');

    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      List<UserProductResponse> responses = jsonList
          .map((json) => UserProductResponse.fromJson(json))
          .where((response) =>
              response.userId == userId && response.orderId == orderId)
          .toList();
      print('Loaded UserProductResponses: $responses');
      return responses;
    } else {
      return [];
    }
  }

  Future<void> onAddToCart(
      UserProductResponse newResponse, String userId) async {
    // Fetch the current list of UserProductResponse from SharedPreferences
    List<UserProductResponse> responses =
        await getUserProductResponses(userId, newResponse.orderId);

    // Find the index of the existing product with the same productName, orderId, and userId
    int existingProductIndex = responses.indexWhere((response) =>
        response.productName == newResponse.productName &&
        response.orderId == newResponse.orderId &&
        response.userId == newResponse.userId);

    if (existingProductIndex != -1) {
      // If the product exists, calculate the new quantity
      final existingProduct = responses[existingProductIndex];
      final updatedProduct = UserProductResponse(
        productName: existingProduct.productName,
        userId: existingProduct.userId,
        orderId: existingProduct.orderId,
        qty: existingProduct.qty + newResponse.qty, // Sum the quantities
        img: existingProduct.img,
        price: existingProduct.price,
        variation: existingProduct.variation,
      );

      // Remove the old product and insert the updated one
      responses.removeAt(existingProductIndex);
      responses.insert(existingProductIndex, updatedProduct);
    } else {
      // If the product doesn't exist, add it to the list
      responses.add(newResponse);
    }

    // Save the updated list back to SharedPreferences
    await storeUserProductResponses(responses);
  }

  Future<void> removeItemsByOrderId(String orderId, String UserId) async {
    List<UserProductResponse> responses =
        await getUserProductResponses(UserId, orderId);
    responses =
        responses.where((response) => response.orderId != orderId).toList();
    await storeUserProductResponses(responses);
  }

  Future<void> removeSingleItemsByOrderId(
      String orderId, String UserId, String productname) async {
    List<UserProductResponse> responses =
        await getUserProductResponses(UserId, orderId);
    responses = responses
        .where((response) => (response.orderId == orderId &&
            response.productName != productname))
        .toList();
    await storeUserProductResponses(responses);
  }

  Future<void> updateQuantity(String productName, int newQuantity,
      String userId, String OrderId) async {
    List<UserProductResponse> responses =
        await getUserProductResponses(userId, OrderId);

    for (var response in responses) {
      if (response.productName == productName) {
        response.qty = newQuantity;
        break;
      }
    }

    await storeUserProductResponses(responses);
  }

  Future<void> incrementQuantity(
      String productName, String userId, String OrderId) async {
    List<UserProductResponse> responses =
        await getUserProductResponses(userId, OrderId);

    for (var response in responses) {
      if (response.productName == productName) {
        print('Incrementing quantity for $productName');
        response.qty += 1;
        break;
      }
    }

    await storeUserProductResponses(responses);
  }

  Future<void> decrementQuantity(
      String productName, String userId, String OrderId) async {
    List<UserProductResponse> responses =
        await getUserProductResponses(userId, OrderId);

    for (var response in responses) {
      if (response.productName == productName) {
        response.qty -= 1;
        if (response.qty < 1) {
          response.qty = 1;
        }
        break;
      }
    }

    await storeUserProductResponses(responses);
  }

  void onCheckout(String orderId, String UserId) async {
    await removeItemsByOrderId(orderId, UserId);
  }
}
