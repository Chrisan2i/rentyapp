import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String reviewId;
  final String userId;
  final String userName;
  final String userImageUrl;
  final double rating;
  final String comment;
  final DateTime createdAt;

  ReviewModel({
    required this.reviewId,
    required this.userId,
    required this.userName,
    required this.userImageUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ReviewModel(
      reviewId: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Usuario Anónimo',
      userImageUrl: data['userImageUrl'] ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      comment: data['comment'] ?? '',
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
    );
  }
}