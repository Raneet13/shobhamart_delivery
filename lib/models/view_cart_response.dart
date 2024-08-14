class viewCartResponse {
  int status;
  bool error;
  viewCartMessage messages;

  viewCartResponse({
    required this.status,
    required this.error,
    required this.messages,
  });

  factory viewCartResponse.fromJson(Map<String, dynamic> json) {
    return viewCartResponse(
      status: json['status'] ?? 0,
      error: json['error'] ?? false,
      messages: viewCartMessage.fromJson(json['messages'] ?? {}),
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

class viewCartMessage {
  String responseCode;
  viewCartStatus status;

  viewCartMessage({
    required this.responseCode,
    required this.status,
  });

  factory viewCartMessage.fromJson(Map<String, dynamic> json) {
    return viewCartMessage(
      responseCode: json['responsecode'] ?? '',
      status: viewCartStatus.fromJson(json['status'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'responsecode': responseCode,
      'status': status.toJson(),
    };
  }
}

class viewCartStatus {
  List<viewCartProductData> productData;

  viewCartStatus({
    required this.productData,
  });

  factory viewCartStatus.fromJson(Map<String, dynamic> json) {
    return viewCartStatus(
      productData: (json['cart_items'] as List<dynamic>?)
              ?.map((data) => viewCartProductData.fromJson(data))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_items': productData.map((data) => data.toJson()).toList(),
    };
  }
}

class viewCartProductData {
  String cartId;
  String? shopId;
  String userId;
  String productId;
  String qty;
  String variationId;
  String? couponCode;
  String createdDate;
  String productName;
  String productType;
  String description;
  String brandsId;
  String primaryImage;
  String regularPrice;
  String salesPrice;
  String? category;
  String status;
  String prodType;
  String createdBy;
  String approve;
  String updatedDate;
  String varsalePrice;

  viewCartProductData({
    required this.cartId,
    this.shopId,
    required this.userId,
    required this.productId,
    required this.qty,
    required this.variationId,
    this.couponCode,
    required this.createdDate,
    required this.productName,
    required this.productType,
    required this.description,
    required this.brandsId,
    required this.primaryImage,
    required this.regularPrice,
    required this.salesPrice,
    this.category,
    required this.status,
    required this.prodType,
    required this.createdBy,
    required this.approve,
    required this.updatedDate,
    required this.varsalePrice,
  });

  factory viewCartProductData.fromJson(Map<String, dynamic> json) {
    return viewCartProductData(
      cartId: json['cart_id'] ?? '',
      shopId: json['shop_id'],
      userId: json['user_id'] ?? '',
      productId: json['product_id'] ?? '',
      qty: json['qty'] ?? '',
      variationId: json['variation_id'] ?? '',
      couponCode: json['coupon_code'],
      createdDate: json['created_date'] ?? '',
      productName: json['product_name'] ?? '',
      productType: json['product_type'] ?? '',
      description: json['description'] ?? '',
      brandsId: json['brands_id'] ?? '',
      primaryImage: json['primary_image'] ?? '',
      regularPrice: json['regular_price'] ?? '',
      salesPrice: json['sales_price'] ?? '',
      category: json['category'],
      status: json['status'] ?? '',
      prodType: json['prodType'] ?? '',
      createdBy: json['createdby'] ?? '',
      approve: json['approve'] ?? '',
      updatedDate: json['updated_date'] ?? '',
      varsalePrice: json['varsale_price'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'shop_id': shopId,
      'user_id': userId,
      'product_id': productId,
      'qty': qty,
      'variation_id': variationId,
      'coupon_code': couponCode,
      'created_date': createdDate,
      'product_name': productName,
      'product_type': productType,
      'description': description,
      'brands_id': brandsId,
      'primary_image': primaryImage,
      'regular_price': regularPrice,
      'sales_price': salesPrice,
      'category': category,
      'status': status,
      'prodType': prodType,
      'createdby': createdBy,
      'approve': approve,
      'updated_date': updatedDate,
      'varsale_price': varsalePrice,
    };
  }
}
