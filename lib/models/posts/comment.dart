import 'package:socialv/models/common_models/user.dart';

class Comment {
  int? id;
  String? content;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? status;
  User? user;

  Comment(
      {this.id,
      this.content,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.status});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'],
        content: json['content'],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
        status: json['status'],
        user: User.fromJson(json['user']));
  }
}
