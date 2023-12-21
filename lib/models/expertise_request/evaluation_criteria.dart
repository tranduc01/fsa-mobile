class EvaluationCriteria {
  String? evaluationCriteriaName;
  String? content;

  EvaluationCriteria({
    this.evaluationCriteriaName,
    this.content,
  });

  factory EvaluationCriteria.fromJson(Map<String, dynamic> json) =>
      EvaluationCriteria(
        evaluationCriteriaName: json['evaluationCriteriaName'] as String?,
        content: json['content'] as String?,
      );
}
