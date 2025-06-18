// main.dart

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'package:rentyapp/core/theme/theme.dart';
import 'package:rentyapp/core/controllers/controller.dart';
import 'package:rentyapp/features/auth/login/login.dart';
import 'package:rentyapp/core/widgets/main_navigation.dart';
import 'package:rentyapp/features/auth/register/sign_up.dart';
import 'package:rentyapp/features/rental_request/rental_requests_view.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Captura de errores (esto está muy bien)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('❌ FlutterError: ${details.exception}');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    print('🔥 Unhandled error: $error');
    return true;
  };

  runApp(
    ChangeNotifierProvider(
      create: (_) => Controller(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Renty',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => const LoginPage(),
        '/landing': (context) => const MainNavigation(),
        '/register': (context) => const RegisterPage(),

        // --- RUTA AÑADIDA ---
        // Esta es la nueva ruta que permitirá la navegación desde el perfil.
        '/rent-requests': (context) => const RentalRequestsView(),
        // --------------------

        // Aquí podrías añadir las otras rutas que necesites en el futuro:
        // '/my-listings': (context) => const MyListingsView(),
        // '/favorites': (context) => const FavoritesView(),
        // '/verification': (context) => const VerificationView(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Usuario autenticado
        if (snapshot.hasData) {
          return const MainNavigation();
        }

        // Usuario no autenticado
        return const LoginPage();
      },
    );
  }
}