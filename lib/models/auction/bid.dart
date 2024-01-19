import '../common_models/user.dart';

class Bid {
  int? id;
  User? bidder;
  double? bidAmount;
  DateTime? bidAt;

  Bid({
    this.id,
    this.bidder,
    this.bidAmount,
    this.bidAt,
  });

  factory Bid.fromJson(Map<String, dynamic> json) => Bid(
        id: json["id"],
        bidder: json["bidder"] != null ? User.fromJson(json["bidder"]) : null,
        bidAmount: json["bidAmount"] != null ? json["bidAmount"].toDouble() : 0,
        bidAt: DateTime.parse(json["biddedAt"]),
      );

  @override
  String toString() {
    return 'Bid{id: $id, bidder: $bidder, bidAmount: $bidAmount, bidAt: $bidAt}';
  }
}
