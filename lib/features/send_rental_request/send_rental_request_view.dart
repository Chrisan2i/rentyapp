// lib/features/send_rental_request/send_rental_request_view.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/product/models/product_model.dart';
import 'package:rentyapp/features/rentals/services/rental_services.dart';
import 'package:rentyapp/features/send_rental_request/models/rental_request_model.dart';
import 'package:intl/intl.dart';

class SendRentalRequestView extends StatefulWidget {
  final ProductModel product;

  const SendRentalRequestView({super.key, required this.product});

  @override
  State<SendRentalRequestView> createState() => _SendRentalRequestViewState();
}

class _SendRentalRequestViewState extends State<SendRentalRequestView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  int get _daysRequested =>
      _endDate != null && _startDate != null ? _endDate!.difference(_startDate!).inDays + 1 : 0;

  double get _pricePerDay => widget.product.rentalPrices.perDay ?? 0.0;
  double get _subtotal => _daysRequested * _pricePerDay;
  static const double vatRate = 0.16;
  double get _vat => _subtotal * vatRate;
  double get _total => _subtotal + _vat;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        // ✅✅✅ ESTA ES LA LÍNEA CORREGIDA ✅✅✅
        // Usamos Theme.of(context) para heredar el tema existente y evitar el error de localización.
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.black,
              surface: AppColors.background,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: AppColors.surface,
          ),
          child: child!,
        );
      },
    );

    if (newDateRange != null) {
      setState(() {
        _startDate = newDateRange.start;
        _endDate = newDateRange.end;
      });
    }
  }

  Future<void> _submitRequest() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debes iniciar sesión para enviar una solicitud.'), backgroundColor: AppColors.error));
      return;
    }

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
      expiresAt: DateTime.now().add(const Duration(hours: 48)),
      messageToOwner: _messageController.text.trim(),
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
        renterName: currentUser.displayName ?? 'Un usuario',
        productTitle: widget.product.title,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ ¡Solicitud enviada con éxito!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar la solicitud: ${e.toString()}'),
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
    final formatter = DateFormat("d 'de' MMMM, yyyy", 'es_ES');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Solicitud de Renta'),
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
              Text('Estás solicitando rentar:', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
              const SizedBox(height: 8),
              Text(widget.product.title, style: const TextStyle(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today, color: AppColors.primary),
                title: const Text('Fechas de la Renta', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(
                  _startDate == null ? 'Selecciona las fechas de inicio y fin' : '${formatter.format(_startDate!)} - ${formatter.format(_endDate!)}',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                onTap: _pickDateRange,
              ),
              const Divider(color: AppColors.surface),

              if (_daysRequested > 0) ...[
                const SizedBox(height: 16),
                const Text('Resumen del Precio', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildPriceRow('Precio por día:', '\$${_pricePerDay.toStringAsFixed(2)}'),
                _buildPriceRow('Número de días:', '$_daysRequested'),
                _buildPriceRow('Subtotal:', '\$${_subtotal.toStringAsFixed(2)}'),
                _buildPriceRow('IVA (16%):', '\$${_vat.toStringAsFixed(2)}'),
                const Divider(color: AppColors.surface, height: 24),
                _buildPriceRow('Total:', '\$${_total.toStringAsFixed(2)}', isTotal: true),
                const SizedBox(height: 24),
              ],

              TextFormField(
                controller: _messageController,
                style: const TextStyle(color: AppColors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Mensaje para el propietario (opcional)',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  hintText: 'p. ej., "Lo necesito para un proyecto de fin de semana."',
                  hintStyle: const TextStyle(color: AppColors.hint),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_isLoading || _startDate == null) ? null : _submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                  ),
                  child: _isLoading
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : const Text('Enviar Solicitud de Renta', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
    final valueStyle = style.copyWith(color: AppColors.white);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}