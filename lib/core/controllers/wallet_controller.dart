// lib/features/earnings/controllers/wallet_controller.dart

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rentyapp/features/auth/models/payment_method.dart';
import 'package:rentyapp/features/auth/models/payout_destination_model.dart';
import 'package:rentyapp/features/auth/models/transaction_model.dart';

class WalletController with ChangeNotifier {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  /// ID del usuario actualmente autenticado. Es `null` si no hay sesión activa.
  String? _userId;

  // --- ESTADOS DE LA UI ---

  /// Indica si hay una operación principal en curso (ej. carga inicial).
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Indica si una operación secundaria está en curso (ej. agregar una tarjeta).
  bool _isAddingPaymentMethod = false;
  bool get isAddingPaymentMethod => _isAddingPaymentMethod;

  /// Almacena el último mensaje de error para mostrarlo en la UI.
  String? _error;
  String? get error => _error;

  // --- DATOS DE LA BILLETERA ---

  /// Lista de métodos de pago del usuario (tarjetas, etc.).
  List<PaymentMethodModel> paymentMethods = [];

  /// Lista de destinos de pago del usuario (cuentas bancarias, etc.).
  List<PayoutDestinationModel> payoutMethods = [];

  // --- FUTURES PARA FUTUREBUILDERS ---
  // Estos son ideales para partes de la UI que solo necesitan cargarse una vez.

  /// Future que resuelve la lista de transacciones del usuario.
  late Future<List<TransactionModel>> userTransactions;

  /// Future que resuelve las estadísticas de la billetera (saldos).
  late Future<Map<String, double>> walletStats;

  /// Constructor que inicializa las dependencias.
  /// Provee instancias por defecto si no se inyectan unas específicas (útil para producción).
  WalletController({FirebaseAuth? auth, FirebaseFirestore? db})
      : _auth = auth ?? FirebaseAuth.instance,
        _db = db ?? FirebaseFirestore.instance {
    // Inicializa los Futures con un valor por defecto para evitar errores antes de la carga.
    userTransactions = Future.value([]);
    walletStats = Future.value({});

    // Inicia el proceso de carga de datos.
    initialize();
  }

  /// Inicializa el controlador obteniendo el ID del usuario y cargando todos los datos asociados.
  /// Este método debe ser llamado desde la UI después de que el controlador es creado.
  void initialize() {
    _userId = _auth.currentUser?.uid;

    if (_userId == null) {
      _setError("Usuario no autenticado. Por favor, inicie sesión.");
      // Se asegura que los Futures no fallen y devuelvan valores vacíos.
      userTransactions = Future.value([]);
      walletStats = Future.value({});
      notifyListeners();
      return;
    }

    // Si el usuario está logueado, se inician las cargas de datos.
    fetchWalletData();
  }

  /// Orquesta la carga de todos los datos de la billetera.
  void fetchWalletData() {
    if (_userId == null) return;

    _setLoading(true);
    _setError(null);

    // Asigna los futures para que los FutureBuilders en la UI se reconstruyan y muestren un loader.
    userTransactions = _fetchUserTransactions();
    walletStats = _fetchWalletStats();

    // Estas cargas actualizan listas que son consumidas por `Consumer` o `Selector`.
    _fetchPaymentMethods();
    _fetchPayoutMethods();

    // Una vez que todos los futures son asignados y las cargas iniciales comienzan,
    // se puede quitar el loading principal. Los FutureBuilders manejarán su propio estado.
    _setLoading(false);
  }

  // --- MÉTODOS PRIVADOS DE OBTENCIÓN DE DATOS (DATA FETCHING) ---

  Future<List<TransactionModel>> _fetchUserTransactions() async {
    if (_userId == null) return [];
    try {
      final snapshot = await _db
          .collection('users')
          .doc(_userId)
          .collection('transactions')
          .orderBy('createdAt', descending: true)
          .limit(20)
          .get();
      return snapshot.docs
          .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint("Error al cargar transacciones: $e");
      _setError("No se pudieron cargar las transacciones.");
      return []; // Devuelve lista vacía en caso de error.
    }
  }

