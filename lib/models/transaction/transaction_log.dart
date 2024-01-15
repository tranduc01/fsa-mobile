import 'package:socialv/models/enums/enums.dart';

class TransactionLog {
  int? id;
  int? amount;
  TransactionType? transactionType;
  DateTime? createdDate;
  String? note;

  TransactionLog(
      {this.id,
      this.amount,
      this.transactionType,
      this.createdDate,
      this.note});

  TransactionLog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    transactionType = json['transactionType'] != null
        ? TransactionType.values[json['transactionType']]
        : null;
    createdDate = json['createdDate'] != null
        ? DateTime.parse(json['createdDate'])
        : null;
    note = json['notes'];
  }
}
