// lib/features/rentals/controllers/confirm_and_pay_controller.dart

import 'package:flutter/material.dart';
// <<<--- ASEGÚRATE DE IMPORTAR EL MODELO CORRECTO ---<<<
import 'package:rentyapp/features/auth/models/payment_method.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';
import 'package:rentyapp/features/rentals/services/rental_services.dart';

/// Controlador dedicado para la pantalla de Confirmar y Pagar.
/// Maneja el estado y la lógica de negocio, manteniendo la UI limpia.
class ConfirmAndPayController with ChangeNotifier {
  // --- DEPENDENCIAS INYECTADAS ---
  final RentalService _rentalService;
  final RentalModel rental;

  // --- ESTADO ADICIONAL PARA EL MÉTODO DE PAGO ---
  // Esta es la sección que faltaba en tu archivo.
  late PaymentMethodModel _selectedPaymentMethod;
  PaymentMethodModel get selectedPaymentMethod => _selectedPaymentMethod;

  // --- ESTADO INTERNO ---
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _termsAgreed = false;
  bool get termsAgreed => _termsAgreed;

  String? _error;
  String? get error => _error;

  // El constructor ahora acepta 'initialPaymentMethod'
  ConfirmAndPayController({
    required RentalService rentalService,
    required this.rental,
    required PaymentMethodModel initialPaymentMethod,
  })  : _rentalService = rentalService,
        _selectedPaymentMethod = initialPaymentMethod;

  /// Cambia el método de pago seleccionado y notifica a la UI.
  /// Este es el método que no se encontraba.
  void updateSelectedPaymentMethod(PaymentMethodModel newMethod) {
    if (_selectedPaymentMethod.paymentMethodId != newMethod.paymentMethodId) {
      _selectedPaymentMethod = newMethod;
      notifyListeners();
    }
  }

  /// Actualiza el estado de aceptación de los términos y notifica a los listeners.
  void setTermsAgreed(bool agreed) {
    if (_termsAgreed != agreed) {
      _termsAgreed = agreed;
      notifyListeners();
    }
  }

  /// Procesa el pago y la confirmación del alquiler.
  /// Devuelve `true` si la operación fue exitosa, `false` en caso contrario.
  Future<bool> confirmAndPay() async {
    if (!_termsAgreed) {
      _setError("Debes aceptar los términos y condiciones.");
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      // En un futuro, podrías usar el ID del método de pago aquí
      // await _rentalService.confirmAndPayRental(
      //   rentalId: rental.rentalId,
      //   paymentMethodId: _selectedPaymentMethod.paymentMethodId
      // );
      await _rentalService.confirmAndPayRental(rental.rentalId);

      _setLoading(false);
      return true; // Éxito
    } catch (e) {
      debugPrint("Error en confirmAndPay: ${e.toString()}");
      _setError("Ocurrió un error al procesar el pago. Intenta de nuevo.");
      _setLoading(false);
      return false; // Fracaso
    }
  }

  // --- Métodos privados para manejar el estado ---
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? errorMessage) {
    _error = errorMessage;
  }
}