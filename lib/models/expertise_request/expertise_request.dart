import 'package:socialv/models/common_models/user.dart';
import 'package:socialv/models/expertise_request/expertise_result.dart';

import '../gallery/albums.dart';
import 'expertise_feedback.dart';

class ExpertiseRequest {
  int? id;
  User? user;
  String? noteRequestMessage;
  String? rejectMessage;
  DateTime? createdAt;
  int? status;
  User? expert;
  int? expertAssignStatus;
  DateTime? assignAt;
  DateTime? canceledAt;
  String? cancelMessage;
  List<Media>? medias;
  List<ExpertiseResult>? expertiseResults;
  ExpertiseFeedback? feedback;

  ExpertiseRequest({
    this.id,
    this.user,
    this.noteRequestMessage,
    this.rejectMessage,
    this.createdAt,
    this.status,
    this.expert,
    this.expertAssignStatus,
    this.assignAt,
    this.canceledAt,
    this.cancelMessage,
    this.medias,
    this.expertiseResults,
    this.feedback,
  });

  factory ExpertiseRequest.fromJson(Map<String, dynamic> json) =>
      ExpertiseRequest(
        id: json['id'] as int?,
        user: json['user'] != null
            ? User.fromJson(json['user'] as Map<String, dynamic>)
            : null,
        noteRequestMessage: json['noteRequestMessage'] as String?,
        rejectMessage: json['rejectMessage'] as String?,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
        status: json['status'] as int?,
        expert: json['expert'] != null
            ? User.fromJson(json['expert'] as Map<String, dynamic>)
            : null,
        expertAssignStatus: json['expertAssignStatus'],
        assignAt: json['assignAt'] != null
            ? DateTime.parse(json['assignAt'] as String)
            : null,
        canceledAt: json['canceledAt'] != null
            ? DateTime.parse(json['canceledAt'] as String)
            : null,
        cancelMessage: json['cancelMessage'] as String?,
        medias: json['medias'] != null
            ? (json['medias'] as List<dynamic>?)
                ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
        expertiseResults: json['results'] != null
            ? (json['results'] as List<dynamic>?)
                ?.map(
                    (e) => ExpertiseResult.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
        feedback: json['feedback'] != null
            ? ExpertiseFeedback.fromJson(
                json['feedback'] as Map<String, dynamic>)
            : null,
      );
}
