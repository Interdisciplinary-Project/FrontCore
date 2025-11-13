import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyModel {
  final String id;
  final String userId;
  final String userName;
  final String message;
  final DateTime createdAt;

  ReplyModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.message,
    required this.createdAt,
  });

  factory ReplyModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return ReplyModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Usuário',
      message: data['message'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}