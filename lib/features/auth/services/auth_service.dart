import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart'; // Asegúrate que la ruta sea correcta

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- OBTENER ESTADO DE AUTENTICACIÓN ---

  /// Stream para escuchar los cambios de estado del usuario (login/logout).
  /// Es la forma recomendada de gestionar el estado de la sesión en la UI.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Obtener el UID del usuario actual de forma síncrona.
  String? get currentUserId => _auth.currentUser?.uid;

  // --- LOGIN ---
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      if (user == null) return null;

      // Obtener los datos del usuario de Firestore y actualizar 'lastLoginAt'
      final userDocRef = _db.collection('users').doc(user.uid);
      final snapshot = await userDocRef.get();

      if (snapshot.exists) {
        // Actualiza la fecha del último login de forma asíncrona (no bloquea el retorno)
        userDocRef.update({'lastLoginAt': FieldValue.serverTimestamp()});

        // CORRECCIÓN: Pasamos el 'map' y el 'id' al constructor fromMap
        return UserModel.fromMap(snapshot.data()!, snapshot.id);
      } else {
        print('❌ Usuario autenticado pero no encontrado en Firestore. UID: ${user.uid}');
        return null;
      }
    } on FirebaseAuthException catch (e) {
      // Manejo de errores específicos de Firebase Auth
      print("❌ Error de Firebase Auth al iniciar sesión: ${e.message} (Código: ${e.code})");
      // Aquí podrías lanzar una excepción personalizada para mostrarla en la UI
      // throw SignInException.fromCode(e.code);
      return null;
    } catch (e) {
      print("❌ Error inesperado al iniciar sesión: $e");
      return null;
    }
  }

  // --- REGISTRO ---
  Future<UserModel?> register({
    required String email,
    required String password,
    required String fullName,
    required String username,
    String? phone,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user == null) return null;

      final now = DateTime.now();

      // CORRECCIÓN COMPLETA: Usamos el nuevo UserModel profesional
      final userModel = UserModel(
        userId: user.uid,
        fullName: fullName,
        username: username.toLowerCase(), // Guardar en minúsculas para búsquedas
        email: email,
        phone: phone,
        profileImageUrl: 'https://via.placeholder.com/150/771796', // URL de placeholder por defecto
        role: 'user',
        status: 'active',
        verificationStatus: VerificationStatus.notVerified,
        rating: 0.0, // Inicializado como double
        totalReviews: 0,
        totalRentsAsRenter: 0,
        totalRentsAsOwner: 0,
        wallet: {'available': 0.0, 'pending': 0.0}, // Billetera inicializada
        reportsReceived: 0,
        createdAt: now,
        lastLoginAt: now,
      );

      // Guardar el nuevo usuario en Firestore
      await _db.collection('users').doc(user.uid).set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (e) {
      print("❌ Error de Firebase Auth al registrar: ${e.message} (Código: ${e.code})");
      // throw RegisterException.fromCode(e.code);
      return null;
    } catch (e) {
      print("❌ Error inesperado al registrar: $e");
      return null;
    }
  }

  // --- LOGOUT ---
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("❌ Error al cerrar sesión: $e");
    }
  }

  // --- BORRADO DE CUENTA ---
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No hay un usuario autenticado para borrar.');

      // ¡IMPORTANTE! Este es el paso más crítico.
      // La mejor práctica es NO borrar desde el cliente, sino llamar a una Cloud Function.
      // La función se encargaría de borrar el documento y todas sus sub-colecciones.
      // Aquí simulamos el borrado del documento principal para el flujo del cliente.
      await _db.collection('users').doc(user.uid).delete();

      // Este es el último paso, borrar el usuario de Firebase Authentication
      await user.delete();
    } on FirebaseAuthException catch (e) {
      // Si la sesión es muy antigua, puede requerir re-autenticación.
      if (e.code == 'requires-recent-login') {
        print("🔒 El borrado de cuenta requiere re-autenticación.");
        // Aquí deberías pedir al usuario que vuelva a iniciar sesión.
      } else {
        print("❌ Error de Firebase Auth al borrar cuenta: ${e.message}");
      }
      rethrow; // Propaga la excepción para que la UI pueda manejarla
    } catch (e) {
      print("❌ Error inesperado al borrar cuenta: $e");
      rethrow;
    }
  }
  /// Obtiene los datos de un usuario desde Firestore.
  Future<UserModel?> getUserData(String uid) async {
    try {
      final snapshot = await _db.collection('users').doc(uid).get();
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data()!, snapshot.id);
      }
      return null;
    } catch (e) {
      print("❌ Error al obtener datos de usuario: $e");
      return null;
    }
  }

  /// Actualiza el perfil de un usuario.
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(uid).update(data);
    } catch (e) {
      print("❌ Error al actualizar perfil: $e");
      rethrow;
    }
  }
}