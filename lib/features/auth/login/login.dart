  import 'package:flutter/material.dart';
  import 'package:rentyapp/features/auth/services/auth_service.dart';
  import 'package:rentyapp/features/auth/login/widgets/login_header.dart';
  import 'package:rentyapp/features/auth/login/widgets/login_input.dart';
  import 'package:rentyapp/features/auth/login/widgets/login_social_button.dart';
  import 'package:rentyapp/core/theme/app_colors.dart';
  import 'package:rentyapp/core/theme/app_text_styles.dart';
  // lib/features/auth/login/login_page.dart
  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart'; // O el gestor de estado que uses
  import 'package:rentyapp/features/auth/login/login_controller.dart';
  // ... otros imports ...

  class LoginPage extends StatefulWidget {
    const LoginPage({super.key});

    @override
    State<LoginPage> createState() => _LoginPageState();
  }

  class _LoginPageState extends State<LoginPage> {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool rememberMe = false;

    @override
    void dispose() {
      emailController.dispose();
      passwordController.dispose();
      super.dispose();
    }

    void _listenToLoginState(BuildContext context, LoginController controller) {
      if (controller.state == LoginState.success) {
        // Navegación segura al tener éxito
        Navigator.pushReplacementNamed(context, '/landing');
      }
    }

    @override
    Widget build(BuildContext context) {
      // Usamos 'watch' para que la UI se reconstruya cuando el estado cambie
      final controller = context.watch<LoginController>();

      // Usamos addPostFrameCallback para escuchar cambios de estado y navegar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _listenToLoginState(context, controller);
      });

      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LoginHeader(),
                const SizedBox(height: 40),
                // ... Widgets de texto y inputs se mantienen igual ...
                LoginInput(controller: emailController, hint: 'Enter your email'),
                const SizedBox(height: 24),
                LoginInput(controller: passwordController, hint: 'Enter your password', obscure: true),
                // ... El Row con Checkbox y Forgot Password se mantiene igual ...

                // <<<--- MEJORA: Manejo de errores desde el controlador ---<<<
                if (controller.state == LoginState.error) ...[
                  const SizedBox(height: 8),
                  Text(
                    controller.errorMessage ?? 'Ocurrió un error',
                    style: AppTextStyles.errorText,
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    // <<<--- MEJORA: Llama al método del controlador ---<<<
                    onPressed: controller.state == LoginState.loading
                        ? null
                        : () {
                      FocusScope.of(context).unfocus();
                      context.read<LoginController>().login(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    // <<<--- MEJORA: El estado de carga viene del controlador ---<<<
                    child: controller.state == LoginState.loading
                        ? const CircularProgressIndicator(color: AppColors.white)
                        : const Text('Sign In', style: AppTextStyles.loginButton),
                  ),
                ),
                const SizedBox(height: 32),
                const Center(child: Text('or continue with', style: AppTextStyles.inputHint)),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Expanded(child: LoginSocialButton(label: 'Google')),
                    SizedBox(width: 16),
                    Expanded(child: LoginSocialButton(label: 'Apple')),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.white10),
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.white10,
                  ),
                  child: const Center(
                    child: Text(
                      'Your information is encrypted and protected',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?", style: AppTextStyles.inputHint),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/register'),
                      child: const Text('Sign Up', style: AppTextStyles.bannerAction),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }
