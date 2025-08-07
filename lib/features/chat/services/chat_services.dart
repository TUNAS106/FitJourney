import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/data/models/user.dart' as app;
import '../data/models/chat_room.dart';
import '../data/models/message.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthBloc authBloc;

  ChatService(this.authBloc);

  String? get _currentUserId {
    final state = authBloc.state;
    if (state is Authenticated) {
      return state.user.id; // or state.user.uid depending on your model
    }
    return null;
  }

  Future<String> createOrGetChatRoom(String ptId) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) throw Exception('User not authenticated');
    final chatRoomId = _generateChatRoomId(currentUserId, ptId);
    final chatRoomRef = _firestore.collection('chatRooms').doc(chatRoomId);
    final chatRoomDoc = await chatRoomRef.get();
    if (!chatRoomDoc.exists) {
      final chatRoom = ChatRoom(
        id: chatRoomId,
        userId: currentUserId,
        ptId: ptId,
        lastActivity: DateTime.now(),
      );
      await chatRoomRef.set(chatRoom.toMap());
    }
    return chatRoomId;
  }

  Future<void> sendMessage(String chatRoomId, String receiverId, String content) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) throw Exception('User not authenticated');
    final messageId = _firestore.collection('messages').doc().id;
    final message = Message(
      id: messageId,
      senderId: currentUserId,
      receiverId: receiverId,
      content: content,
      timestamp: DateTime.now(),
    );
    final batch = _firestore.batch();
    batch.set(
      _firestore.collection('messages').doc(messageId),
      message.toMap(),
    );
    batch.update(
      _firestore.collection('chatRooms').doc(chatRoomId),
      {
        'lastMessage': message.toMap(),
        'lastActivity': message.timestamp.millisecondsSinceEpoch,
        'unreadCount': FieldValue.increment(1),
      },
    );
    await batch.commit();
  }

  Stream<List<Message>> getMessages(String chatRoomId) {
    return _firestore
        .collection('messages')
        .where('senderId', whereIn: _getChatRoomParticipants(chatRoomId))
        .where('receiverId', whereIn: _getChatRoomParticipants(chatRoomId))
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Message.fromMap(doc.data()))
        .where((message) => _isMessageInChatRoom(message, chatRoomId))
        .toList());
  }

  Stream<List<app.User>> getPTList() {
    return _firestore
        .collection('users')
        .where('isPT', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => app.User.fromMap(doc.data()))
        .toList());
  }

  Stream<List<ChatRoom>> getUserChatRooms() {
    final currentUserId = _currentUserId;
    if (currentUserId == null) return Stream.value([]);
    return _firestore
        .collection('chatRooms')
        .where('userId', isEqualTo: currentUserId)
        .orderBy('lastActivity', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ChatRoom.fromMap(doc.data()))
        .toList());
  }

  Stream<List<ChatRoom>> getPTChatRooms() {
    final currentUserId = _currentUserId;
    if (currentUserId == null) return Stream.value([]);
    return _firestore
        .collection('chatRooms')
        .where('ptId', isEqualTo: currentUserId)
        .orderBy('lastActivity', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ChatRoom.fromMap(doc.data()))
        .toList());
  }

  Future<void> markMessagesAsRead(String chatRoomId) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) return;
    final batch = _firestore.batch();
    final unreadMessages = await _firestore
        .collection('messages')
        .where('receiverId', isEqualTo: currentUserId)
        .where('isRead', isEqualTo: false)
        .get();
    for (final doc in unreadMessages.docs) {
      final message = Message.fromMap(doc.data());
      if (_isMessageInChatRoom(message, chatRoomId)) {
        batch.update(doc.reference, {'isRead': true});
      }
    }
    batch.update(
      _firestore.collection('chatRooms').doc(chatRoomId),
      {'unreadCount': 0},
    );
    await batch.commit();
  }

  String _generateChatRoomId(String userId, String ptId) {
    final ids = [userId, ptId]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  List<String> _getChatRoomParticipants(String chatRoomId) {
    return chatRoomId.split('_');
  }

  bool _isMessageInChatRoom(Message message, String chatRoomId) {
    final participants = _getChatRoomParticipants(chatRoomId);
    return participants.contains(message.senderId) &&
        participants.contains(message.receiverId);
  }

  Future<app.User?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return app.User.fromMap(doc.data()!);
      }
    } catch (e) {
      print('Error getting user: $e');
    }
    return null;
  }
}