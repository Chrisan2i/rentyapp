// lib/features/auth/register/register_controller.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';
import 'package:rentyapp/features/auth/services/auth_service.dart';

enum RegisterState { idle, loading, error, success }

class RegisterController with ChangeNotifier {
  final AuthService _authService;

  RegisterController({required AuthService authService}) : _authService = authService;

  RegisterState _state = RegisterState.idle;
  String? _errorMessage;
  UserModel? _registeredUser;

  RegisterState get state => _state;
  String? get errorMessage => _errorMessage;
  UserModel? get registeredUser => _registeredUser;

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String username,
    String? phone,
  }) async {
    _updateState(RegisterState.loading);

    try {
      final user = await _authService.register(
        email: email,
        password: password,
        fullName: fullName,
        username: username,
        phone: phone,
      );

      if (user != null) {
        _registeredUser = user;
        _updateState(RegisterState.success);
      } else {
        // El servicio puede devolver null si, por ejemplo, el email ya está en uso.
        _updateState(RegisterState.error, 'Could not create account. The email might already be in use.');
      }
    } catch (e) {
      _updateState(RegisterState.error, 'An unexpected error occurred. Please try again.');
      debugPrint("❌ Error in RegisterController: $e");
    }
  }

  void _updateState(RegisterState newState, [String? message]) {
    _state = newState;
    _errorMessage = message;
    notifyListeners();
  }
}