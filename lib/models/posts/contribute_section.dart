import '../common_models/user.dart';

class ContributeSession {
  int? id;
  int? contributeSectionContentId;
  String? content;
  int? index;
  User? user;

  ContributeSession(
      {this.id,
      this.contributeSectionContentId,
      this.content,
      this.index,
      this.user});

  factory ContributeSession.fromJson(Map<String, dynamic> json) {
    return ContributeSession(
      id: json['contributeSectionId'],
      contributeSectionContentId: json['contributeSectionContentId'],
      content: json['content'],
      index: json['index'],
      user: User.fromJson(json['user']),
    );
  }
}
