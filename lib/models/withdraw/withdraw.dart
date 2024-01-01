import 'package:socialv/models/common_models/user.dart';

class Withdraw {
  int? id;
  double? point;
  String? memberNote;
  String? bankShortName;
  String? bankName;
  String? bankCode;
  String? bankAccountName;
  String? bankNumber;
  String? transactionImage;
  DateTime? canceledAt;
  String? cancelMessage;
  String? responseMessage;
  String? note;
  int? status;
  DateTime? createdAt;
  User? user;

  Withdraw(
      {this.id,
      this.point,
      this.memberNote,
      this.bankShortName,
      this.status,
      this.createdAt,
      this.user});

  Withdraw.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    point = json["point"] != null ? json["point"].toDouble() : 0;
    memberNote = json['memberNote'];
    bankShortName = json['bankShortName'];
    status = json['status'];
    bankAccountName = json['bankAccountName'];
    bankNumber = json['bankNumber'];
    bankCode = json['bankCode'];
    bankName = json['bankName'];
    transactionImage = json['transactionImage'];
    canceledAt =
        json['canceledAt'] != null ? DateTime.parse(json['canceledAt']) : null;
    cancelMessage = json['cancelMessage'];
    responseMessage = json['responseMessage'];
    note = json['note'];
    createdAt = DateTime.parse(json['createdAt']);
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
}
