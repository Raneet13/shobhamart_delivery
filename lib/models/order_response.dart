import 'dart:convert';

class orderResponse {
    int? status;
    bool? error;
    String? message;
    List<Datum>? data;

    orderResponse({
        this.status,
        this.error,
        this.message,
        this.data,
    });

    factory orderResponse.fromRawJson(String str) => orderResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory orderResponse.fromJson(Map<String, dynamic> json) => orderResponse(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    String? orderId;
    String? allTotal;
    String? shippingCharge;
    String? productsTotal;
    String? paymentMode;
    String? orderStatus;
    List<Order>? products;

    Datum({
        this.orderId,
        this.allTotal,
        this.shippingCharge,
        this.productsTotal,
        this.paymentMode,
        this.orderStatus,
        this.products,
    });

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        orderId: json["order_id"],
        allTotal: json["all_total"],
        shippingCharge: json["shipping_charge"],
        productsTotal: json["products_total"],
        paymentMode: json["payment_mode"],
        orderStatus: json["order_status"],
        products: json["products"] == null ? [] : List<Order>.from(json["products"]!.map((x) => Order.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "all_total": allTotal,
        "shipping_charge": shippingCharge,
        "products_total": productsTotal,
        "payment_mode": paymentMode,
        "order_status": orderStatus,
        "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
    };
}

class Order {
    String? ordersId;
    String? productname;
    String? variationId;
    String? qty;
    String? img;
    String? price;
    String? userId;
    dynamic shippingType;
    String? addressId;
    String? paymentMode;
    String? deliveryboyId;
    String? status;
    dynamic reason;
    String? wallet;
    dynamic txnId;
    String? couponCode;
    String? couponAmnt;
    String? createdDate;
    String? updateDate;
    String? deliveryBoyName;
    String? customerName;
    String? customerContactno;
    String? cityId;
    String? stateId;
    String? deliveryAddress;
    String? cityName;
    String? stateName;
    String? pincode;

    Order({
        this.ordersId,
        this.productname,
        this.variationId,
        this.qty,
        this.img,
        this.price,
        this.userId,
        this.shippingType,
        this.addressId,
        this.paymentMode,
        this.deliveryboyId,
        this.status,
        this.reason,
        this.wallet,
        this.txnId,
        this.couponCode,
        this.couponAmnt,
        this.createdDate,
        this.updateDate,
        this.deliveryBoyName,
        this.customerName,
        this.customerContactno,
        this.cityId,
        this.stateId,
        this.deliveryAddress,
        this.cityName,
        this.stateName,
        this.pincode,
    });

    factory Order.fromRawJson(String str) => Order.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        ordersId: json["orders_id"],
        productname: json["productname"],
        variationId: json["variation_id"],
        qty: json["qty"],
        img: json["img"],
        price: json["price"],
        userId: json["user_id"],
        shippingType: json["shipping_type"],
        addressId: json["address_id"],
        paymentMode: json["payment_mode"],
        deliveryboyId: json["deliveryboy_id"],
        status: json["status"],
        reason: json["reason"],
        wallet: json["wallet"],
        txnId: json["txn_id"],
        couponCode: json["coupon_code"],
        couponAmnt: json["coupon_amnt"],
        createdDate: json["created_date"],
        updateDate: json["update_date"],
        deliveryBoyName: json["delivery_boy_name"],
        customerName: json["customer_name"],
        customerContactno: json["customer_contactno"],
        cityId: json["city_id"],
        stateId: json["state_id"],
        deliveryAddress: json["delivery_address"],
        cityName: json["city_name"],
        stateName: json["state_name"],
        pincode: json["pincode"],
    );

    Map<String, dynamic> toJson() => {
        "orders_id": ordersId,
        "productname": productname,
        "variation_id": variationId,
        "qty": qty,
        "img": img,
        "price": price,
        "user_id": userId,
        "shipping_type": shippingType,
        "address_id": addressId,
        "payment_mode": paymentMode,
        "deliveryboy_id": deliveryboyId,
        "status": status,
        "reason": reason,
        "wallet": wallet,
        "txn_id": txnId,
        "coupon_code": couponCode,
        "coupon_amnt": couponAmnt,
        "created_date": createdDate,
        "update_date": updateDate,
        "delivery_boy_name": deliveryBoyName,
        "customer_name": customerName,
        "customer_contactno": customerContactno,
        "city_id": cityId,
        "state_id": stateId,
        "delivery_address": deliveryAddress,
        "city_name": cityName,
        "state_name": stateName,
        "pincode": pincode,
    };
}
