import 'package:socialv/models/common_models/user.dart';

import '../gallery/albums.dart';

class ExpertiseRequest {
  int? id;
  User? createdBy;
  String? noteRequestMessage;
  String? rejectMessage;
  String? feedbackMessage;
  String? feedbackRating;
  DateTime? feedbackCreatedAt;
  DateTime? createAt;
  String? adminApprovalStatus;
  String? isSystemReject;
  User? expert;
  List<Media>? medias;

  ExpertiseRequest({
    this.id,
    this.createdBy,
    this.noteRequestMessage,
    this.rejectMessage,
    this.feedbackMessage,
    this.feedbackRating,
    this.feedbackCreatedAt,
    this.createAt,
    this.adminApprovalStatus,
    this.isSystemReject,
    this.expert,
    this.medias,
  });

  factory ExpertiseRequest.fromJson(Map<String, dynamic> json) =>
      ExpertiseRequest(
        id: json['id'] as int?,
        createdBy: json['createdBy'] != null
            ? User.fromJson(json['createdBy'] as Map<String, dynamic>)
            : null,
        noteRequestMessage: json['noteRequestMessage'] as String?,
        rejectMessage: json['rejectMessage'] as String?,
        feedbackMessage: json['feedbackMessage'] as String?,
        feedbackRating: json['feedbackRating'] as String?,
        feedbackCreatedAt: json['feedbackCreatedAt'] != null
            ? DateTime.parse(json['feedbackCreatedAt'] as String)
            : null,
        createAt: json['createAt'] != null
            ? DateTime.parse(json['createAt'] as String)
            : null,
        adminApprovalStatus: json['adminApprovalStatus'] ?? 'Pending',
        isSystemReject: json['isSystemReject'] as String?,
        expert: json['expertAssign'] != null &&
                json['expertAssign']['expert'] != null
            ? User.fromJson(
                json['expertAssign']['expert'] as Map<String, dynamic>)
            : null,
        medias: json['medias'] != null
            ? (json['medias'] as List<dynamic>?)
                ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
      );
}
