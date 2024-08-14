import 'dart:convert';

class searchProductData {
  final String productId;
  final String productName;
  final String productType;
  final String description;
  final String brandsId;
  final String primaryImage;
  final String regularPrice;
  final String salesPrice;
  final String? category;
  final String status;
  final String prodType;
  final String createdBy;
  final String approve;
  final DateTime createdDate;
  final DateTime updatedDate;

  searchProductData({
    required this.productId,
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
    required this.createdDate,
    required this.updatedDate,
  });

  factory searchProductData.fromJson(Map<String, dynamic> json) {
    return searchProductData(
      productId: json['product_id'] ?? '',
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
      createdDate:
          DateTime.parse(json['created_date'] ?? '1970-01-01 00:00:00'),
      updatedDate:
          DateTime.parse(json['updated_date'] ?? '1970-01-01 00:00:00'),
    );
  }
}

class searchProductResponse {
  final int status;
  final bool error;
  final String responseCode;
  final List<searchProductData> products;

  searchProductResponse({
    required this.status,
    required this.error,
    required this.responseCode,
    required this.products,
  });

  factory searchProductResponse.fromJson(Map<String, dynamic> json) {
    var productList = json['messages']['status']['product_data'] as List;
    List<searchProductData> products =
        productList.map((i) => searchProductData.fromJson(i)).toList();

    return searchProductResponse(
      status: json['status'] ?? 0,
      error: json['error'] ?? false,
      responseCode: json['messages']['responsecode'] ?? '',
      products: products,
    );
  }
}
