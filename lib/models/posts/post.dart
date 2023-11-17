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
      this.tags});

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
    );
  }
}
