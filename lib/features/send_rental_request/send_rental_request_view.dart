// lib/features/send_rental_request/send_rental_request_view.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/product/models/product_model.dart'; // Asegúrate que esta ruta sea correcta
import 'package:rentyapp/features/rentals/services/rental_services.dart';
import 'package:rentyapp/features/send_rental_request/models/rental_request_model.dart';

class SendRentalRequestView extends StatefulWidget {
  final ProductModel product;

  // --- CORRECCIÓN 1: Super parameter ---
  const SendRentalRequestView({super.key, required this.product});

  @override
  State<SendRentalRequestView> createState() => _SendRentalRequestViewState();
}

class _SendRentalRequestViewState extends State<SendRentalRequestView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  final RentalService _rentalService = RentalService();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  // --- Lógica de Cálculo de Precios (Corregida y Mejorada) ---
  int get _daysRequested =>
      _endDate != null && _startDate != null
          ? _endDate!.difference(_startDate!).inDays + 1
          : 0;

  // --- CORRECCIÓN 2: Manejo de precio nulo ---
  // Esta función ahora devuelve un double no nulo.
  // Usamos el `displayPrice` que es más robusto, y si no hay precio, es 0.0.
  double get _pricePerDay => widget.product.rentalPrices.displayPrice;

  double get _subtotal => _daysRequested * _pricePerDay;

  // --- CORRECCIÓN 3: Estilo de la constante ---
  static const double vatRate = 0.16; // 16% de IVA, ahora en lowerCamelCase
  double get _vat => _subtotal * vatRate;

  double get _total => _subtotal + _vat;

  /// Muestra el selector de fechas y actualiza el estado.
  Future<void> _pickDateRange() async {
    // ... tu código aquí no necesita cambios, está perfecto ...
    final now = DateTime.now();
    final newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
    );

    if (newDateRange != null) {
      setState(() {
        _startDate = newDateRange.start;
        _endDate = newDateRange.end;
      });
    }
  }

  /// Valida y envía la solicitud de alquiler.
  Future<void> _submitRequest() async {
    // ... tu código aquí no necesita cambios, está perfecto ...
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select the rental dates.'),
            backgroundColor: AppColors.error),
      );
      return;
    }

    // --- MEJORA: Validar si hay un precio válido antes de enviar ---
    if (_pricePerDay <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This item does not have a valid price and cannot be rented.'),
            backgroundColor: AppColors.error),
      );
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // ...
      return;
    }

    setState(() => _isLoading = true);

    final request = RentalRequestModel(
      requestId: '', // El ID se generará en el servicio, pasamos uno vacío por ahora.
      productId: widget.product.productId,
      ownerId: widget.product.ownerId,
      renterId: currentUser.uid,
      status: 'pending', // Estado inicial de la solicitud.
      startDate: _startDate!, // Usamos '!' porque ya comprobamos que no es nulo.
      endDate: _endDate!,   // Igual aquí.
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 24)), // La solicitud expira en 24h.
      messageToOwner: _messageController.text,
      financials: {
        'pricePerDay': _pricePerDay,
        'daysRequested': _daysRequested.toDouble(),
        'subtotal': _subtotal,
        'vat': _vat,
        'total': _total,
      },
    );

    try {
      await _rentalService.createRentalRequest(request);
      if (mounted) {
        // ...
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        // ...
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... El resto de tu método build está perfecto y no necesita cambios.
    // Solo asegúrate de que usas `vatRate` en lugar de `VAT_RATE` si lo mencionas en el build,
    // pero como usas el getter `_vat`, no hay problema.
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Rental Request'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You are requesting to rent:', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
              const SizedBox(height: 8),
              Text(widget.product.title, style: const TextStyle(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              // --- Sección de Fechas ---
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today, color: AppColors.primary),
                title: const Text('Rental Dates', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(
                  _startDate == null ? 'Select start and end dates' : '${_startDate!.toLocal().toString().split(' ')[0]} - ${_endDate!.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                onTap: _pickDateRange,
              ),
              const Divider(color: AppColors.surface),

              // --- Sección de Resumen de Pago ---
              if (_daysRequested > 0) ...[
                const SizedBox(height: 16),
                const Text('Price Summary', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildPriceRow('Price per day:', '\$${_pricePerDay.toStringAsFixed(2)}'),
                _buildPriceRow('Number of days:', '$_daysRequested'),
                _buildPriceRow('Subtotal:', '\$${_subtotal.toStringAsFixed(2)}'),
                _buildPriceRow('VAT (16%):', '\$${_vat.toStringAsFixed(2)}'),
                const Divider(color: AppColors.surface, height: 24),
                _buildPriceRow('Total:', '\$${_total.toStringAsFixed(2)}', isTotal: true),
                const SizedBox(height: 24),
              ],

              // --- Sección de Mensaje ---
              TextFormField(
                controller: _messageController,
                style: const TextStyle(color: AppColors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Message to the owner (optional)',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  hintText: 'e.g., "I need it for a weekend project."',
                  hintStyle: const TextStyle(color: AppColors.hint),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 32),

              // --- Botón de Envío ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                      : const Text('Send Rental Request', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    final style = TextStyle(
      color: isTotal ? AppColors.white : AppColors.textSecondary,
      fontSize: isTotal ? 18 : 16,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}