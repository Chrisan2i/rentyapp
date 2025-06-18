import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';

class RenterProfileDialog extends StatelessWidget {
  final UserModel renter;
  final VoidCallback onAccept;

  const RenterProfileDialog({Key? key, required this.renter, required this.onAccept}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            CircleAvatar(radius: 30, child: Text(renter.fullName[0], style: TextStyle(fontSize: 24))),
            const SizedBox(height: 12),
            Text(renter.fullName, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              '${renter.rating.toStringAsFixed(1)} rating • ${renter.totalRentsReceived} completed rentals',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            _buildInfoSection(
              title: 'Verification Status',
              child: Row(
                children: [
                  Icon(Icons.verified_user, color: renter.verified ? Colors.green : Colors.grey, size: 18),
                  const SizedBox(width: 8),
                  Text(renter.verified ? 'Identity Verified' : 'Not Verified', style: TextStyle(color: renter.verified ? Colors.green : Colors.grey, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoSection(
              title: 'Recent Reviews',
              child: Text(
                '"Very communicative and responsible. Would rent to again!"', // Placeholder
                style: TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    child: const Text('Accept Request'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}