import 'package:flutter/material.dart';
import '../../models/rental_model.dart';

class RentalDetailsCard extends StatelessWidget {
  final RentalModel rental;

  const RentalDetailsCard({super.key, required this.rental});

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    return name.split(' ').map((e) => e[0]).take(2).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final owner = rental.ownerInfo;
    final pickupLocation = rental.productInfo['pickupLocation'] ?? {};

    return _InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rental Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(backgroundColor: Colors.deepPurple, child: Text(_getInitials(owner['fullName'] ?? ''), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('You are renting from', style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
                  Text(owner['fullName'] ?? 'Mike Johnson', style: const TextStyle(fontSize: 16, color: Colors.white)),
                ],
              ),
              const Spacer(),
              TextButton(onPressed: () {}, child: const Text('View Profile'))
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey.shade800.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pickup Location', style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
                const SizedBox(height: 4),
                Text(pickupLocation['name'] ?? 'Downtown Photography Studio', style: const TextStyle(fontSize: 16, color: Colors.white)),
                const SizedBox(height: 2),
                Text(pickupLocation['address'] ?? '123 Main St, San Francisco, CA', style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Re-usa el widget _InfoCard definido en el archivo anterior o muévelo a su propio archivo.
class _InfoCard extends StatelessWidget {
  final Widget child;
  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
      child: child,
    );
  }
}