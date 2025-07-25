class User {
  final String id;
  final String name;
  final String email;
  final String gender;
  final int age;
  final String avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.age,
    required this.avatarUrl,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      gender: map['gender'],
      age: map['age'],
      avatarUrl: map['avatarUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'age': age,
      'avatarUrl': avatarUrl,
    };
  }
}