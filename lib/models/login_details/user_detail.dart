import 'dart:convert';

class userResponse {
  final int status;
  final bool error;
  final userMessages messages;

  userResponse({
    required this.status,
    required this.error,
    required this.messages,
  });

  factory userResponse.fromJson(Map<String, dynamic> json) {
    return userResponse(
      status: json['status'] ?? 0,
      error: json['error'] ?? false,
      messages: userMessages.fromJson(json['messages'] ?? {}),
    );
  }
}

class userMessages {
  final String responsecode;
  final userStatus status;

  userMessages({
    required this.responsecode,
    required this.status,
  });

  factory userMessages.fromJson(Map<String, dynamic> json) {
    return userMessages(
      responsecode: json['responsecode'] ?? '',
      status: userStatus.fromJson(json['status'] ?? {}),
    );
  }
}

class userStatus {
  final String userId;
  final String fullname;
  final String email;
  final String contact;
  final String status;
  final String storeImage;
  final String adharNo;
  final String storeFont;
  final String adharBack;
  final String address;
  final bool isLoggedIn;

  userStatus({
    required this.userId,
    required this.fullname,
    required this.email,
    required this.contact,
    required this.status,
    required this.storeImage,
    required this.adharNo,
    required this.storeFont,
    required this.adharBack,
    required this.address,
    required this.isLoggedIn,
  });

  factory userStatus.fromJson(Map<String, dynamic> json) {
    return userStatus(
      userId: json['user_id'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      contact: json['contact'] ?? '',
      status: json['status'] ?? '',
      storeImage: json['store_image'] ?? '',
      adharNo: json['adhar_no'] ?? '',
      storeFont: json['store_font'] ?? '',
      adharBack: json['adhar_back'] ?? '',
      address: json['address'] ?? '',
      isLoggedIn: json['isLoggedIn'] ?? false,
    );
  }
}
