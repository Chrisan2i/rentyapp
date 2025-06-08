import 'package:flutter/material.dart';

class ProductDetailsStep extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String condition;
  final int quantity;
  final void Function(String?) onConditionChanged;
  final void Function(int) onQuantityChanged;

  const ProductDetailsStep({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.condition,
    required this.quantity,
    required this.onConditionChanged,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Product Details',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          TextField(
            controller: titleController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Product Title',
              labelStyle: TextStyle(color: Color(0xFF999999)),
              filled: true,
              fillColor: Color(0xFF1A1A1A),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            style: const TextStyle(color: Colors.white),
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description',
              labelStyle: TextStyle(color: Color(0xFF999999)),
              filled: true,
              fillColor: Color(0xFF1A1A1A),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: condition,
                  onChanged: onConditionChanged,
                  dropdownColor: const Color(0xFF1A1A1A),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Condition',
                    labelStyle: TextStyle(color: Color(0xFF999999)),
                    filled: true,
                    fillColor: Color(0xFF1A1A1A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'new', child: Text('New')),
                    DropdownMenuItem(value: 'used', child: Text('Used')),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  initialValue: quantity.toString(),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: TextStyle(color: Color(0xFF999999)),
                    filled: true,
                    fillColor: Color(0xFF1A1A1A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                  onChanged: (val) {
                    final qty = int.tryParse(val);
                    if (qty != null) onQuantityChanged(qty);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
