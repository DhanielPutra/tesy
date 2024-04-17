class User {
  int? id;
  String? name;
  String? email;
  String? token;

  User({
    this.id,
    this.name,
    this.email,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['user']['id'] ?? 0,
        name: json['user']['username'] ?? '',
        email: json['user']['email'] ?? '',
        token: json['token'] ?? '',
      );
    } catch (e) {
      print('Error parsing user data: $e');
      return User();
    }
  }
}
