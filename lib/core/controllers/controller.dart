// lib/core/controllers/controller.dart (o donde lo tengas)

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';
// Importa tu servicio de alquiler si aún no lo has hecho
import 'package:rentyapp/features/rentals/services/rental_services.dart'; // <-- ¡Asegúrate que la ruta es correcta!

class Controller with ChangeNotifier {
  int notificationCount = 1;
  UserModel? currentUser;
  bool isLoading = true;
  List<RentalModel> rentals = [];

  // --- NUEVA ADICIÓN: Instancia del servicio de alquiler ---
  final RentalService _rentalService = RentalService();
  // --------------------------------------------------------

  Controller() {
    loadCurrentUser();
    loadRentals();
  }

  // --- NUEVA ADICIÓN: Stream para el contador de solicitudes ---
  Stream<int> get pendingRequestsCountStream {
    // Si no hay un usuario logueado, devolvemos un stream con valor 0 para evitar errores.
    if (currentUser == null) {
      return Stream.value(0);
    }
    // Usamos el servicio para obtener el stream de conteo en tiempo real.
    return _rentalService.getPendingRentalRequestsCount(currentUser!.userId);
  }
  // -------------------------------------------------------------

  Future<void> loadCurrentUser() async {
    // Tu método se mantiene igual, está perfecto.
    try {
      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) {
        print('⚠️ No hay sesión iniciada.');
        isLoading = false;
        notifyListeners();
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(authUser.uid)
          .get();

      if (userDoc.exists) {
        currentUser = UserModel.fromMap(userDoc.data()!);
      } else {
        print('⚠️ Usuario no encontrado en Firestore.');
      }
    } catch (e) {
      print('❌ Error al cargar usuario: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadRentals() async {
    // Tu método se mantiene igual.
    try {
      final rentalQuerySnapshot = await FirebaseFirestore.instance
          .collection('rentals')
          .get();

      rentals = rentalQuerySnapshot.docs.map((doc) {
        return RentalModel.fromJson(doc.data());
      }).toList();
      notifyListeners();
    } catch (e) {
      print('❌ Error al cargar alquileres: $e');
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> newData) async {
    // Tu método se mantiene igual.
    if (currentUser == null) return;

    try {
      final userId = currentUser!.userId;
      await FirebaseFirestore.instance.collection('users').doc(userId).update(newData);

      // Recargamos el usuario desde Firestore para tener la versión más actualizada
      // Es más seguro que reconstruirlo manualmente.
      await loadCurrentUser();

    } catch (e) {
      print('❌ Error al actualizar perfil: $e');
      rethrow;
    }
  }

  void onExplorePressed(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Start Exploring tapped!')),
    );
  }

  int selectedIndex = 0;

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void clearNotifications() {
    notificationCount = 0;
    notifyListeners();
  }

  void receiveNotification() {
    notificationCount++;
    notifyListeners();
  }
}