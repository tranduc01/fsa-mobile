import 'package:socialv/models/common_models/user.dart';
import 'package:socialv/models/expertise_request/expertise_result.dart';

import '../gallery/albums.dart';

class ExpertiseRequest {
  int? id;
  User? user;
  String? noteRequestMessage;
  String? rejectMessage;
  String? feedbackMessage;
  String? feedbackRating;
  DateTime? feedbackCreatedAt;
  DateTime? createdAt;
  int? adminApprovalStatus;
  bool? isSystemReject;
  User? expert;
  int? expertApprovalStatus;
  DateTime? assignAt;
  List<Media>? medias;
  List<ExpertiseResult>? expertiseResults;

  ExpertiseRequest({
    this.id,
    this.user,
    this.noteRequestMessage,
    this.rejectMessage,
    this.feedbackMessage,
    this.feedbackRating,
    this.feedbackCreatedAt,
    this.createdAt,
    this.adminApprovalStatus,
    this.isSystemReject,
    this.expert,
    this.expertApprovalStatus,
    this.assignAt,
    this.medias,
    this.expertiseResults,
  });

  factory ExpertiseRequest.fromJson(Map<String, dynamic> json) =>
      ExpertiseRequest(
        id: json['id'] as int?,
        user: json['user'] != null
            ? User.fromJson(json['user'] as Map<String, dynamic>)
            : null,
        noteRequestMessage: json['noteRequestMessage'] as String?,
        //rejectMessage: json['rejectMessage'] as String?,
        //feedbackMessage: json['feedbackMessage'] as String?,
        //feedbackRating: json['feedbackRating'] as String?,
        // feedbackCreatedAt: json['feedbackCreatedAt'] != null
        //     ? DateTime.parse(json['feedbackCreatedAt'] as String)
        //     : null,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
        adminApprovalStatus: json['adminApprovalStatus'] as int? ?? 0,
        isSystemReject: json['isSystemReject'] as bool? ?? false,
        expert: json['expert'] != null
            ? User.fromJson(json['expert'] as Map<String, dynamic>)
            : null,
        expertApprovalStatus: json['expertApprovalStatus'],
        assignAt: json['assignAt'] != null
            ? DateTime.parse(json['assignAt'] as String)
            : null,
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
      );
}
