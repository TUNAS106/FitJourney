import '../../../training_modes/models/plan_models.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String gender;
  final int age;
  final String avatarUrl;
  final bool isVip;
  final DateTime? vipExpiry; // VIP expiry date
  final bool isPT;
  final String? phoneNumber; // Số điện thoại
  final String? location;    // Địa điểm
  final String? bio;         // Tiểu sử
  List<WorkoutPlanProgress> activePlans;
  final int challenge;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.age,
    required this.avatarUrl,
    required this.isVip,
    this.vipExpiry,
    this.isPT = false,
    this.phoneNumber,
    this.location,
    this.bio,
    required this.activePlans,
    required this.challenge,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      gender: map['gender'],
      age: map['age'],
      avatarUrl: map['avatarUrl'],
      isVip: map['isVip'] ?? false,
      vipExpiry: map['vipExpiry'] != null ? DateTime.parse(map['vipExpiry']) : null,
      activePlans: [],
      isPT: map['isPT'] ?? false,
      challenge: map['challenge'] ?? 0,
      phoneNumber: map['phoneNumber'], // có thể null
      location: map['location'],       // có thể null
      bio: map['bio'],                 // có thể null
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
      'isVip': isVip,
      'vipExpiry': vipExpiry?.toIso8601String(),
      'isPT': isPT, // Include isPT in the map
      'challenge': challenge,
      'phoneNumber': phoneNumber,
      'location': location,
      'bio': bio,
    };
  }
}
