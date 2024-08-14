class variationResponse {
  int status;
  bool error;
  variationMessages messages;

  variationResponse({
    required this.status,
    required this.error,
    required this.messages,
  });

  factory variationResponse.fromJson(Map<String, dynamic> json) {
    return variationResponse(
      status: json['status'] ?? 0,
      error: json['error'] ?? false,
      messages: variationMessages.fromJson(json['messages'] ?? {}),
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

class variationMessages {
  String responsecode;
  variationStatus status;

  variationMessages({
    required this.responsecode,
    required this.status,
  });

  factory variationMessages.fromJson(Map<String, dynamic> json) {
    return variationMessages(
      responsecode: json['responsecode'] ?? '',
      status: variationStatus.fromJson(json['status'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'responsecode': responsecode,
      'status': status.toJson(),
    };
  }
}

class variationStatus {
  List<VariationDetails> variationDetails;

  variationStatus({
    required this.variationDetails,
  });

  factory variationStatus.fromJson(Map<String, dynamic> json) {
    var list = json['variation_details'] as List? ?? [];
    List<VariationDetails> variationDetailsList =
        list.map((i) => VariationDetails.fromJson(i)).toList();

    return variationStatus(
      variationDetails: variationDetailsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variation_details': variationDetails.map((v) => v.toJson()).toList(),
    };
  }
}

class VariationDetails {
  String priceVariationId;
  String variationValue;
  String regularPrice;
  String salePrice;
  String productId;
  String stock;
  String vendorId;
  String image;

  VariationDetails({
    required this.priceVariationId,
    required this.variationValue,
    required this.regularPrice,
    required this.salePrice,
    required this.productId,
    required this.stock,
    required this.vendorId,
    required this.image,
  });

  factory VariationDetails.fromJson(Map<String, dynamic> json) {
    return VariationDetails(
      priceVariationId: json['price_varition_id'] ?? '',
      variationValue: json['variation_value'] ?? '',
      regularPrice: json['regular_price'] ?? '',
      salePrice: json['sale_price'] ?? '',
      productId: json['product_id'] ?? '',
      stock: json['stock'] ?? '',
      vendorId: json['vendor_id'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price_varition_id': priceVariationId,
      'variation_value': variationValue,
      'regular_price': regularPrice,
      'sale_price': salePrice,
      'product_id': productId,
      'stock': stock,
      'vendor_id': vendorId,
      'image': image,
    };
  }
}
