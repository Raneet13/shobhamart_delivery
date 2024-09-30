class orderDetailedResponse {
  final bool error;
  final String message;
  final List<orderDetails> data;
  final List<TransactionDetails> transactionDetails;
  final num creaditLimit;
  final num dueAmount;
  final num interestAmount;

  orderDetailedResponse(
      {required this.error,
      required this.message,
      required this.data,
      required this.transactionDetails,
      required this.creaditLimit,
      required this.interestAmount,
      required this.dueAmount});

  factory orderDetailedResponse.fromJson(Map<String, dynamic> json) {
    return orderDetailedResponse(
        error: json['error'] ?? false,
        message: json['message'] ?? '',
        data: (json['data']['order_details'] as List)
            .map((i) => orderDetails.fromJson(i))
            .toList(),
        transactionDetails: (json['data']['tranction_details'] as List)
            .map((i) => TransactionDetails.fromJson(i))
            .toList(),
        creaditLimit: json['data']['creaditLimit'] ?? 0,
        dueAmount: json['data']['dueAmount'] ?? 0,
        interestAmount: json['data']['intrestAmount'] ?? 0);
  }
}

class orderDetails {
  final String ordersId;
  final String productName;
  final String variationId;
  final String qty;
  final String img;
  final String price;
  final String userId;
  final String? shippingType;
  final String? shippingCharge;
  final String orderId;
  final String? addressId;
  final String paymentMode;
  final String deliveryBoyId;
  final String status;
  final String? reason;
  final String wallet;
  final String? txnId;
  final String couponCode;
  final String couponAmount;
  final String createdDate;
  final String updateDate;

  orderDetails({
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
    this.addressId,
    required this.paymentMode,
    required this.deliveryBoyId,
    required this.status,
    this.reason,
    required this.wallet,
    this.txnId,
    required this.couponCode,
    required this.couponAmount,
    required this.createdDate,
    required this.updateDate,
  });

  factory orderDetails.fromJson(Map<String, dynamic> json) {
    return orderDetails(
      ordersId: json['orders_id'] ?? '',
      productName: json['productname'] ?? '',
      variationId: json['variation_id'] ?? '',
      qty: json['qty'] ?? '',
      img: json['img'] ?? '',
      price: json['price'] ?? '',
      userId: json['user_id'] ?? '',
      shippingType: json['shipping_type'] ?? '',
      shippingCharge: json['shipping_charge'] ?? '0',
      orderId: json['order_id'] ?? '',
      addressId: json['address_id'] ?? '',
      paymentMode: json['payment_mode'] ?? '',
      deliveryBoyId: json['deliveryboy_id'] ?? '',
      status: json['status'] ?? '',
      reason: json['reason'] ?? '',
      wallet: json['wallet'] ?? '',
      txnId: json['txn_id'] ?? '',
      couponCode: json['coupon_code'] ?? '',
      couponAmount: json['coupon_amnt'] ?? '',
      createdDate: json['created_date'] ?? '',
      updateDate: json['update_date'] ?? '',
    );
  }
}

class TransactionDetails {
  final String trId;
  final String custId;
  final String orderId;
  final String tAmount;
  final String paidAmount;
  final String paymentType;
  final String paymentMode;
  final String? transactionId;
  final String date;
  final String createdDate;

  TransactionDetails({
    required this.trId,
    required this.custId,
    required this.orderId,
    required this.tAmount,
    required this.paidAmount,
    required this.paymentType,
    required this.paymentMode,
    this.transactionId,
    required this.date,
    required this.createdDate,
  });

  factory TransactionDetails.fromJson(Map<String, dynamic> json) {
    return TransactionDetails(
      trId: json['tr_id'] ?? '',
      custId: json['cust_id'] ?? '',
      orderId: json['order_id'] ?? '',
      tAmount: json['t_amount'] ?? '',
      paidAmount: json['paid_amount'] ?? '',
      paymentType: json['payment_type'] ?? '',
      paymentMode: json['payment_mode'] ?? '',
      transactionId: json['tranction_id'] ?? '',
      date: json['date'] ?? '',
      createdDate: json['created_date'] ?? '',
    );
  }
}
