class Order {
  String ordersId;
  String productName;
  String variationId;
  String qty;
  String img;
  String price;
  String userId;
  String? shippingType;
  String? shippingCharge;
  String orderId;
  String addressId;
  String paymentMode;
  String deliveryBoyId;
  String status;
  String? reason;
  String wallet;
  String? txnId;
  String couponCode;
  String couponAmnt;
  String createdDate;
  String updateDate;

  Order({
    required this.ordersId,
    required this.productName,
    required this.variationId,
    required this.qty,
    required this.img,
    required this.price,
    required this.userId,
    this.shippingType,
    this.shippingCharge,
    required this.orderId,
    required this.addressId,
    required this.paymentMode,
    required this.deliveryBoyId,
    required this.status,
    this.reason,
    required this.wallet,
    this.txnId,
    required this.couponCode,
    required this.couponAmnt,
    required this.createdDate,
    required this.updateDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      ordersId: json['orders_id'] ?? '',
      productName: json['productname'] ?? '',
      variationId: json['variation_id'] ?? '',
      qty: json['qty'] ?? '',
      img: json['img'] ?? '',
      price: json['price'] ?? '',
      userId: json['user_id'] ?? '',
      shippingType: json['shipping_type'] ?? '',
      shippingCharge: json['shipping_charge'] ?? '',
      orderId: json['order_id'] ?? '',
      addressId: json['address_id'] ?? '',
      paymentMode: json['payment_mode'] ?? '',
      deliveryBoyId: json['deliveryboy_id'] ?? '',
      status: json['status'] ?? '',
      reason: json['reason'] ?? '',
      wallet: json['wallet'] ?? '',
      txnId: json['txn_id'] ?? '',
      couponCode: json['coupon_code'] ?? '',
      couponAmnt: json['coupon_amnt'] ?? '',
      createdDate: json['created_date'] ?? '',
      updateDate: json['update_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders_id': ordersId,
      'productname': productName,
      'variation_id': variationId,
      'qty': qty,
      'img': img,
      'price': price,
      'user_id': userId,
      'shipping_type': shippingType ?? '',
      'shipping_charge': shippingCharge ?? '',
      'order_id': orderId,
      'address_id': addressId,
      'payment_mode': paymentMode,
      'deliveryboy_id': deliveryBoyId,
      'status': status,
      'reason': reason ?? '',
      'wallet': wallet,
      'txn_id': txnId ?? '',
      'coupon_code': couponCode,
      'coupon_amnt': couponAmnt,
      'created_date': createdDate,
      'update_date': updateDate,
    };
  }
}

class orderResponse {
  int status;
  bool error;
  String message;
  List<Order> data;

  orderResponse({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory orderResponse.fromJson(Map<String, dynamic> json) {
    return orderResponse(
      status: json['status'] ?? 0,
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List).map((i) => Order.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'error': error,
      'message': message,
      'data': data.map((order) => order.toJson()).toList(),
    };
  }
}
