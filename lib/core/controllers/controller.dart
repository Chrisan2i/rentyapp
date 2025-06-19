// ARCHIVO: lib/core/controllers/controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth; // Importante para el tipo 'User'
import 'package:rentyapp/features/auth/models/user_model.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';
import 'package:rentyapp/features/auth/services/auth_service.dart';
import 'package:rentyapp/features/rentals/services/rental_services.dart';
import 'package:rentyapp/models/notification_service.dart';

enum ViewState { idle, loading, error }

/// Controlador principal de la aplicación. Orquesta los servicios y gestiona el estado global.
class AppController with ChangeNotifier {
  // --- DEPENDENCIAS ---
  final AuthService _authService;
  final RentalService _rentalService;
  final NotificationService _notificationService;

  // --- ESTADO INTERNO ---
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  List<RentalModel> _rentals = [];
  List<RentalModel> get rentals => _rentals;

  ViewState _userState = ViewState.idle;
  ViewState get userState => _userState;

  ViewState _rentalsState = ViewState.idle;
  ViewState get rentalsState => _rentalsState;

  StreamSubscription<auth.User?>? _authSubscription;

  // --- CONSTRUCTOR E INICIALIZACIÓN ---
  AppController({
    required AuthService authService,
    required RentalService rentalService,
    required NotificationService notificationService,
  })  : _authService = authService,
        _rentalService = rentalService,
        _notificationService = notificationService {
    _initialize();
  }

  void _initialize() {
    _authSubscription?.cancel();
    _authSubscription = _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  /// Se ejecuta cuando el estado de autenticación del usuario cambia.
  Future<void> _onAuthStateChanged(auth.User? firebaseUser) async {
    if (firebaseUser != null) {
      // Si el usuario de Firebase existe, usamos su UID para cargar nuestros datos.
      await loadCurrentUser(firebaseUser.uid);
    } else {
      // Si es nulo, el usuario ha cerrado sesión.
      _clearUserState();
    }
  }

  void _clearUserState() {
    _currentUser = null;
    _rentals = [];
    _userState = ViewState.idle;
    _rentalsState = ViewState.idle;
    notifyListeners();
  }

  // --- STREAMS ---
  Stream<int> get pendingRequestsCountStream =>
      _currentUser != null ? _rentalService.getPendingRentalRequestsCount(_currentUser!.userId) : Stream.value(0);

  Stream<int> get unreadNotificationsCountStream =>
      _currentUser != null ? _notificationService.getUnreadNotificationsCount(_currentUser!.userId) : Stream.value(0);

  // --- MÉTODOS ---
  Future<void> loadCurrentUser(String uid) async {
    _setLoadingState(user: ViewState.loading);
    try {
      _currentUser = await _authService.getUserData(uid);
      if (_currentUser != null) {
        await loadUserRentals();
        _setLoadingState(user: ViewState.idle);
      } else {
        _setLoadingState(user: ViewState.error);
      }
    } catch (e) {
      debugPrint('❌ Error al cargar datos del usuario: $e');
      _setLoadingState(user: ViewState.error);
    }
  }

  Future<void> loadUserRentals() async {
    if (_currentUser == null) return;
    _setLoadingState(rentals: ViewState.loading);
    try {
      _rentals = await _rentalService.getRentalsForUser(_currentUser!.userId);
      _setLoadingState(rentals: ViewState.idle);
    } catch (e) {
      debugPrint('❌ Error al cargar alquileres del usuario: $e');
      _setLoadingState(rentals: ViewState.error);
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> newData) async {
    if (_currentUser == null) throw Exception("Usuario no autenticado.");
    try {
      await _authService.updateUserProfile(_currentUser!.userId, newData);
      await loadCurrentUser(_currentUser!.userId);
    } catch (e) {
      debugPrint('❌ Error al actualizar perfil: $e');
      rethrow;
    }
  }

  Future<void> clearAllNotifications() async {
    if (_currentUser == null) return;
    try {
      await _notificationService.markAllAsRead(_currentUser!.userId);
    } catch (e) {
      debugPrint("❌ Error al limpiar notificaciones: $e");
    }
  }

  void _setLoadingState({ViewState? user, ViewState? rentals}) {
    bool needsNotify = false;
    if (user != null && _userState != user) {
      _userState = user;
      needsNotify = true;
    }
    if (rentals != null && _rentalsState != rentals) {
      _rentalsState = rentals;
      needsNotify = true;
    }
    if (needsNotify) {
      notifyListeners();
    }
  }

  // --- UI ---
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}