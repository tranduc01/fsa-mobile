import 'package:socialv/models/common_models/user.dart';

class Album {
  int? id;
  String? title;
  String? coverImageUrl;
  String? description;
  DateTime? createdAt;
  bool? canDelete;
  bool? isPublic;
  List<Media> media = [];
  User? user;

  Album(
      {this.id,
      this.title,
      this.description,
      this.coverImageUrl,
      this.createdAt,
      required this.media,
      this.isPublic,
      this.canDelete,
      this.user});

  Album.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    coverImageUrl = json['coverImageUrl'];
    description = json['description'];
    canDelete = json['can_delete'] ?? true;
    createdAt = DateTime.parse(json['createdAt']);
    isPublic = json['isPublic'];
    media = (json['medias'] as List).map((e) => Media.fromJson(e)).toList();
    user = User.fromJson(json['user']);
  }
}

class Media {
  int? id;
  String? url;
  String? name;
  String? type;
  bool? canDelete;

  Media({
    this.id,
    this.url,
    this.name,
    this.type,
    this.canDelete,
  });

  Media.fromJson(dynamic json) {
    id = json['id'];
    url = json['url'];
    name = json['name'];
    type = json['type'];
    canDelete = json['can_delete'] ?? true;
  }
}
