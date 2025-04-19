import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/models/message.dart';

class ChatService {
  final _firestore = FirebaseFirestore.instance;

  String generateChatId(String uid1, String uid2) {
    return uid1.compareTo(uid2) < 0 ? '${uid1}$uid2' : '${uid2}$uid1';
  }

  Stream<List<ChatMessage>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ChatMessage.fromMap(doc.data()))
        .toList());
  }

  Future<void> sendMessage(String chatId, String senderId, String text, String receiverId) async {
    final message = ChatMessage(
      senderId: senderId,
      text: text,
      timestamp: DateTime.now(),
    );

    final messageRef = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());

    // Update chat preview
    await _firestore.collection('chats').doc(chatId).set({
      'users': [senderId, receiverId],
      'lastMessage': text,
      'lastUpdated': Timestamp.now(),
    }, SetOptions(merge: true));

    // Auto-delete after 2 minutes
    Future.delayed(Duration(minutes: 2), () async {
      await messageRef.delete();
    });
  }
  }
