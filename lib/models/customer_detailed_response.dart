class user_details {
  final int status;
  final bool error;
  final Messages messages;

  user_details({
    required this.status,
    required this.error,
    required this.messages,
  });

  factory user_details.fromJson(Map<String, dynamic> json) {
    return user_details(
      status: json['status'] ?? 0,
      error: json['error'] ?? false,
      messages: Messages.fromJson(json['messages'] ?? {}),
    );
  }
}

class Messages {
  final String responsecode;
  final UserStatus status;

  Messages({
    required this.responsecode,
    required this.status,
  });

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      responsecode: json['responsecode'] ?? '',
      status: UserStatus.fromJson(json['status'] ?? {}),
    );
  }
}

class UserStatus {
  final String userId;
  final String? fullname;
  final String? email;
  final String contact;
  final String? status;
  final String? lat;
  final String? lng;
  final String? storeImage;
  final String? storeName;
  final String? cityName;
  final String? address;
  final String? stateName;

  final bool isLoggedIn;

  UserStatus({
    required this.userId,
    this.fullname,
    this.email,
    required this.contact,
    this.status,
    this.lat,
    this.lng,
    this.storeImage,
    this.cityName,
    this.address,
    this.stateName,
    this.storeName,
    required this.isLoggedIn,
  });

  factory UserStatus.fromJson(Map<String, dynamic> json) {
    return UserStatus(
      userId: json['user_id'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      contact: json['contact'] ?? '',
      status: json['status'] ?? '',
      lat: json['lat'] ?? '',
      lng: json['lng'] ?? '',
      storeImage: json['store_image'] ?? '',
      cityName: json['city_name'] ?? '',
      stateName: json['state_name'] ?? '',
      storeName: json['store_name'] ?? '',
      address: json['address'] ?? '',
      isLoggedIn: json['isLoggedIn'] ?? false,
    );
  }
}
