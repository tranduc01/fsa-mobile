import 'package:socialv/models/common_models/user.dart';

import '../gallery/albums.dart';

class ExpertiseRequest {
  int? id;
  User? assignTo;
  User? createdBy;
  String? noteRequestMessage;
  String? feedbackMessage;
  String? feedbackRating;
  DateTime? feedbackCreatedAt;
  DateTime? createAt;
  int? status;
  List<Media>? medias;

  ExpertiseRequest({
    this.id,
    this.assignTo,
    this.createdBy,
    this.noteRequestMessage,
    this.feedbackMessage,
    this.feedbackRating,
    this.feedbackCreatedAt,
    this.createAt,
    this.status,
    this.medias,
  });

  factory ExpertiseRequest.fromJson(Map<String, dynamic> json) =>
      ExpertiseRequest(
        id: json['id'] as int?,
        assignTo: json['assignTo'] != null
            ? User.fromJson(json['assignTo'] as Map<String, dynamic>)
            : null,
        createdBy: json['createdBy'] != null
            ? User.fromJson(json['createdBy'] as Map<String, dynamic>)
            : null,
        noteRequestMessage: json['noteRequestMessage'] as String?,
        feedbackMessage: json['feedbackMessage'] as String?,
        feedbackRating: json['feedbackRating'] as String?,
        feedbackCreatedAt: json['feedbackCreatedAt'] != null
            ? DateTime.parse(json['feedbackCreatedAt'] as String)
            : null,
        createAt: json['createAt'] != null
            ? DateTime.parse(json['createAt'] as String)
            : null,
        status: json['status'] ?? 0,
        medias: json['medias'] != null
            ? (json['medias'] as List<dynamic>?)
                ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
      );
}
