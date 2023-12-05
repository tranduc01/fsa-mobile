class Orchid {
  int? id;
  String? name;
  String? description;
  String? botanicalName;
  String? family;
  String? plantType;
  String? nativeArea;
  String? height;
  String? sunExposure;
  String? imageUrl;
  bool? status;

  Orchid({
    this.id,
    this.name,
    this.description,
    this.botanicalName,
    this.family,
    this.plantType,
    this.nativeArea,
    this.height,
    this.sunExposure,
    this.imageUrl,
    this.status,
  });

  factory Orchid.fromJson(Map<String, dynamic> json) => Orchid(
        id: json["id"],
        name: json["commonName"],
        description: json["description"],
        botanicalName: json["botanicalName"],
        family: json["family"],
        plantType: json["plantType"],
        nativeArea: json["nativeArea"],
        height: json["height"],
        sunExposure: json["sunExposure"],
        imageUrl: json["imageUrl"],
        status: json["status"],
      );
}
