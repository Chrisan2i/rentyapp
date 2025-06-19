// lib/models/user/identity_verification_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart'; // Asegúrate que la ruta sea correcta

enum VerificationRequestStatus { pending, approved, rejected }

class IdentityVerificationModel {
  final String verificationId;
  final VerificationStatus requestedLevel;
  final VerificationRequestStatus status;

  final String idFrontImageUrl;
  final String idSelfieImageUrl;
  final String? residenceProofUrl;

  final String? rejectionReason;
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final String? reviewedBy; // Admin ID

  IdentityVerificationModel({
    required this.verificationId,
    required this.requestedLevel,
    required this.status,
    required this.idFrontImageUrl,
    required this.idSelfieImageUrl,
    this.residenceProofUrl,
    this.rejectionReason,
    required this.submittedAt,
    this.reviewedAt,
    this.reviewedBy,
  });

  factory IdentityVerificationModel.fromMap(Map<String, dynamic> map, String id) {
    return IdentityVerificationModel(
      verificationId: id,
      requestedLevel: VerificationStatus.values.firstWhere(
            (e) => e.name == map['requestedLevel'],
        orElse: () => VerificationStatus.notVerified,
      ),
      status: VerificationRequestStatus.values.firstWhere(
            (e) => e.name == map['status'],
        orElse: () => VerificationRequestStatus.pending,
      ),
      idFrontImageUrl: map['idFrontImageUrl'] ?? '',
      idSelfieImageUrl: map['idSelfieImageUrl'] ?? '',
      residenceProofUrl: map['residenceProofUrl'],
      rejectionReason: map['rejectionReason'],
      submittedAt: (map['submittedAt'] as Timestamp).toDate(),
      reviewedAt: (map['reviewedAt'] as Timestamp?)?.toDate(),
      reviewedBy: map['reviewedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requestedLevel': requestedLevel.name,
      'status': status.name,
      'idFrontImageUrl': idFrontImageUrl,
      'idSelfieImageUrl': idSelfieImageUrl,
      'residenceProofUrl': residenceProofUrl,
      'rejectionReason': rejectionReason,
      'submittedAt': submittedAt,
      'reviewedAt': reviewedAt,
      'reviewedBy': reviewedBy,
    };
  }
}