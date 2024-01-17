import 'package:socialv/models/common_models/user.dart';
import 'package:socialv/models/orchid/orchid.dart';

import '../gallery/albums.dart';
import 'bid.dart';

class Auction {
  int? id;
  String? title;
  String? description;
  String? thumbnail;
  int? view;
  double? reservePrice;
  double? stepPrice;
  double? soldDirectlyPrice;
  double? currentBidPrice;
  double? registrationFee;
  DateTime? startDate;
  DateTime? actualEndDate;
  DateTime? estimateEndDate;
  DateTime? startRegisterAt;
  DateTime? endRegisterAt;
  int? numberParticipated;
  bool? isPreview;
  bool? isStopHalfway;
  bool? isSoldDirectly;
  Orchid? orchid;
  List<Media>? medias;
  List<Bid>? auctionBids;
  User? winner;
  double? currentPoint;
  bool? isRegistered;

  Auction({
    this.id,
    this.title,
    this.description,
    this.thumbnail,
    this.view,
    this.reservePrice,
    this.stepPrice,
    this.soldDirectlyPrice,
    this.currentBidPrice,
    this.registrationFee,
    this.startDate,
    this.actualEndDate,
    this.estimateEndDate,
    this.startRegisterAt,
    this.endRegisterAt,
    this.numberParticipated,
    this.isPreview,
    this.isStopHalfway,
    this.isSoldDirectly,
    this.orchid,
    this.medias,
    this.auctionBids,
    this.winner,
    this.currentPoint,
    this.isRegistered,
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
        currentBidPrice: json["currentBidPrice"] != null
            ? json["currentBidPrice"].toDouble()
            : 0,
        registrationFee: json["registrationFee"] != null
            ? json["registrationFee"].toDouble()
            : 0,
        startDate: DateTime.parse(json["startDate"]),
        actualEndDate: DateTime.parse(json["actualEndDate"]),
        estimateEndDate: DateTime.parse(json["estimateEndDate"]),
        startRegisterAt: DateTime.parse(json["startRegisterAt"]),
        endRegisterAt: DateTime.parse(json["endRegisterAt"]),
        numberParticipated: json["numberParticipated"] as int? ?? 0,
        isPreview: json["isPreview"] as bool? ?? false,
        isStopHalfway: json["isStopHalfway"] as bool? ?? false,
        isSoldDirectly: json["isSoldDirectly"] as bool? ?? false,
        orchid: Orchid.fromJson(json["orchid"]),
        medias: json["medias"] != null
            ? (json["medias"] as List).map((e) => Media.fromJson(e)).toList()
            : [],
        auctionBids: json["auctionBids"] != null
            ? (json["auctionBids"] as List).map((e) => Bid.fromJson(e)).toList()
            : [],
        winner: json["winner"] != null ? User.fromJson(json["winner"]) : null,
        currentPoint:
            json["currentPoint"] != null ? json["currentPoint"].toDouble() : 0,
        isRegistered: json["isRegistered"] as bool? ?? false,
      );
}
