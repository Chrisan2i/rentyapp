// lib/main.dart
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
import 'package:rentyapp/features/notifications/service/notification_service.dart'; // Ruta corregida a plural 'services'
import 'core/widgets/main_navigation.dart';
import 'features/rentals/rental_request/rental_requests_view.dart';
import 'package:rentyapp/features/auth/register/register_controller.dart';
import 'package:rentyapp/core/splash/splash_screen.dart';

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
        // --- SECCIÓN 1: SERVICIOS SIN DEPENDENCIAS ---
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<ProductService>(create: (_) => ProductService()),
        Provider<NotificationService>(create: (_) => NotificationService()), // Debe estar antes que RentalService

        // --- CORRECCIÓN 1: Usar ProxyProvider para inyectar la dependencia ---
        // Esto crea RentalService usando la instancia de NotificationService ya creada.
        ProxyProvider<NotificationService, RentalService>(
          update: (context, notificationService, previous) =>
              RentalService(notificationService: notificationService),
        ),

        // --- SECCIÓN 2: CONTROLADORES (DEPENDEN DE SERVICIOS) ---
        // Tu AppController está casi bien, pero también necesita usar el RentalService del ProxyProvider.
        ChangeNotifierProxyProvider<RentalService, AppController>(
          create: (context) => AppController(
            authService: context.read<AuthService>(),
            rentalService: context.read<RentalService>(),
            notificationService: context.read<NotificationService>(),
          ),
          update: (context, rentalService, previous) => previous!..updateDependencies(
            context.read<AuthService>(),
            rentalService, // Usa la nueva instancia de rentalService
            context.read<NotificationService>(),
          ),
        ),
        ChangeNotifierProvider<LoginController>(
          create: (context) => LoginController(authService: context.read<AuthService>()),
        ),
        ChangeNotifierProvider<RegisterController>(
          create: (context) => RegisterController(authService: context.read<AuthService>()),
        ),
        ChangeNotifierProvider<WalletController>(
          create: (_) => WalletController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// ... El resto de tu main.dart (MyApp, AuthWrapper, etc.) no necesita cambios ...
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Renty',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: '/splash',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const MainNavigation(),
        '/landing': (context) => const LandingPage(),
        '/rent-requests': (context) => const RentalRequestsView(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
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

extension AppControllerUpdate on AppController {
  void updateDependencies(AuthService auth, RentalService rental, NotificationService notification) {
    // Lógica de actualización
  }
}