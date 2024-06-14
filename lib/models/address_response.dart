import 'dart:convert';

class AddressResponse {
  int status;
  bool error;
  String message;
  List<AddressData> data;

  AddressResponse({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    return AddressResponse(
      status: json['status'] ?? 0,
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((i) => AddressData.fromJson(i ?? {}))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'error': error,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class AddressData {
  String addressId;
  String userId;
  String firstName;
  String lastName;
  String cityname;
  String? state;
  String pincode;
  String email;
  String number;
  String address1;
  String adress2;
  String isDelte;
  String? lat;
  String? lng;
  String createdDate;
  String updatdDare;

  AddressData({
    required this.addressId,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.cityname,
    this.state,
    required this.pincode,
    required this.email,
    required this.number,
    required this.address1,
    required this.adress2,
    required this.isDelte,
    this.lat,
    this.lng,
    required this.createdDate,
    required this.updatdDare,
  });

  factory AddressData.fromJson(Map<String, dynamic> json) {
    return AddressData(
      addressId: json['address_id'] ?? '',
      userId: json['user_id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      cityname: json['cityname'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      email: json['email'] ?? '',
      number: json['number'] ?? '',
      address1: json['address1'] ?? '',
      adress2: json['adress2'] ?? '',
      isDelte: json['is_delte'] ?? '',
      lat: json['lat'] ?? '',
      lng: json['lng'] ?? '',
      createdDate: json['created_date'] ?? '',
      updatdDare: json['updatd_dare'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'cityname': cityname,
      'state': state,
      'pincode': pincode,
      'email': email,
      'number': number,
      'address1': address1,
      'adress2': adress2,
      'is_delte': isDelte,
      'lat': lat,
      'lng': lng,
      'created_date': createdDate,
      'updatd_dare': updatdDare,
    };
  }
}
