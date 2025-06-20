// lib/main.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/features/landing/landing.dart';

import 'core/theme/app_colors.dart';
import 'core/controllers/wallet_controller.dart';
import 'features/product/services/product_services.dart';
import 'firebase_options.dart';
import 'core/theme/theme.dart';
import 'core/controllers/controller.dart';
import 'features/auth/login/login_controller.dart';
import 'features/auth/login/login.dart';
import 'features/auth/register/sign_up.dart';
import 'features/auth/services/auth_service.dart';
import 'features/rentals/services/rental_services.dart';
import 'models/notification_service.dart';
import 'core/widgets/main_navigation.dart';
import 'features/rental_request/rental_requests_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('❌ FlutterError: ${details.exception}');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('🔥 Unhandled platform error: $error');
    return true;
  };

  runApp(
    MultiProvider(
      providers: [
        // --- SECCIÓN 1: PROVIDERS DE SERVICIOS (SINGLETONS) ---
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<ProductService>(create: (_) => ProductService()),
        Provider<RentalService>(create: (_) => RentalService()),
        Provider<NotificationService>(create: (_) => NotificationService()),

        // --- SECCIÓN 2: PROVIDERS DE CONTROLADORES (DEPENDEN DE SERVICIOS) ---

        // AppController
        ChangeNotifierProxyProvider3<AuthService, RentalService, NotificationService, AppController>(
          create: (context) => AppController(
            authService: context.read<AuthService>(),
            rentalService: context.read<RentalService>(),
            notificationService: context.read<NotificationService>(),
          ),
          // <<<--- AQUÍ ESTÁ LA CORRECCIÓN ---<<<
          // Simplemente retornamos la instancia previa del controlador.
          // Esto soluciona el error porque ya no intentamos llamar a un método que no existe.
          update: (_, auth, rental, notification, previous) => previous!,
        ),

        // LoginController
        ChangeNotifierProxyProvider<AuthService, LoginController>(
          create: (context) => LoginController(authService: context.read<AuthService>()),
          update: (_, auth, previous) => previous!,
        ),

        // WalletController
        ChangeNotifierProvider<WalletController>(
          create: (_) => WalletController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// MyApp no necesita cambios
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Renty',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/landing': (context) => const MainNavigation(),
        '/register': (context) => const RegisterPage(),
        '/rent-requests': (context) => const RentalRequestsView(),
        '/home': (context) => const LandingPage(),
      },
    );
  }
}

// AuthWrapper no necesita cambios
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        if (snapshot.hasData) {
          return const MainNavigation();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}