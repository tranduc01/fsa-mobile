import 'package:socialv/models/orchid/orchid.dart';

class Auction {
  int? id;
  String? title;
  String? description;
  String? thumbnail;
  int? view;
  double? reservePrice;
  double? stepPrice;
  double? soldDirectlyPrice;
  DateTime? startDate;
  DateTime? endDate;
  Orchid? orchid;

  Auction({
    this.id,
    this.title,
    this.description,
    this.thumbnail,
    this.view,
    this.reservePrice,
    this.stepPrice,
    this.soldDirectlyPrice,
    this.startDate,
    this.endDate,
    this.orchid,
  });

  factory Auction.fromJson(Map<String, dynamic> json) => Auction(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        thumbnail: json["thumbnail"],
        view: json["view"] as int?,
        reservePrice: double.parse(json["reservePrice"].toString()),
        stepPrice: double.parse(json["stepPrice"].toString()),
        soldDirectlyPrice: double.parse(json["soldDirectlyPrice"].toString()),
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        orchid: Orchid.fromJson(json["orchid"]),
      );
}
