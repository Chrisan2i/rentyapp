import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';

class Controller with ChangeNotifier {
  int notificationCount = 1;
  UserModel? currentUser;
  bool isLoading = true;

  Controller() {
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
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
        currentUser = UserModel.fromMap(userDoc.data()!); // 👈 Asegúrate de tener fromMap
      } else {
        print('⚠️ Usuario no encontrado en Firestore.');
      }
    } catch (e) {
      print('❌ Error al cargar usuario: $e');
    }

    isLoading = false;
    notifyListeners();
  }
  Future<void> updateUserProfile(Map<String, dynamic> newData) async {
    if (currentUser == null) return;

    try {
      final userId = currentUser!.userId;

      // 🔄 Actualiza Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update(newData);

      // ✅ Actualiza localmente el modelo
      currentUser = UserModel(
        userId: userId,
        fullName: newData['fullName'] ?? currentUser!.fullName,
        username: newData['username'] ?? currentUser!.username,
        email: currentUser!.email,
        phone: newData['phone'] ?? currentUser!.phone,
        profileImageUrl: newData['profileImageUrl'] ?? currentUser!.profileImageUrl,
        role: currentUser!.role,
        createdAt: currentUser!.createdAt,
        lastLoginAt: currentUser!.lastLoginAt,
        rating: currentUser!.rating,
        totalRentsMade: currentUser!.totalRentsMade,
        totalRentsReceived: currentUser!.totalRentsReceived,
        blocked: currentUser!.blocked,
        banReason: currentUser!.banReason,
        reports: currentUser!.reports,
        notesByAdmin: currentUser!.notesByAdmin,
        verified: currentUser!.verified,
        address: currentUser!.address,
        identityVerification: currentUser!.identityVerification,
        preferences: currentUser!.preferences,
        paymentMethods: currentUser!.paymentMethods,
      );

      notifyListeners();
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
