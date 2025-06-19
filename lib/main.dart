// lib/main.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/features/landing/landing.dart';


import 'core/theme/app_colors.dart';
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

  // Tu manejo de errores está muy bien, lo dejamos como está.
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('❌ FlutterError: ${details.exception}');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('🔥 Unhandled platform error: $error');
    return true;
  };

  // ¡AQUÍ ESTÁ EL CAMBIO! Pasamos el MultiProvider a runApp.
  // Esto es un patrón común y limpio.
  runApp(
    MultiProvider(
      providers: [
        // --- 1. PROVIDERS DE SERVICIOS (INDEPENDIENTES) ---
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<ProductService>(create: (_) => ProductService()),
        Provider<RentalService>(create: (_) => RentalService()),
        Provider<NotificationService>(create: (_) => NotificationService()),

        // --- 2. PROVIDERS DE CONTROLADORES (DEPENDIENTES) ---
        // Usamos ProxyProvider para inyectar los servicios de forma segura.

        // ProxyProvider para AppController
        // Escucha a 3 providers (Auth, Rental, Notification) y los pasa al AppController.
        ChangeNotifierProxyProvider3<AuthService, RentalService, NotificationService, AppController>(
          create: (context) => AppController(
            authService: context.read<AuthService>(),
            rentalService: context.read<RentalService>(),
            notificationService: context.read<NotificationService>(),
          ),
          // --- CORREGIDO AQUÍ ---
          // Simplemente devolvemos el controlador anterior.
          // El '!' asegura que no es nulo, lo cual es seguro en el `update`.
          update: (context, auth, rental, notification, previousAppController) =>
          previousAppController!,
        ),

        // ProxyProvider para LoginController
        // Escucha a AuthService y lo pasa al LoginController.
        ChangeNotifierProxyProvider<AuthService, LoginController>(
          create: (context) => LoginController(authService: context.read<AuthService>()),
          // --- CORREGIDO AQUÍ ---
          update: (context, auth, previousLoginController) =>
          previousLoginController!,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// MyApp ahora no necesita el MultiProvider, es más limpio.
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
        '/home': (context) => const LandingPage (),
      },
    );
  }
}

// AuthWrapper no necesita cambios, ya está bien.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos context.watch para que el widget se reconstruya automáticamente
    // si el estado de autenticación cambia. Es más limpio que un StreamBuilder aquí.
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
          // El usuario está logueado, vamos a la navegación principal.
          return const MainNavigation();
        } else {
          // El usuario no está logueado, vamos a la página de login.
          return const LoginPage();
        }
      },
    );
  }
}

// NOTA: Para que los ProxyProviders funcionen correctamente, asegúrate de que tus
// controladores tengan métodos para actualizar sus dependencias si es necesario,
// o simplemente puedes reutilizar la instancia anterior como en el ejemplo.
// Por ejemplo, en AppController:
// void updateDependencies(AuthService newAuth, RentalService newRental, NotificationService newNotification) {
//   this.authService = newAuth;
//   this.rentalService = newRental;
//   this.notificationService = newNotification;
// }