// lib/features/add_product/widgets/product_details_step.dart
import 'package:flutter/material.dart';

class ProductDetailsStep extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String condition;
  final void Function(String?) onConditionChanged;

  const ProductDetailsStep({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.condition,
    required this.onConditionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          // TRADUCCIÓN:
          'Detalles del Producto',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          // TRADUCCIÓN:
          'Un buen título y descripción atraen a más arrendatarios.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF999999), fontSize: 14),
        ),
        const SizedBox(height: 24),

        TextField(
          controller: titleController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            // TRADUCCIÓN:
            labelText: 'Título del Producto',
            filled: true,
            fillColor: Color(0xFF1A1A1A),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            labelStyle: TextStyle(color: Color(0xFF999999)),
          ),
        ),
        const SizedBox(height: 16),

        TextField(
          controller: descriptionController,
          style: const TextStyle(color: Colors.white),
          maxLines: 4,
          decoration: const InputDecoration(
            // TRADUCCIÓN:
            labelText: 'Descripción',
            alignLabelWithHint: true,
            filled: true,
            fillColor: Color(0xFF1A1A1A),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            labelStyle: TextStyle(color: Color(0xFF999999)),
          ),
        ),
        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          value: condition,
          onChanged: onConditionChanged,
          dropdownColor: const Color(0xFF1A1A1A),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            // TRADUCCIÓN:
            labelText: 'Condición',
            labelStyle: TextStyle(color: Color(0xFF999999)),
            filled: true,
            fillColor: Color(0xFF1A1A1A),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
          items: const [
            // TRADUCCIÓN:
            DropdownMenuItem(value: 'new', child: Text('Nuevo')),
            DropdownMenuItem(value: 'used', child: Text('Usado - Como nuevo')),
            DropdownMenuItem(value: 'used-good', child: Text('Usado - Buen estado')),
            DropdownMenuItem(value: 'used-fair', child: Text('Usado - Aceptable')),
          ],
        ),
      ],
    );
  }
}