class User {
  bool? embeddable;
  String? href;
  String? taxonomy;
  int? count;
  String? id;
  bool? templated;
  String? name;
  String? userName;
  String? avatarUrl;

  User(
      {this.embeddable,
      this.href,
      this.taxonomy,
      this.count,
      this.id,
      this.templated,
      this.name,
      this.userName,
      this.avatarUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      embeddable: json['embeddable'],
      href: json['href'],
      taxonomy: json['taxonomy'],
      count: json['count'],
      id: json['id'],
      templated: json['templated'],
      name: json['name'],
      userName: json['userName'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['embeddable'] = this.embeddable;
    data['href'] = this.href;
    data['taxonomy'] = this.taxonomy;
    data['count'] = this.count;
    data['id'] = this.id;
    data['templated'] = this.templated;
    data['name'] = this.name;
    data['userName'] = this.userName;
    data['avatarUrl'] = this.avatarUrl;
    return data;
  }
}
