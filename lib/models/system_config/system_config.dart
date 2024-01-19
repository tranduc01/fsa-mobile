class SystemConfig {
  int? id;
  String? key;
  String? title;
  String? value;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? status;

  SystemConfig({
    this.id,
    this.key,
    this.title,
    this.value,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory SystemConfig.fromJson(Map<String, dynamic> json) => SystemConfig(
        id: json["id"],
        key: json["key"],
        title: json["title"],
        value: json["value"],
        description: json["description"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        status: json["status"],
      );
}
