class forgotPasswordResponse {
  final int status;
  final bool error;
  final forgotPasswordMessages messages;

  forgotPasswordResponse({
    required this.status,
    required this.error,
    required this.messages,
  });

  factory forgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return forgotPasswordResponse(
      status: json['status'] ?? 0,
      error: json['error'] ?? false,
      messages: forgotPasswordMessages.fromJson(json['messages'] ?? {}),
    );
  }
}

class forgotPasswordMessages {
  final String responsecode;
  final forgotPasswordStatus status;

  forgotPasswordMessages({
    required this.responsecode,
    required this.status,
  });

  factory forgotPasswordMessages.fromJson(Map<String, dynamic> json) {
    return forgotPasswordMessages(
      responsecode: json['responsecode'] ?? '',
      status: forgotPasswordStatus.fromJson(json['status'] ?? {}),
    );
  }
}

class forgotPasswordStatus {
  final String msg;
  final String otp;

  forgotPasswordStatus({
    required this.msg,
    required this.otp,
  });

  factory forgotPasswordStatus.fromJson(Map<String, dynamic> json) {
    return forgotPasswordStatus(
      msg: json['msg'] ?? '',
      otp: json['OTP'] ?? '',
    );
  }
}
