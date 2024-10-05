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
  final dynamic status;

  forgotPasswordMessages({
    required this.responsecode,
    required this.status,
  });

  factory forgotPasswordMessages.fromJson(Map<String, dynamic> json) {
    var statusData = json['status'];
    dynamic status;

    if (statusData is Map<String, dynamic>) {
      status = forgotPasswordStatus.fromJson(statusData);
      // status = statusData;
    } else {
      status = 'Contact No  not found';
    }

    return forgotPasswordMessages(
      responsecode: json['responsecode'] ?? '',
      status: status,
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
