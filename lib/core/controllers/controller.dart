// ARCHIVO: lib/core/controllers/app_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:rentyapp/features/auth/models/user_model.dart';
import 'package:rentyapp/features/rentals/models/rental_model.dart';
import 'package:rentyapp/features/auth/services/auth_service.dart';
import 'package:rentyapp/features/rentals/services/rental_services.dart';
import 'package:rentyapp/features/notifications/service/notification_service.dart';

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

  String _userErrorMessage = '';
  String get userErrorMessage => _userErrorMessage;

  String _rentalsErrorMessage = '';
  String get rentalsErrorMessage => _rentalsErrorMessage;

  // Estados de carga (ViewState)
  ViewState _userState = ViewState.loading;
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

  Future<void> _onAuthStateChanged(auth.User? firebaseUser) async {
    if (firebaseUser != null) {
      await fetchCurrentUser(uid: firebaseUser.uid);
    } else {
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

  // --- MÉTODOS DE DATOS ---
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
        await fetchUserRentals();
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
      await fetchCurrentUser();
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

  // --- NAVEGACIÓN DE LA UI Y ESTADO TRANSITORIO ---

  // Estado para la barra de navegación principal
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  // <<<--- CAMBIO: Estado para guardar el filtro inicial al navegar ---<<<
  Map<String, dynamic>? _initialSearchFilter;
  Map<String, dynamic>? get initialSearchFilter => _initialSearchFilter;

  /// Cambia la pestaña activa en la barra de navegación.
  void setSelectedIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  /// <<<--- CAMBIO: Guarda un filtro para que la SearchScreen lo use al iniciar ---<<<
  ///
  /// Este método guarda el filtro pero NO notifica a los listeners.
  /// La idea es que la SearchScreen lo lea una sola vez cuando se construya.
  void setInitialSearchFilter(Map<String, dynamic> filter) {
    _initialSearchFilter = filter;
  }

  /// <<<--- CAMBIO: Limpia el filtro inicial después de que ha sido usado ---<<<
  ///
  /// Esto previene que el filtro se aplique de nuevo si el usuario
  /// navega a otra pestaña y luego regresa a la de búsqueda.
  void clearInitialSearchFilter() {
    _initialSearchFilter = null;
  }


  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}