class ResponseModel {
  int? statusCode;
  String? message;
  dynamic data;

  ResponseModel({this.statusCode, this.message, this.data});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'],
    );
  }
}
