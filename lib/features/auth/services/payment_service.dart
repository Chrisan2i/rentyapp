import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentyapp/features/auth/models/payment_method.dart'; // Asegúrate que la ruta sea correcta

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Obtiene el método de pago por defecto de un usuario.
  /// Devuelve null si no se encuentra ninguno.
  Future<PaymentMethodModel?> getDefaultPaymentMethod(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('paymentMethods')
          .where('isDefault', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return PaymentMethodModel.fromMap(doc.data(), doc.id);
      }

      return null; // No se encontró un método por defecto
    } catch (e) {
      print("Error fetching default payment method: $e");
      // Puedes propagar el error si quieres manejarlo en la UI
      throw Exception("Could not get payment method.");
    }
  }
}