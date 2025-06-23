// ARCHIVO: lib/core/controllers/app_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:rentyapp/features/auth/models/user_model.dart'; // Ajusta las rutas si es necesario
import 'package:rentyapp/features/rentals/models/rental_model.dart';
import 'package:rentyapp/features/auth/services/auth_service.dart';
import 'package:rentyapp/features/rentals/services/rental_services.dart';
import 'package:rentyapp/features/notifications/service/notification_service.dart';

// El enum ViewState no cambia, está perfecto.
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

  // --- MEJORA: Añadimos estado para los mensajes de error ---
  String _userErrorMessage = '';
  String get userErrorMessage => _userErrorMessage;

  String _rentalsErrorMessage = '';
  String get rentalsErrorMessage => _rentalsErrorMessage;

  // Estados de carga (ViewState)
  ViewState _userState = ViewState.loading; // Empieza en loading para el arranque inicial
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
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authSubscription?.cancel();
    _authSubscription = _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  /// Se ejecuta cuando el estado de autenticación del usuario cambia.
  Future<void> _onAuthStateChanged(auth.User? firebaseUser) async {
    if (firebaseUser != null) {
      // Si el usuario de Firebase existe, usamos su UID para cargar nuestros datos.
      await fetchCurrentUser(uid: firebaseUser.uid);
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

  // --- STREAMS (No necesitan cambios, están bien) ---
  Stream<int> get pendingRequestsCountStream =>
      _currentUser != null ? _rentalService.getPendingRentalRequestsCount(_currentUser!.userId) : Stream.value(0);

  Stream<int> get unreadNotificationsCountStream =>
      _currentUser != null ? _notificationService.getUnreadNotificationsCount(_currentUser!.userId) : Stream.value(0);

  // --- MÉTODOS PÚBLICOS PARA LA UI ---

  /// --- MEJORA: Método público para reintentar la carga ---
  /// Este es el método que llamará el botón "Try Again" desde la ProfileView.
  Future<void> fetchCurrentUser({String? uid}) async {
    final userId = uid ?? _currentUser?.userId;
    if (userId == null) {
      _userState = ViewState.error;
      _userErrorMessage = "User ID not available.";
      notifyListeners();
      return;
    }

    _userState = ViewState.loading;
    notifyListeners();

    try {
      _currentUser = await _authService.getUserData(userId);
      if (_currentUser != null) {
        _userState = ViewState.idle;
        await fetchUserRentals(); // Carga los alquileres después de cargar el usuario
      } else {
        throw Exception("User data not found in Firestore.");
      }
    } catch (e) {
      debugPrint('❌ Error al cargar datos del usuario: $e');
      _userState = ViewState.error;
      _userErrorMessage = "Could not load profile. Please check your connection.";
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchUserRentals() async {
    if (_currentUser == null) return;

    _rentalsState = ViewState.loading;
    notifyListeners();

    try {
      _rentals = await _rentalService.getRentalsForUser(_currentUser!.userId);
      _rentalsState = ViewState.idle;
    } catch (e) {
      debugPrint('❌ Error al cargar alquileres del usuario: $e');
      _rentalsState = ViewState.error;
      _rentalsErrorMessage = "Could not load rentals.";
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> newData) async {
    if (_currentUser == null) throw Exception("User not authenticated.");
    try {
      await _authService.updateUserProfile(_currentUser!.userId, newData);
      await fetchCurrentUser(); // Recarga los datos del usuario para reflejar los cambios
    } catch (e) {
      debugPrint('❌ Error al actualizar perfil: $e');
      rethrow; // Lanza el error para que la UI de edición de perfil pueda manejarlo
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

  // --- NAVEGACIÓN DE LA UI (No necesita cambios) ---
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