// lib/features/auth/login/login_controller.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/features/auth/services/auth_service.dart';
import 'package:rentyapp/features/auth/models/user_model.dart'; // Asegúrate que la ruta al modelo es correcta

// Enum para un manejo de estado claro y sin errores de tipeo.
enum LoginState {
  idle,      // Estado inicial, no ha pasado nada.
  loading,   // La operación de login está en progreso.
  error,     // Ocurrió un error.
  success,   // El login fue exitoso.
}

class LoginController with ChangeNotifier {
  final AuthService _authService;

  // El constructor requiere el AuthService (Inyección de dependencias).
  // Esto hace que el controlador sea testeable.
  LoginController({required AuthService authService}) : _authService = authService;

  // --- ESTADO PRIVADO ---
  LoginState _state = LoginState.idle;
  String? _errorMessage;
  UserModel? _loggedInUser;

  // --- GETTERS PÚBLICOS (Solo lectura para la UI) ---
  LoginState get state => _state;
  String? get errorMessage => _errorMessage;
  UserModel? get loggedInUser => _loggedInUser;

  /// Método principal que la UI llamará para iniciar el proceso de login.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    // 1. Validar campos de entrada.
    if (email.trim().isEmpty || password.trim().isEmpty) {
      _updateState(LoginState.error, 'Por favor completa todos los campos.');
      return;
    }

    // 2. Iniciar el estado de carga.
    _updateState(LoginState.loading);

    try {
      // 3. Llamar al servicio de autenticación.
      // La lógica de cómo hablar con Firebase está en el servicio, no aquí.
      final user = await _authService.signIn(
        email: email.trim(),
        password: password.trim(),
      );

      if (user != null) {
        // 4. Éxito: Guardar el modelo del usuario y actualizar el estado.
        _loggedInUser = user;
        _updateState(LoginState.success);
      } else {
        // 5. Error: Credenciales inválidas (manejado por el servicio).
        _updateState(LoginState.error, 'Correo o contraseña inválidos.');
      }
    } catch (e) {
      // 6. Error: Capturar cualquier otra excepción inesperada.
      _updateState(LoginState.error, 'Ocurrió un error inesperado. Inténtalo de nuevo.');
      print("❌ Error capturado en LoginController: $e");
    }
  }

  /// Método privado para centralizar las actualizaciones de estado y notificar a los listeners.
  void _updateState(LoginState newState, [String? message]) {
    _state = newState;
    _errorMessage = message;
    notifyListeners();
  }
}