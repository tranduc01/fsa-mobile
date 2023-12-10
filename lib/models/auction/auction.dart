import 'package:socialv/models/orchid/orchid.dart';

import '../gallery/albums.dart';

class Auction {
  int? id;
  String? title;
  String? description;
  String? thumbnail;
  int? view;
  double? reservePrice;
  double? stepPrice;
  double? soldDirectlyPrice;
  double? currentPrice;
  DateTime? startDate;
  DateTime? endDate;
  int? numberParticipated;
  bool? isPreview;
  bool? isStopHalfway;
  bool? isSoldDirectly;
  Orchid? orchid;
  List<Media>? medias;

  Auction({
    this.id,
    this.title,
    this.description,
    this.thumbnail,
    this.view,
    this.reservePrice,
    this.stepPrice,
    this.soldDirectlyPrice,
    this.currentPrice,
    this.startDate,
    this.endDate,
    this.numberParticipated,
    this.isPreview,
    this.isStopHalfway,
    this.isSoldDirectly,
    this.orchid,
    this.medias,
  });

  factory Auction.fromJson(Map<String, dynamic> json) => Auction(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        thumbnail: json["thumbnail"],
        view: json["view"] as int?,
        reservePrice:
            json["reservePrice"] != null ? json["reservePrice"].toDouble() : 0,
        stepPrice: json["stepPrice"] != null ? json["stepPrice"].toDouble() : 0,
        soldDirectlyPrice: json["soldDirectlyPrice"] != null
            ? json["soldDirectlyPrice"].toDouble()
            : 0,
        currentPrice:
            json["currentPrice"] != null ? json["currentPrice"].toDouble() : 0,
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        numberParticipated: json["numberParticipated"] as int? ?? 0,
        isPreview: json["isPreview"] as bool? ?? false,
        isStopHalfway: json["isStopHalfway"] as bool? ?? false,
        isSoldDirectly: json["isSoldDirectly"] as bool? ?? false,
        orchid: Orchid.fromJson(json["orchid"]),
        medias: json["medias"] != null
            ? (json["medias"] as List).map((e) => Media.fromJson(e)).toList()
            : [],
      );
}