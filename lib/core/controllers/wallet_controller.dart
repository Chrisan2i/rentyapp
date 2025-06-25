// lib/features/earnings/controllers/wallet_controller.dart (o donde lo tengas)

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rentyapp/features/auth/models/payment_method.dart';
import 'package:rentyapp/features/auth/models/payout_destination_model.dart';
import 'package:rentyapp/features/auth/models/transaction_model.dart';

// --- ESTADO DE LA VISTA (View State) ---
// Usar un enum para el estado hace el código más legible y menos propenso a errores.
enum WalletState { initial, loading, loaded, error }

class WalletController with ChangeNotifier {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;
  String? _userId;

  // --- ESTADO DEL CONTROLADOR ---
  WalletState _state = WalletState.initial;
  WalletState get state => _state;

  bool _isAddingPaymentMethod = false;
  bool get isAddingPaymentMethod => _isAddingPaymentMethod;

  String? _error;
  String? get error => _error;

  // --- DATOS DE LA BILLETERA ---
  List<PaymentMethodModel> paymentMethods = [];
  List<PayoutDestinationModel> payoutMethods = [];
  List<TransactionModel> transactions = [];
  Map<String, double> walletStats = {};

  WalletController({FirebaseAuth? auth, FirebaseFirestore? db})
      : _auth = auth ?? FirebaseAuth.instance,
        _db = db ?? FirebaseFirestore.instance {
    initialize();
  }

  void initialize() {
    // Escucha los cambios de autenticación. Si el usuario cambia, se recargan los datos.
    _auth.authStateChanges().listen((user) {
      if (user != null && user.uid != _userId) {
        _userId = user.uid;
        fetchWalletData();
      } else if (user == null) {
        _resetState();
      }
    });

    // Carga inicial si ya hay un usuario logueado al crear el controller.
    if (_auth.currentUser != null) {
      _userId = _auth.currentUser!.uid;
      fetchWalletData();
    }
  }

  /// Carga o recarga todos los datos de la billetera del usuario.
  Future<void> fetchWalletData() async {
    if (_userId == null) {
      _setError("Usuario no autenticado.");
      return;
    }

    _setState(WalletState.loading);

    try {
      // Usamos Future.wait para ejecutar todas las cargas en paralelo. Es más eficiente.
      final results = await Future.wait([
        _fetchUserTransactions(),
        _fetchWalletStats(),
        _fetchPaymentMethods(),
        _fetchPayoutMethods(),
      ]);

      // Asignamos los resultados a nuestras variables de estado.
      transactions = results[0] as List<TransactionModel>;
      walletStats = results[1] as Map<String, double>;
      paymentMethods = results[2] as List<PaymentMethodModel>;
      payoutMethods = results[3] as List<PayoutDestinationModel>;

      _setError(null); // Limpiamos cualquier error previo
      _setState(WalletState.loaded);

    } catch (e) {
      debugPrint("❌ Error al cargar datos de la billetera: $e");
      _setError("No se pudieron cargar los datos de la billetera. Inténtalo de nuevo.");
      _setState(WalletState.error);
    }
  }

  // --- MÉTODOS PRIVADOS DE OBTENCIÓN DE DATOS (DATA FETCHING) ---
  // Ahora devuelven Futures, perfectos para Future.wait

  Future<List<TransactionModel>> _fetchUserTransactions() async {
    final snapshot = await _db
        .collection('users').doc(_userId).collection('transactions')
        .orderBy('createdAt', descending: true).limit(20).get();
    return snapshot.docs.map((doc) => TransactionModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<Map<String, double>> _fetchWalletStats() async {
    final userDoc = await _db.collection('users').doc(_userId).get();
    if (!userDoc.exists) return {};
    final data = userDoc.data()!;
    return {
      'paid': (data['totalPaid'] as num? ?? 0.0).toDouble(),
      'pending': (data['pendingBalance'] as num? ?? 0.0).toDouble(),
      'withdrawn': (data['totalWithdrawn'] as num? ?? 0.0).toDouble(),
      'available': (data['availableBalance'] as num? ?? 0.0).toDouble(),
    };
  }

  Future<List<PayoutDestinationModel>> _fetchPayoutMethods() async {
    final snapshot = await _db
        .collection('users').doc(_userId).collection('payoutDestinations').get();
    return snapshot.docs.map((doc) => PayoutDestinationModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<List<PaymentMethodModel>> _fetchPaymentMethods() async {
    final snapshot = await _db
        .collection('users').doc(_userId).collection('paymentMethods').get();
    return snapshot.docs.map((doc) => PaymentMethodModel.fromMap(doc.data(), doc.id)).toList();
  }

  /// Agrega un nuevo método de pago.
  Future<bool> addPaymentMethod({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String cardHolderName,
  }) async {
    if (_userId == null) {
      _setError("Operación no permitida. Usuario no autenticado.");
      return false;
    }

    _isAddingPaymentMethod = true;
    notifyListeners();
    _setError(null);

    try {
      // ... tu lógica para crear `newMethod` es correcta ...
      String brand = 'unknown';
      if (cardNumber.startsWith('4')) brand = 'visa';
      else if (RegExp(r'^5[1-5]').hasMatch(cardNumber)) brand = 'mastercard';
      else if (RegExp(r'^3[47]').hasMatch(cardNumber)) brand = 'amex';

      final last4 = cardNumber.substring(cardNumber.length - 4);
      final newMethod = PaymentMethodModel(
        paymentMethodId: '',
        alias: '${brand.toUpperCase()} **** $last4',
        type: 'card',
        isDefault: paymentMethods.isEmpty,
        providerDetails: {'last4': last4, 'brand': brand, 'cardHolderName': cardHolderName},
      );

      final docRef = await _db.collection('users').doc(_userId)
          .collection('paymentMethods').add(newMethod.toMap());

      // Actualizamos la lista local y notificamos.
      paymentMethods.add(PaymentMethodModel.fromMap(newMethod.toMap(), docRef.id));

      notifyListeners();
      return true;

    } catch (e) {
      debugPrint("❌ Error al agregar método de pago: $e");
      _setError("Ocurrió un error al agregar el método de pago.");
      notifyListeners();
      return false;
    } finally {
      _isAddingPaymentMethod = false;
      notifyListeners();
    }
  }

  // --- MANEJO DE ESTADO INTERNO ---

  void _setState(WalletState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  void _setError(String? message) {
    if (_error != message) {
      _error = message;
      // No notificamos aquí, se hará con el cambio de estado general
    }
  }

  /// Resetea el estado cuando el usuario cierra sesión.
  void _resetState() {
    _userId = null;
    paymentMethods.clear();
    payoutMethods.clear();
    transactions.clear();
    walletStats.clear();
    _error = null;
    _state = WalletState.initial;
    notifyListeners();
  }
}