class ExpertiseResult {
  String? evaluationCriteriaName;
  String? content;

  ExpertiseResult({
    this.evaluationCriteriaName,
    this.content,
  });

  factory ExpertiseResult.fromJson(Map<String, dynamic> json) =>
      ExpertiseResult(
        evaluationCriteriaName: json['evaluationCriteriaName'] as String?,
        content: json['content'] as String?,
      );
}
