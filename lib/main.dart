// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// ✨ PASO 1: Importa el paquete de internacionalización.
import 'package:intl/date_symbol_data_local.dart';

import 'package:rentyapp/features/landing/landing.dart';
import 'core/theme/app_colors.dart';
import 'core/controllers/wallet_controller.dart';
import 'features/product/services/product_services.dart';
import 'firebase_options.dart';
import 'core/theme/theme.dart';
import 'core/controllers/controller.dart'; // AppController
import 'features/auth/login/login_controller.dart';
import 'features/auth/login/login.dart';
import 'features/auth/register/sign_up.dart';
import 'features/auth/services/auth_service.dart';
import 'features/rentals/services/rental_services.dart';
import 'features/notifications/service/notification_service.dart';
import 'core/widgets/main_navigation.dart';
import 'features/rentals/rental_request/rental_requests_view.dart';
import 'package:rentyapp/features/auth/register/register_controller.dart';
import 'package:rentyapp/core/splash/splash_screen.dart';

// ✨ PASO 2: Convierte tu función main en async.
Future<void> main() async {
  // Asegúrate de que los bindings de Flutter estén listos.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase como lo tenías.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✨ PASO 3: Inicializa los datos de formato para el idioma español.
  // Esta línea es la solución al error.
  await initializeDateFormatting('es_ES', null);

  // Tu manejo de errores global (se mantiene igual, está perfecto).
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      debugPrint('❌ FlutterError: ${details.exception}');
    }
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      debugPrint('🔥 Unhandled platform error: $error');
    }
    return true;
  };

  // Lanza tu aplicación con los providers.
  runApp(const MyAppWithProviders());
}

class MyAppWithProviders extends StatelessWidget {
  const MyAppWithProviders({super.key});

  @override
  Widget build(BuildContext context) {
    // Tu estructura de providers está bien, no necesita cambios.
    return MultiProvider(
      providers: [
        // --- SECCIÓN 1: SERVICIOS INDEPENDIENTES ---
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<ProductService>(create: (_) => ProductService()),
        Provider<NotificationService>(create: (_) => NotificationService()),

        // --- SECCIÓN 2: SERVICIOS DEPENDIENTES (PROXY PROVIDERS) ---
        ProxyProvider<NotificationService, RentalService>(
          update: (_, notificationService, __) =>
              RentalService(notificationService: notificationService),
        ),

        // --- SECCIÓN 3: CONTROLADORES (CHANGENOTIFIERS) ---
        ChangeNotifierProvider<AppController>(
          create: (context) => AppController(
            authService: context.read<AuthService>(),
            rentalService: context.read<RentalService>(),
            notificationService: context.read<NotificationService>(),
          ),
        ),
        ChangeNotifierProvider<LoginController>(
          create: (context) => LoginController(
            authService: context.read<AuthService>(),
          ),
        ),
        ChangeNotifierProvider<RegisterController>(
          create: (context) => RegisterController(
            authService: context.read<AuthService>(),
          ),
        ),
        ChangeNotifierProvider<WalletController>(
          create: (_) => WalletController(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // El MaterialApp y las rutas se mantienen igual.
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
    // El AuthWrapper se mantiene igual.
    return StreamBuilder<User?>(
      stream: context.read<AuthService>().authStateChanges,
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