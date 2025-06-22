// lib/features/auth/login/login_controller.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';
import 'package:rentyapp/features/auth/services/auth_service.dart';

enum LoginState {
  idle,
  loading,
  error,
  success,
}

class LoginController with ChangeNotifier {
  final AuthService _authService;

  LoginController({required AuthService authService}) : _authService = authService;

  LoginState _state = LoginState.idle;
  String? _errorMessage;
  UserModel? _loggedInUser;

  LoginState get state => _state;
  String? get errorMessage => _errorMessage;
  UserModel? get loggedInUser => _loggedInUser;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    // La validación de campos vacíos ahora se maneja 100% en el Form de la LoginPage.
    // El controlador asume que recibe datos válidos de la UI.

    _updateState(LoginState.loading);

    try {
      final userModel = await _authService.signIn(
        email: email, // No es necesario .trim() aquí si ya se hace en la LoginPage
        password: password,
      );

      if (userModel != null) {
        // Lógica de negocio: Comprobar el estado del usuario.
        if (userModel.status == 'active') {
          _loggedInUser = userModel;
          _updateState(LoginState.success);
        } else {
          // El usuario existe pero su cuenta no está activa.
          _updateState(LoginState.error, 'Tu cuenta está ${userModel.status}. Contacta a soporte.');
        }
      } else {
        // El AuthService devolvió null, lo que significa credenciales inválidas.
        _updateState(LoginState.error, 'Email o contraseña inválidos.');
      }
    } catch (e) {
      // Capturar cualquier otro error inesperado (ej. problemas de red).
      _updateState(LoginState.error, 'Ocurrió un error inesperado. Inténtalo de nuevo.');
      debugPrint("❌ Error capturado en LoginController: $e");
    }
  }

  /// Método privado para centralizar las actualizaciones de estado.
  void _updateState(LoginState newState, [String? message]) {
    _state = newState;
    _errorMessage = message;
    notifyListeners();
  }
}