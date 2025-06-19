import 'package:cloud_firestore/cloud_firestore.dart';

enum VerificationStatus {
  notVerified,
  level1_basic,
  level2_plus,
}

class UserModel {
  // --- Identificación ---
  final String userId;
  final String fullName;
  final String username;
  final String email;
  final String? phone;
  final String profileImageUrl;

  // --- Reputación y Estadísticas ---
  final double rating;
  final int totalReviews;
  final int totalRentsAsRenter;
  final int totalRentsAsOwner;

  // --- Billetera Interna (Wallet) ---
  final Map<String, double> wallet;

  // --- Estado, Rol y Verificación (Resumen) ---
  final String status;
  final String role;
  final VerificationStatus verificationStatus;

  // --- Moderación ---
  final int reportsReceived;
  final String? banReason;
  final String? adminNotes;

  // --- Metadatos ---
  final DateTime createdAt;
  final DateTime lastLoginAt;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.username,
    required this.email,
    this.phone,
    required this.profileImageUrl,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.totalRentsAsRenter = 0,
    this.totalRentsAsOwner = 0,
    this.wallet = const {'available': 0.0, 'pending': 0.0},
    this.status = 'active',
    this.role = 'user',
    this.verificationStatus = VerificationStatus.notVerified,
    this.reportsReceived = 0,
    this.banReason,
    this.adminNotes,
    required this.createdAt,
    required this.lastLoginAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      userId: id,
      fullName: map['fullName'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      profileImageUrl: map['profileImageUrl'] ?? 'https://via.placeholder.com/150',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: map['totalReviews'] as int? ?? 0,
      totalRentsAsRenter: map['totalRentsAsRenter'] as int? ?? 0,
      totalRentsAsOwner: map['totalRentsAsOwner'] as int? ?? 0,
      wallet: (map['wallet'] as Map<String, dynamic>? ?? {'available': 0.0, 'pending': 0.0})
          .map((key, value) => MapEntry(key, (value as num).toDouble())),
      status: map['status'] ?? 'active',
      role: map['role'] ?? 'user',
      verificationStatus: VerificationStatus.values.firstWhere(
            (e) => e.name == map['verificationStatus'],
        orElse: () => VerificationStatus.notVerified,
      ),
      reportsReceived: map['reportsReceived'] as int? ?? 0,
      banReason: map['banReason'],
      adminNotes: map['adminNotes'],
      createdAt: (map['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
      lastLoginAt: (map['lastLoginAt'] as Timestamp? ?? Timestamp.now()).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'username': username,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'rating': rating,
      'totalReviews': totalReviews,
      'totalRentsAsRenter': totalRentsAsRenter,
      'totalRentsAsOwner': totalRentsAsOwner,
      'wallet': wallet,
      'status': status,
      'role': role,
      'verificationStatus': verificationStatus.name,
      'reportsReceived': reportsReceived,
      'banReason': banReason,
      'adminNotes': adminNotes,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
    };
  }
}