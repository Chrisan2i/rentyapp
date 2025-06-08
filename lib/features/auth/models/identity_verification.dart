import 'package:cloud_firestore/cloud_firestore.dart';

class IdentityVerification {
  final String? frontImageUrl;
  final String? backImageUrl;
  final String? selfieWithIdUrl;
  final String? residenceProofUrl;
  final String status; // under_review, approved, rejected
  final DateTime? submittedAt;
  final DateTime? verifiedAt;
  final String? verifiedBy;

  IdentityVerification({
    this.frontImageUrl,
    this.backImageUrl,
    this.selfieWithIdUrl,
    this.residenceProofUrl,
    required this.status,
    this.submittedAt,
    this.verifiedAt,
    this.verifiedBy,
  });

  factory IdentityVerification.fromMap(Map<String, dynamic> map) {
    return IdentityVerification(
      frontImageUrl: map['frontImageUrl'],
      backImageUrl: map['backImageUrl'],
      selfieWithIdUrl: map['selfieWithIdUrl'],
      residenceProofUrl: map['residenceProofUrl'],
      status: map['status'] ?? 'under_review',
      submittedAt: (map['submittedAt'] as Timestamp?)?.toDate(),
      verifiedAt: (map['verifiedAt'] as Timestamp?)?.toDate(),
      verifiedBy: map['verifiedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'frontImageUrl': frontImageUrl,
      'backImageUrl': backImageUrl,
      'selfieWithIdUrl': selfieWithIdUrl,
      'residenceProofUrl': residenceProofUrl,
      'status': status,
      'submittedAt': submittedAt,
      'verifiedAt': verifiedAt,
      'verifiedBy': verifiedBy,
    };
  }
}