  Future<Map<String, double>> _fetchWalletStats() async {
    if (_userId == null) return {};
    try {
      final userDoc = await _db.collection('users').doc(_userId).get();
      if (!userDoc.exists) {
        // Si el documento del usuario no existe, devolvemos valores por defecto.
        return {'available': 0.0, 'pending': 0.0, 'withdrawn': 0.0, 'paid': 0.0};
      }
      final data = userDoc.data() as Map<String, dynamic>;

      // Extrae los valores del documento del usuario.
      // Usamos '?? 0.0' para manejar el caso en que un campo no exista en la BD.
      return {
        'paid': (data['totalPaid'] as num? ?? 0.0).toDouble(),
        'pending': (data['pendingBalance'] as num? ?? 0.0).toDouble(),
        'withdrawn': (data['totalWithdrawn'] as num? ?? 0.0).toDouble(),
        'available': (data['availableBalance'] as num? ?? 0.0).toDouble(),
      };
    } catch (e) {
      debugPrint("Error al cargar estadísticas de la billetera: $e");
      _setError("No se pudieron cargar las estadísticas de la billetera.");
      return {}; // Devuelve mapa vacío en caso de error.
    }
  }

  Future<void> _fetchPayoutMethods() async {
    if (_userId == null) return;
    try {
      final snapshot = await _db
          .collection('users')
          .doc(_userId)
          .collection('payoutDestinations')
          .get();
      payoutMethods = snapshot.docs
          .map((doc) => PayoutDestinationModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint("Error al cargar métodos de retiro: $e");
      _setError("No se pudieron cargar los métodos de retiro.");
    } finally {
      notifyListeners();
    }
  }

  Future<void> _fetchPaymentMethods() async {
    if (_userId == null) return;
    try {
      final snapshot = await _db
          .collection('users')
          .doc(_userId)
          .collection('paymentMethods')
          .get();
      paymentMethods = snapshot.docs
          .map((doc) => PaymentMethodModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint("Error al cargar métodos de pago: $e");
      _setError("No se pudieron cargar los métodos de pago.");
    } finally {
      notifyListeners();
    }
  }

  // --- MÉTODOS PÚBLICOS DE ACCIÓN ---

  /// Agrega un nuevo método de pago (tarjeta) a la cuenta del usuario.
  /// Devuelve `true` si la operación fue exitosa, `false` en caso contrario.
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

    _setSecondaryLoading(true);
    _setError(null);

    try {
      // Lógica para determinar la marca de la tarjeta (simplificada)
      String brand = 'unknown';
      if (cardNumber.startsWith('4')) {
        brand = 'visa';
      } else if (RegExp(r'^5[1-5]').hasMatch(cardNumber)) {
        brand = 'mastercard';
      } else if (RegExp(r'^3[47]').hasMatch(cardNumber)) {
        brand = 'amex';
      }

      final last4 = cardNumber.substring(cardNumber.length - 4);
      final alias = '${brand.toUpperCase()} **** $last4';

      final newMethod = PaymentMethodModel(
        paymentMethodId: '', // Firestore generará el ID
        alias: alias,
        type: 'card',
        isDefault: paymentMethods.isEmpty, // El primero es el predeterminado
        providerDetails: {
          'last4': last4,
          'brand': brand,
          'cardHolderName': cardHolderName,
          // NOTA: NUNCA guardes el CVV o la fecha de expiración completa en tu DB.
          // Esto debería ser manejado por un procesador de pagos como Stripe o Braintree.
        },
      );

      final docRef = await _db
          .collection('users')
          .doc(_userId)
          .collection('paymentMethods')
          .add(newMethod.toMap());

      // Actualizamos la lista local con el nuevo método y su ID real.
      paymentMethods.add(
          PaymentMethodModel.fromMap(newMethod.toMap(), docRef.id)
      );

      notifyListeners();
      return true; // Éxito
    } catch (e) {
      debugPrint("Error al agregar método de pago: $e");
      _setError("Ocurrió un error al agregar el método de pago.");
      return false; // Fracaso
    } finally {
      _setSecondaryLoading(false);
    }
  }

  // --- MÉTODOS PRIVADOS PARA GESTIÓN DE ESTADO INTERNO ---

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setSecondaryLoading(bool value) {
    _isAddingPaymentMethod = value;
    notifyListeners();
  }

  void _setError(String? message) {
    if (_error != message) {
      _error = message;
      notifyListeners();
    }
  }
}