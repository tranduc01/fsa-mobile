import '../enums/enums.dart';

class User {
  String? id;
  String? name;
  String? userName;
  String? avatarUrl;
  bool? isVerified;
  List<Role> role;

  User(
      {this.id,
      required this.role,
      this.name,
      this.userName,
      this.avatarUrl,
      this.isVerified});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      role: json['roles'] != null
          ? (json['roles'].map<Role>((e) => Role.values[e]).toList())
          : [],
      name: json['name'],
      userName: json['userName'],
      avatarUrl: json['avatarUrl'],
      isVerified: json['isVerified'] ?? false,
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
