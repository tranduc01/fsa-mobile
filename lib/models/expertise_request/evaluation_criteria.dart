class EvaluationCriteria {
  int? id;
  String? name;
  String? content;

  EvaluationCriteria({
    this.id,
    this.name,
    this.content,
  });

  factory EvaluationCriteria.fromJson(Map<String, dynamic> json) =>
      EvaluationCriteria(
        id: json['id'] as int?,
        name: json['name'] as String?,
        content: json['content'] as String?,
      );
}
