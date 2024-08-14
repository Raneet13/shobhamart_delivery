class SingleProductResponse {
  int status;
  bool error;
  ProductMessage messages;

  SingleProductResponse({
    required this.status,
    required this.error,
    required this.messages,
  });

  factory SingleProductResponse.fromJson(Map<String, dynamic> json) {
    return SingleProductResponse(
      status: json['status'] ?? 0,
      error: json['error'] ?? false,
      messages: ProductMessage.fromJson(json['messages'] ?? {}),
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

class ProductMessage {
  String responseCode;
  ProductStatus status;

  ProductMessage({
    required this.responseCode,
    required this.status,
  });

  factory ProductMessage.fromJson(Map<String, dynamic> json) {
    return ProductMessage(
      responseCode: json['responsecode'] ?? '',
      status: ProductStatus.fromJson(json['status'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'responsecode': responseCode,
      'status': status.toJson(),
    };
  }
}

class ProductStatus {
  List<SProductData> singleProduct;
  List<SProductGallery> productGallery;
  List<sAttribute> attributes;

  ProductStatus({
    required this.singleProduct,
    required this.productGallery,
    required this.attributes,
  });

  factory ProductStatus.fromJson(Map<String, dynamic> json) {
    return ProductStatus(
      singleProduct: (json['SingleProduct'] as List<dynamic>?)
              ?.map((data) => SProductData.fromJson(data))
              .toList() ??
          [],
      productGallery: (json['ProductGallery'] as List<dynamic>?)
              ?.map((data) => SProductGallery.fromJson(data))
              .toList() ??
          [],
      attributes: (json['attribute'] as List<dynamic>?)
              ?.map((data) => sAttribute.fromJson(data))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SingleProduct': singleProduct.map((data) => data.toJson()).toList(),
      'ProductGallery': productGallery..map((data) => data.toJson()).toList(),
      'attribute': attributes.map((data) => data.toJson()).toList(),
    };
  }
}

class SProductData {
  String productId;
  String productName;
  String primaryImage;
  String productType;
  String regularPrice;
  String salesPrice;
  String? brandsId;
  String? brandsName;
  String description;

  SProductData({
    required this.productId,
    required this.productName,
    required this.primaryImage,
    required this.productType,
    required this.regularPrice,
    required this.salesPrice,
    this.brandsId,
    this.brandsName,
    required this.description,
  });

  factory SProductData.fromJson(Map<String, dynamic> json) {
    return SProductData(
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      primaryImage: json['primary_image'] ?? '',
      productType: json['product_type'] ?? '',
      regularPrice: json['regular_price'] ?? '',
      salesPrice: json['sales_price'] ?? '',
      brandsId: json['brands_id'],
      brandsName: json['brands_name'],
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'primary_image': primaryImage,
      'product_type': productType,
      'regular_price': regularPrice,
      'sales_price': salesPrice,
      'brands_id': brandsId,
      'brands_name': brandsName,
      'description': description,
    };
  }
}

class SProductGallery {
  String productId;
  String galleryId;
  String image;

  SProductGallery({
    required this.productId,
    required this.galleryId,
    required this.image,
  });

  factory SProductGallery.fromJson(Map<String, dynamic> json) {
    return SProductGallery(
      productId: json['product_id'] ?? '',
      galleryId: json['gallery_id'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'gallery_id': galleryId,
      'image': image,
    };
  }
}

class sAttribute {
  String attributeId;
  String productId;
  String attributeName;
  List<sVariation> variations;

  sAttribute({
    required this.attributeId,
    required this.productId,
    required this.attributeName,
    required this.variations,
  });

  factory sAttribute.fromJson(Map<String, dynamic> json) {
    return sAttribute(
      attributeId: json['attribute_id'] ?? '',
      productId: json['product_id'] ?? '',
      attributeName: json['attribute_name'] ?? '',
      variations: (json['variations'] as List<dynamic>?)
              ?.map((data) => sVariation.fromJson(data))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attribute_id': attributeId,
      'product_id': productId,
      'attribute_name': attributeName,
      'variations': variations.map((data) => data.toJson()).toList(),
    };
  }
}

class sVariation {
  String attributeId;
  String variationId;
  String variationName;
  String variationPrice;
  String productId;

  sVariation({
    required this.attributeId,
    required this.variationId,
    required this.variationName,
    required this.variationPrice,
    required this.productId,
  });

  factory sVariation.fromJson(Map<String, dynamic> json) {
    return sVariation(
      attributeId: json['attribute_id'] ?? '',
      variationId: json['variation_id'] ?? '',
      variationName: json['variation_name'] ?? '',
      variationPrice: json['variation_price'] ?? '',
      productId: json['product_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attribute_id': attributeId,
      'variation_id': variationId,
      'variation_name': variationName,
      'variation_price': variationPrice,
      'product_id': productId,
    };
  }
}

// For Local Storage
class UserProductResponse {
  String userId;
  String orderId;
  int qty;
  String productName;
  String img;
  String price;
  String variation;

  UserProductResponse({
    required this.userId,
    required this.orderId,
    required this.qty,
    required this.productName,
    required this.img,
    required this.price,
    required this.variation,
  });

  factory UserProductResponse.fromJson(Map<String, dynamic> json) {
    return UserProductResponse(
      userId: json['userId'] ?? '',
      orderId: json['orderId'] ?? '',
      qty: json['qty'] ?? 0,
      productName: json['productName'] ?? '',
      img: json['img'] ?? '',
      price: json['price'] ?? '',
      variation: json['variation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'orderId': orderId,
      'qty': qty,
      'productName': productName,
      'img': img,
      'price': price,
      'variation': variation,
    };
  }
}
