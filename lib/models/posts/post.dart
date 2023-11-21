import 'package:socialv/models/posts/comment.dart';
import 'package:socialv/models/posts/contribute_section.dart';
import 'package:socialv/models/posts/orchid_tag.dart';

import '../common_models/user.dart';
import 'topic.dart';

class Post {
  int? id;
  String? title;
  String? description;
  String? thumbnail;
  int? views;
  DateTime? publishedAt;
  bool? status;
  Topic? topic;
  User? createdBy;
  List<OrchidTag>? tags;
  List<ContributeSession>? contributeSessions;
  List<Comment>? comments;

  Post(
      {this.id,
      this.title,
      this.description,
      this.thumbnail,
      this.views,
      this.publishedAt,
      this.status,
      this.createdBy,
      this.topic,
      this.tags,
      this.contributeSessions,
      this.comments});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        thumbnail: json['thumbnail'],
        views: json['views'],
        publishedAt: DateTime.parse(json['publishedAt']),
        status: json['status'],
        topic: Topic.fromJson(json['topic']),
        createdBy: User.fromJson(json['createdBy']),
        tags: (json['orchidTags'] as List)
            .map((e) => OrchidTag.fromJson(e))
            .toList(),
        contributeSessions: (json['contributeSections'] as List)
            .map((e) => ContributeSession.fromJson(e))
            .toList(),
        comments: (json['comments'] as List)
            .map((e) => Comment.fromJson(e))
            .toList());
  }
}
