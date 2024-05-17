

class ApiResponse {
  Object? data;
  String? error;
 ApiResponse({this.error, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      error: json['error'] != null ? json['error'] : null,
      data: json['data'],
    );
  }


}