class User {
  int? id;
  String? name;
  String? email;
  String? token;
  String?no_tlp;
  String?username;

  User({
    this.id,
    this.name,
    this.email,
    this.token,
    this.no_tlp,
    this.username
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['user']['id'] ?? 0,
        name: json['user']['name'] ?? '',
        email: json['user']['email'] ?? '',
        no_tlp: json['user']['no_tlp'] ?? '',
        username: json['user']['username'] ?? '',
        token: json['token'] ?? '',
      );
    } catch (e) {
      print('Error parsing user data: $e');
      return User();
    }
  }
}
