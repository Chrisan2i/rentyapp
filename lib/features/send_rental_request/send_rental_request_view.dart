// lib/features/send_rental_request/send_rental_request_view.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <<<--- AÑADIR IMPORT DE PROVIDER
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/product/models/product_model.dart';
import 'package:rentyapp/features/rentals/services/rental_services.dart';
import 'package:rentyapp/features/send_rental_request/models/rental_request_model.dart';

class SendRentalRequestView extends StatefulWidget {
  final ProductModel product;

  const SendRentalRequestView({super.key, required this.product});

  @override
  State<SendRentalRequestView> createState() => _SendRentalRequestViewState();
}

class _SendRentalRequestViewState extends State<SendRentalRequestView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();

  // <<<--- CORRECCIÓN: Elimina la creación de una nueva instancia aquí ---<<<
  // final RentalService _rentalService = RentalService(); // ESTO CAUSA EL ERROR

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  // ... El resto de tus getters (_daysRequested, _pricePerDay, etc.) no cambian ...
  int get _daysRequested => _endDate != null && _startDate != null ? _endDate!.difference(_startDate!).inDays + 1 : 0;
  double get _pricePerDay => widget.product.rentalPrices.displayPrice;
  double get _subtotal => _daysRequested * _pricePerDay;
  static const double vatRate = 0.16;
  double get _vat => _subtotal * vatRate;
  double get _total => _subtotal + _vat;

  Future<void> _pickDateRange() async {
    // ... tu código no cambia ...
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

  Future<void> _submitRequest() async {
    // ... tu código de validación no cambia ...
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    // <<<--- CORRECCIÓN: Obtén la instancia del servicio desde Provider ---<<<
    final rentalService = context.read<RentalService>();

    setState(() => _isLoading = true);

    final request = RentalRequestModel(
      requestId: '',
      productId: widget.product.productId,
      ownerId: widget.product.ownerId,
      renterId: currentUser.uid,
      status: 'pending',
      startDate: _startDate!,
      endDate: _endDate!,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
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
      await rentalService.createRentalRequest(
        request: request,
        renterName: currentUser.displayName ?? 'A user',
        productTitle: widget.product.title,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Request sent successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending request: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
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