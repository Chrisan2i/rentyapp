import 'package:firebase_auth/firebase_auth.dart'; // Para obtener el ID del usuario actual
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/product/models/product_model.dart';
import 'package:rentyapp/features/send_rental_request/models/rental_request_model.dart';
import '../rentals/services/rental_services.dart';

class SendRentalRequestView extends StatefulWidget {
  final ProductModel product;

  const SendRentalRequestView({Key? key, required this.product}) : super(key: key);

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

  // --- Lógica de Cálculo de Precios ---
  int get _daysRequested =>
      _endDate != null && _startDate != null
          ? _endDate!.difference(_startDate!).inDays + 1
          : 0;

  double get _pricePerDay => widget.product.rentalPrices['day'] ?? 0.0;

  double get _subtotal => _daysRequested * _pricePerDay;
  static const double VAT_RATE = 0.16; // 16% de IVA
  double get _vat => _subtotal * VAT_RATE;

  double get _total => _subtotal + _vat;

  /// Muestra el selector de fechas y actualiza el estado.
  Future<void> _pickDateRange() async {
    final newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select the rental dates.'),
            backgroundColor: AppColors.error),
      );
      return;
    }

    // ¡IMPORTANTE! Asume que tienes un usuario logueado con Firebase Auth.
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You must be logged in to make a request.'),
            backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => _isLoading = true);

    final request = RentalRequestModel(
      requestId: '',
      // Firestore generará el ID
      productId: widget.product.productId,
      ownerId: widget.product.ownerId,
      renterId: currentUser.uid,
      startDate: Timestamp.fromDate(_startDate!),
      endDate: Timestamp.fromDate(_endDate!),
      daysRequested: _daysRequested,
      message: _messageController.text,
      paymentMethod: 'Credit Card',
      // Placeholder, esto debería ser seleccionable
      status: 'pending',
      createdAt: Timestamp.now(),
      pricePerDay: _pricePerDay,
      subtotal: _subtotal,
      vat: _vat,
      total: _total,
    );

    final success = await _rentalService.createRentalRequest(request);

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rental request sent successfully!'),
            backgroundColor: Colors.green),
      );
      Navigator.of(context).pop(); // Vuelve a la pantalla de detalles
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to send request. Please try again.'),
            backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Rental Request'),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You are requesting to rent:', style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 16)),
              const SizedBox(height: 8),
              Text(widget.product.title, style: TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              // --- Sección de Fechas ---
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.calendar_today, color: AppColors.primary),
                title: Text('Rental Dates', style: TextStyle(
                    color: AppColors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(
                  _startDate == null
                      ? 'Select start and end dates'
                      : '${_startDate!.toLocal().toString().split(
                      ' ')[0]} - ${_endDate!.toLocal().toString().split(
                      ' ')[0]}',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                onTap: _pickDateRange,
              ),
              const Divider(color: AppColors.surface),

              // --- Sección de Resumen de Pago ---
              if (_daysRequested > 0) ...[
                const SizedBox(height: 16),
                Text('Price Summary', style: TextStyle(color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildPriceRow(
                    'Price per day:', '\$${_pricePerDay.toStringAsFixed(2)}'),
                _buildPriceRow('Number of days:', '$_daysRequested'),
                _buildPriceRow(
                    'Subtotal:', '\$${_subtotal.toStringAsFixed(2)}'),
                _buildPriceRow('VAT (16%):', '\$${_vat.toStringAsFixed(2)}'),
                const Divider(color: AppColors.surface, height: 24),
                _buildPriceRow(
                    'Total:', '\$${_total.toStringAsFixed(2)}', isTotal: true),
                const SizedBox(height: 24),
              ],

              // --- Sección de Mensaje ---
              TextFormField(
                controller: _messageController,
                style: TextStyle(color: AppColors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Message to the owner (optional)',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  hintText: 'e.g., "I need it for a weekend project."',
                  hintStyle: TextStyle(color: AppColors.hint),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Send Rental Request', style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
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