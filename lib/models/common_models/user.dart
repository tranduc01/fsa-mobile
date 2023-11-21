class User {
  String? id;
  String? name;
  String? userName;
  String? avatarUrl;
  bool? isVerified;
  String? role;

  User(
      {this.id,
      this.role,
      this.name,
      this.userName,
      this.avatarUrl,
      this.isVerified});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      role: json['role'],
      name: json['name'],
      userName: json['userName'],
      avatarUrl: json['avatarUrl'],
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role'] = this.role;
    data['name'] = this.name;
    data['userName'] = this.userName;
    data['avatarUrl'] = this.avatarUrl;
    return data;
  }
}
