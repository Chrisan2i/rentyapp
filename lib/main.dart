// lib/main.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';


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

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('❌ FlutterError: ${details.exception}');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('🔥 Unhandled platform error: $error');
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<ProductService>(create: (_) => ProductService()),
        Provider<RentalService>(create: (_) => RentalService()),
        Provider<NotificationService>(create: (_) => NotificationService()),
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
      ],
      child: MaterialApp(
        title: 'Renty',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/landing': (context) => const MainNavigation(),
          '/register': (context) => const RegisterPage(),
          '/rent-requests': (context) => const RentalRequestsView(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // Ya no necesitamos la suscripción aquí, porque el AppController
  // ahora maneja su propia lógica de escucha interna.
  // Esto simplifica el AuthWrapper.

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: context.read<AuthService>().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // --- CORREGIDO: Se quita 'const' y se usan los colores importados ---
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