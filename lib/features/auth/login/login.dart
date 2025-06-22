// lib/features/auth/login/login_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/auth/login/login_controller.dart';
import 'package:rentyapp/features/auth/login/widgets/custom_text_form_field.dart';
import 'package:rentyapp/features/auth/login/widgets/login_header.dart';
import 'package:rentyapp/features/auth/login/widgets/login_social_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'widgets/login_social_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  // 1. Declaramos la variable para guardar la instancia del controlador.
  late final LoginController _loginController;

  @override
  void initState() {
    super.initState();
    // 2. En initState, obtenemos la instancia del controlador UNA SOLA VEZ
    //    y la guardamos en nuestra variable.
    _loginController = context.read<LoginController>();
    //    Añadimos el listener a nuestra variable guardada, no a una nueva instancia.
    _loginController.addListener(_onLoginStateChanged);
  }

  void _onLoginStateChanged() {
    // La guarda de seguridad es la primera línea, como debe ser.
    if (!mounted) return;

    // 3. ¡CORRECCIÓN CLAVE! Ya NO usamos 'context.read()' aquí.
    //    Usamos la variable _loginController que ya tenemos. Esto es seguro.
    if (_loginController.state == LoginState.success) {
      // AuthWrapper en main.dart se encarga de la navegación.
      // No necesitamos hacer nada aquí.
    }
  }

  @override
  void dispose() {
    // 4. ¡CORRECCIÓN CLAVE! Ya NO usamos 'context.read()' aquí.
    //    Quitamos el listener de la variable _loginController que ya tenemos.
    //    Esto es 100% seguro y nunca causará un error.
    _loginController.removeListener(_onLoginStateChanged);

    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      // Aquí está bien usar context.read() porque es una acción directa del usuario
      // y la página está garantizada a estar montada.
      context.read<LoginController>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Es correcto usar 'context.watch()' en el método build para que la UI
    // se reconstruya cuando el estado del controlador cambie.
    final controller = context.watch<LoginController>();
    final isLoading = controller.state == LoginState.loading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const LoginHeader(),
                const SizedBox(height: 40),

                CustomTextFormField(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'Enter your email',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Please enter your email';
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return 'Please enter a valid email address';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your password';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(height: 24, width: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) => setState(() => _rememberMe = value!),
                            activeColor: AppColors.primary,
                            checkColor: AppColors.white,
                            side: const BorderSide(color: AppColors.textSecondary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Remember me', style: AppTextStyles.subtitle),
                      ],
                    ),
                    TextButton(
                      onPressed: () { /* TODO: Implementar */ },
                      child: const Text('Forgot password?', style: AppTextStyles.bannerAction),
                    ),
                  ],
                ),
                if (controller.state == LoginState.error)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: Center(
                      child: Text(
                        controller.errorMessage ?? 'Ocurrió un error',
                        style: AppTextStyles.errorText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submitLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: AppColors.white)
                        : const Text('Log In', style: AppTextStyles.loginButton),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.white10)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('or continue with', style: AppTextStyles.subtitle),
                    ),
                    const Expanded(child: Divider(color: AppColors.white10)),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: LoginSocialButton(
                        label: 'Google',
                        icon: Image.asset('assets/google_logo.png', height: 20), // Asumiendo que tienes este asset
                        onTap: () { /* TODO: Implementar */ },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: LoginSocialButton(
                        label: 'Facebook',
                        icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.white, size: 22),
                        onTap: () { /* TODO: Implementar */ },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? ", style: AppTextStyles.subtitle),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/register'),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: const Text('Sign Up', style: AppTextStyles.bannerAction),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}