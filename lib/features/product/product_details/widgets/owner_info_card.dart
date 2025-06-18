import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';
import 'section_card.dart';

/// Una tarjeta que busca y muestra la información del dueño del producto.
class OwnerInfoCard extends StatefulWidget {
  final String ownerId;

  const OwnerInfoCard({Key? key, required this.ownerId}) : super(key: key);

  @override
  State<OwnerInfoCard> createState() => _OwnerInfoCardState();
}

class _OwnerInfoCardState extends State<OwnerInfoCard> {
  late final Future<UserModel?> _ownerFuture;

  @override
  void initState() {
    super.initState();
    _ownerFuture = _fetchOwnerDetails(widget.ownerId);
  }

  Future<UserModel?> _fetchOwnerDetails(String ownerId) async {
    if (ownerId.isEmpty) return null;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(ownerId).get();
      return doc.exists ? UserModel.fromMap(doc.data()!) : null;
    } catch (e) {
      debugPrint('Error fetching owner details: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: _ownerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (!snapshot.hasData) {
          return const Text('Owner information could not be loaded.', style: TextStyle(color: AppColors.error));
        }

        final owner = snapshot.data!;
        final ownerInitials = owner.fullName.isNotEmpty ? owner.fullName[0].toUpperCase() : '?';

        return SectionCard(
          title: 'Owner Information',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: owner.profileImageUrl.isNotEmpty ? NetworkImage(owner.profileImageUrl) : null,
                    backgroundColor: Colors.deepPurple,
                    child: owner.profileImageUrl.isEmpty
                        ? Text(ownerInitials, style: const TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold))
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(owner.fullName, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(
                          '${owner.rating.toDouble().toStringAsFixed(1)} (${owner.totalRentsReceived} reviews)',
                          style: TextStyle(color: AppColors.white.withOpacity(0.7), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  if (owner.verified) const Icon(Icons.verified, color: AppColors.primary, size: 24),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Usually responds within 1 hour\n${owner.verified ? "Verified owner" : "Owner not verified"}',
                style: TextStyle(color: AppColors.white.withOpacity(0.5), fontSize: 12, fontStyle: FontStyle.italic, height: 1.4),
              ),
            ],
          ),
        );
      },
    );
  }
}