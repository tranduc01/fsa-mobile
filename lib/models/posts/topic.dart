class Topic {
  int? id;
  String? name;
  String? description;

  Topic({this.id, this.name, this.description});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
