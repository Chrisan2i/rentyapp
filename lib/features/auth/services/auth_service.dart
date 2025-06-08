import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Login
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = result.user?.uid;
      if (uid == null) return null;

      final snapshot = await _db.collection('users').doc(uid).get();
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data()!);
      } else {
        print('❌ Usuario no encontrado en Firestore');
        return null;
      }
    } catch (e) {
      print("❌ Error al iniciar sesión: $e");
      return null;
    }
  }

  // Registro
  Future<UserModel?> register({
    required String email,
    required String password,
    required String fullName,
    required String username,
    required String phone,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user == null) return null;

      final now = DateTime.now();

      final userModel = UserModel(
        userId: user.uid,
        fullName: fullName,
        username: username,
        email: email,
        phone: phone,
        profileImageUrl: '',
        role: 'user',
        createdAt: now,
        lastLoginAt: now,
        rating: 0,
        totalRentsMade: 0,
        totalRentsReceived: 0,
        blocked: false,
        reports: 0,
        verified: false,
        paymentMethods: const {},
      );

      await _db.collection('users').doc(user.uid).set(userModel.toMap());
      return userModel;
    } catch (e) {
      print("❌ Error al registrar usuario: $e");
      return null;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
  //Delete Account
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');

    // Borrar datos en Firestore
    await _db.collection('users').doc(user.uid).delete();

    // Borrar cuenta en Firebase Auth
    await user.delete();
  }


  // Obtener el usuario actual como stream
  Stream<User?> get firebaseUser => _auth.authStateChanges();
}

