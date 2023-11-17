class OrchidTag {
  int? id;
  String? name;

  OrchidTag({this.id, this.name});

  factory OrchidTag.fromJson(Map<String, dynamic> json) {
    return OrchidTag(
      id: json['id'],
      name: json['name'],
    );
  }
}
