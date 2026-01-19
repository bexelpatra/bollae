class User {
  final int id;
  final String phoneNumber;
  final String storeName;
  final String representativeName;
  final String role;

  User({
    required this.id,
    required this.phoneNumber,
    required this.storeName,
    required this.representativeName,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userId'] ?? json['id'],
      phoneNumber: json['phoneNumber'],
      storeName: json['storeName'],
      representativeName: json['representativeName'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'storeName': storeName,
      'representativeName': representativeName,
      'role': role,
    };
  }

  bool get isManager => role == 'MANAGER';
}
