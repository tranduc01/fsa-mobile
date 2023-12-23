import 'package:socialv/models/expertise_request/evaluation_criteria.dart';

class ExpertiseResult {
  int? id;
  int? submitType;
  DateTime? createdAt;
  List<EvaluationCriteria>? evaluationCriterias;

  ExpertiseResult({
    this.id,
    this.submitType,
    this.createdAt,
    this.evaluationCriterias,
  });

  factory ExpertiseResult.fromJson(Map<String, dynamic> json) =>
      ExpertiseResult(
        id: json['id'] as int?,
        submitType: json['submitType'] as int?,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
        evaluationCriterias: (json['evaluationCriteriaResult']
                as List<dynamic>?)
            ?.map((e) => EvaluationCriteria.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
