class OrderQuantityUpdateResponse {
  int status;
  bool error;
  String message;

  OrderQuantityUpdateResponse({
    required this.status,
    required this.error,
    required this.message,
  });

  factory OrderQuantityUpdateResponse.fromJson(Map<String, dynamic> json) {
    return OrderQuantityUpdateResponse(
      status: json['status'] ?? 0,
      error: json['error'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'error': error,
      'message': message,
    };
  }
}
