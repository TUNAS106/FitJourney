import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateChallenge(String userId, int newChallenge) async {
    await _firestore.collection('users').doc(userId).update({
      'challenge': newChallenge,
    });
  }

  Future<int> getChallenge(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data()?['challenge'] ?? 1;
  }
}
