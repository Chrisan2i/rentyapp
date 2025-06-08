import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PricingAvailabilityStep extends StatelessWidget {
  final Map<String, bool> selectedRates;
  final Map<String, TextEditingController> rateControllers;
  final TextEditingController depositController;
  final List<DateTime> availableDates;
  final bool instantBooking;
  final VoidCallback onToggleInstantBooking;
  final Function(DateTime) onToggleDate;
  final Function(String) onRateTypeToggle;

  const PricingAvailabilityStep({
    super.key,
    required this.selectedRates,
    required this.rateControllers,
    required this.depositController,
    required this.availableDates,
    required this.instantBooking,
    required this.onToggleInstantBooking,
    required this.onToggleDate,
    required this.onRateTypeToggle,
  });

  bool isSelected(DateTime date) {
    return availableDates.any((d) =>
    d.year == date.year && d.month == date.month && d.day == date.day);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = List.generate(14, (i) => now.add(Duration(days: i)));

    final rateTypes = {
      'day': 'Per Day',
      'hour': 'Per Hour',
      'week': 'Per Week',
      'month': 'Per Month',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pricing & Availability',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          const Text('Choose Pricing Options',
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),

          Column(
            children: rateTypes.entries.map((entry) {
              final key = entry.key;
              final label = entry.value;
              final selected = selectedRates[key] ?? false;

              return Row(
                children: [
                  Checkbox(
                    value: selected,
                    onChanged: (_) => onRateTypeToggle(key),
                    checkColor: Colors.white,
                    activeColor: const Color(0xFF0085FF),
                  ),
                  Expanded(
                    child: Text(label, style: const TextStyle(color: Colors.white)),
                  ),
                  if (selected)
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: rateControllers[key],
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '\$',
                          hintStyle: const TextStyle(color: Color(0xFF999999)),
                          filled: true,
                          fillColor: const Color(0xFF1A1A1A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                ],
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: depositController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Security Deposit',
              labelStyle: TextStyle(color: Color(0xFF999999)),
              filled: true,
              fillColor: Color(0xFF1A1A1A),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              prefixText: '\$ ',
              prefixStyle: TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(height: 24),

          const Text('Availability',
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: days.map((date) {
              final selected = isSelected(date);
              return GestureDetector(
                onTap: () => onToggleDate(date),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF0085FF) : const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    DateFormat('MMM d').format(date),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Enable Instant Booking',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              Switch(
                value: instantBooking,
                onChanged: (_) => onToggleInstantBooking(),
                activeColor: const Color(0xFF0085FF),
              )
            ],
          ),
        ],
      ),
    );
  }
}
