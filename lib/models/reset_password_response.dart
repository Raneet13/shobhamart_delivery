class resetPasswordResponse {
  final int status;
  final bool error;
  final resetPasswordMessages messages;

  resetPasswordResponse({
    required this.status,
    required this.error,
    required this.messages,
  });

  factory resetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return resetPasswordResponse(
      status: json['status'] ?? 200,
      error: json['error'] ?? false,
      messages: resetPasswordMessages.fromJson(json['messages'] ?? {}),
    );
  }
}

class resetPasswordMessages {
  final String responsecode;
  final String status;

  resetPasswordMessages({
    required this.responsecode,
    required this.status,
  });

  factory resetPasswordMessages.fromJson(Map<String, dynamic> json) {
    return resetPasswordMessages(
      responsecode: json['responsecode'] ?? '00',
      status: json['status'] ?? '', // Use empty string for default
    );
  }
}
