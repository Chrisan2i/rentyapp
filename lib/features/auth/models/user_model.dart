import 'package:cloud_firestore/cloud_firestore.dart';
import 'address_model.dart';
import 'identity_verification.dart';
import 'user_preferences.dart';
import 'payment_method.dart'; // Asegúrate de importar esto

class UserModel {
  final String userId;
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String profileImageUrl;
  final String role;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  final int rating;
  final int totalRentsMade;
  final int totalRentsReceived;

  final bool blocked;
  final String? banReason;
  final int reports;
  final String? notesByAdmin;

  final bool verified;
  final AddressModel? address;
  final IdentityVerification? identityVerification;
  final UserPreferences? preferences;
  final Map<String, Map<String, dynamic>> paymentMethods;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
    required this.role,
    required this.createdAt,
    required this.lastLoginAt,
    required this.rating,
    required this.totalRentsMade,
    required this.totalRentsReceived,
    required this.blocked,
    this.banReason,
    required this.reports,
    this.notesByAdmin,
    this.verified = false,
    this.address,
    this.identityVerification,
    this.preferences,
    this.paymentMethods = const {},
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      fullName: map['fullName'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      role: map['role'] ?? 'user',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastLoginAt: (map['lastLoginAt'] as Timestamp).toDate(),
      rating: map['rating'] ?? 0,
      totalRentsMade: map['totalRentsMade'] ?? 0,
      totalRentsReceived: map['totalRentsReceived'] ?? 0,
      blocked: map['blocked'] ?? false,
      banReason: map['banReason'],
      reports: map['reports'] ?? 0,
      notesByAdmin: map['notesByAdmin'],
      verified: map['verified'] ?? false,
      address: map['address'] != null ? AddressModel.fromMap(map['address']) : null,
      identityVerification: map['identityVerification'] != null
          ? IdentityVerification.fromMap(map['identityVerification'])
          : null,
      preferences: map['preferences'] != null
          ? UserPreferences.fromMap(map['preferences'])
          : null,
      paymentMethods: map['paymentMethods'] != null
          ? Map<String, Map<String, dynamic>>.from(
          (map['paymentMethods'] as Map).map((key, value) =>
              MapEntry(key.toString(), Map<String, dynamic>.from(value))))
          : {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'username': username,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'role': role,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
      'rating': rating,
      'totalRentsMade': totalRentsMade,
      'totalRentsReceived': totalRentsReceived,
      'blocked': blocked,
      'banReason': banReason,
      'reports': reports,
      'notesByAdmin': notesByAdmin,
      'verified': verified,
      'address': address?.toMap(),
      'preferences': preferences?.toMap(),
      'paymentMethods': paymentMethods,
      // ⚠️ identityVerification se guarda por separado
    };
  }
}