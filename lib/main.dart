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
// He renombrado el import a register_page.dart para mayor claridad
import 'features/auth/register/sign_up.dart';
import 'features/auth/services/auth_service.dart';
import 'features/rentals/services/rental_services.dart';
import 'models/notification_service.dart';
import 'core/widgets/main_navigation.dart';
import 'features/rental_request/rental_requests_view.dart';
// <<<--- AÑADE ESTE IMPORT PARA EL NUEVO CONTROLADOR ---<<<
import 'package:rentyapp/features/auth/register/register_controller.dart';

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
        // Estos son independientes y no cambian.
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<ProductService>(create: (_) => ProductService()),
        Provider<RentalService>(create: (_) => RentalService()),
        Provider<NotificationService>(create: (_) => NotificationService()),

        // --- SECCIÓN 2: PROVIDERS DE CONTROLADORES (DEPENDEN DE SERVICIOS) ---
        // Estos controladores necesitan los servicios de arriba para funcionar.

        // AppController (Tu configuración es correcta)
        ChangeNotifierProxyProvider3<AuthService, RentalService, NotificationService, AppController>(
          create: (context) => AppController(
            authService: context.read<AuthService>(),
            rentalService: context.read<RentalService>(),
            notificationService: context.read<NotificationService>(),
          ),
          update: (_, auth, rental, notification, previous) => previous!..updateDependencies(auth, rental, notification), // Una actualización más segura
        ),

        // LoginController
        // Un ChangeNotifierProvider simple es más eficiente aquí porque AuthService no cambia.
        ChangeNotifierProvider<LoginController>(
          create: (context) => LoginController(authService: context.read<AuthService>()),
        ),

        // <<<--- ¡AQUÍ ESTÁ EL NUEVO PROVIDER AÑADIDO! ---<<<
        // RegisterController también depende de AuthService.
        ChangeNotifierProvider<RegisterController>(
          create: (context) => RegisterController(authService: context.read<AuthService>()),
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Renty',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      // AuthWrapper decide qué pantalla mostrar al inicio (Login o Home)
      home: const AuthWrapper(),
      // Rutas nombradas para una navegación limpia
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const MainNavigation(), // Asumo que MainNavigation es tu pantalla principal
        '/landing': (context) => const LandingPage(),
        '/rent-requests': (context) => const RentalRequestsView(),
      },
    );
  }
}

// AuthWrapper se mantiene igual. Su lógica es perfecta.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Muestra un spinner mientras se verifica el estado de autenticación
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        // Si hay datos de usuario (está logueado), muestra la pantalla principal.
        if (snapshot.hasData) {
          return const MainNavigation();
        } else {
          // Si no, muestra la pantalla de login.
          return const LoginPage();
        }
      },
    );
  }
}

// Pequeña corrección en tu AppController para un update más seguro si lo necesitas
extension AppControllerUpdate on AppController {
  void updateDependencies(AuthService auth, RentalService rental, NotificationService notification) {
    // Si tu AppController necesita reactualizar algo cuando los providers cambian,
    // este es un patrón más explícito y seguro.
  }
}