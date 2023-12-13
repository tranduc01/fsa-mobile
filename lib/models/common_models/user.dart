import '../enums/enums.dart';

class User {
  String? id;
  String? email;
  String? name;
  String? userName;
  String? avatarUrl;
  bool? isVerified;
  double? totalPoint;
  int? totalPostContributed;
  int? totalExpertiseRequestSent;
  int? totalParticipatedAuction;
  int? totalCompleteExpertiseRequest;
  int? expertiseLeft;
  List<Role> role;

  User({
    this.id,
    required this.role,
    this.email,
    this.name,
    this.userName,
    this.avatarUrl,
    this.isVerified,
    this.totalPoint,
    this.totalPostContributed,
    this.totalExpertiseRequestSent,
    this.totalParticipatedAuction,
    this.totalCompleteExpertiseRequest,
    this.expertiseLeft,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      role: json['roles'] != null
          ? (json['roles'].map<Role>((e) => Role.values[e]).toList())
          : [],
      name: json['name'],
      userName: json['userName'],
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'],
      isVerified: json['isVerified'] ?? false,
      totalPoint:
          json["totalPoint"] != null ? json["totalPoint"].toDouble() : 0,
      totalPostContributed: json["totalPostContributed"] ?? 0,
      totalExpertiseRequestSent: json["totalExpertiseRequestSent"] ?? 0,
      totalParticipatedAuction: json["totalParticipatedAuction"] ?? 0,
      totalCompleteExpertiseRequest: json["totalCompleteExpertiseRequest"] ?? 0,
      expertiseLeft: json["expertiseLeft"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roles'] = this.role.map((r) => r.name).toList();
    data['name'] = this.name;
    data['userName'] = this.userName;
    data['avatarUrl'] = this.avatarUrl;
    data['isVerified'] = this.isVerified;
    return data;
  }
}
