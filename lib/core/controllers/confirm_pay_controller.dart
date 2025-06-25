// lib/features/rentals/controllers/confirm_and_pay_controller.dart

import 'package:flutter/material.dart';
import 'package:rentyapp/features/auth/models/payment_method.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';
import 'package:rentyapp/features/rentals/services/rental_services.dart';

/// Controlador dedicado para la pantalla de Confirmar y Pagar.
/// Maneja el estado, la lógica de negocio y almacena el ID de transacción.
class ConfirmAndPayController with ChangeNotifier {
  // --- DEPENDENCIAS INYECTADAS ---
  final RentalService _rentalService;
  final RentalModel rental;

  // --- ESTADO DE PAGO ---
  late PaymentMethodModel _selectedPaymentMethod;
  PaymentMethodModel get selectedPaymentMethod => _selectedPaymentMethod;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _termsAgreed = false;
  bool get termsAgreed => _termsAgreed;

  String? _error;
  String? get error => _error;

  // --- ID DE TRANSACCIÓN GENERADA ---
  late String _transactionId;
  String get transactionId => _transactionId;

  ConfirmAndPayController({
    required RentalService rentalService,
    required this.rental,
    required PaymentMethodModel initialPaymentMethod,
  })  : _rentalService = rentalService,
        _selectedPaymentMethod = initialPaymentMethod;

  /// Cambia el método de pago seleccionado.
  void updateSelectedPaymentMethod(PaymentMethodModel newMethod) {
    if (_selectedPaymentMethod.paymentMethodId != newMethod.paymentMethodId) {
      _selectedPaymentMethod = newMethod;
      notifyListeners();
    }
  }

  /// Actualiza la aceptación de términos.
  void setTermsAgreed(bool agreed) {
    if (_termsAgreed != agreed) {
      _termsAgreed = agreed;
      notifyListeners();
    }
  }

  /// Procesa el pago y confirma el alquiler.
  /// Almacena el ID de la "transacción" (aquí usamos el mismo rentalId).
  Future<bool> confirmAndPay() async {
    if (!_termsAgreed) {
      _setError("Debes aceptar los términos y condiciones.");
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      // Llamada al servicio de pago
      await _rentalService.confirmAndPayRental(rental.rentalId);

      // Usamos rentalId como ID de transacción
      _transactionId = rental.rentalId;

      _setLoading(false);
      return true;
    } catch (e) {
      debugPrint("Error en confirmAndPay: \${e.toString()}");
      _setError("Ocurrió un error al procesar el pago. Intenta de nuevo.");
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
  }
}
