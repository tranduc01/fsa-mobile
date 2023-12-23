class ExpertiseFeedback {
  int? id;
  String? message;
  double? rating;
  DateTime? createdAt;

  ExpertiseFeedback({
    this.id,
    this.message,
    this.rating,
    this.createdAt,
  });

  factory ExpertiseFeedback.fromJson(Map<String, dynamic> json) =>
      ExpertiseFeedback(
        id: json['id'] as int?,
        message: json['message'] as String?,
        rating: json["rating"] != null ? json["rating"].toDouble() : 0,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
      );
}
