class TopupPackage {
  int? id;
  String? title;
  String? description;
  int? pointEarned;
  double? price;
  double? salePrice;
  double? salePercent;
  DateTime? saleStartAt;
  DateTime? saleEndAt;
  bool? isApplySale;

  TopupPackage({
    this.id,
    this.title,
    this.description,
    this.pointEarned,
    this.price,
    this.salePrice,
    this.salePercent,
    this.saleStartAt,
    this.saleEndAt,
    this.isApplySale,
  });

  TopupPackage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    pointEarned = json['pointEarned'];
    price = json["price"] != null ? json["price"].toDouble() : 0;
    salePrice = json["salePrice"] != null ? json["salePrice"].toDouble() : 0;
    salePercent =
        json["salePercent"] != null ? json["salePercent"].toDouble() : 0;
    saleStartAt = json['saleStartAt'] != null
        ? DateTime.parse(json['saleStartAt'])
        : null;
    saleEndAt =
        json['saleEndAt'] != null ? DateTime.parse(json['saleEndAt']) : null;
    isApplySale = json['isApplySale'];
  }
}
