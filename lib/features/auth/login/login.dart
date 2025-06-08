import 'package:flutter/material.dart';
import 'package:rentyapp/features/auth/services/auth_service.dart';
import 'package:rentyapp/features/auth/login/widgets/login_header.dart';
import 'package:rentyapp/features/auth/login/widgets/login_input.dart';
import 'package:rentyapp/features/auth/login/widgets/login_social_button.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;
  bool loading = false;
  String? error;

  void _login() async {
    FocusScope.of(context).unfocus();

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() => error = 'Por favor completa todos los campos');
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    final user = await AuthService().signIn(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (user != null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/landing');
      }
    } else {
      setState(() {
        error = 'Correo o contraseña inválidos';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              const Text('Email Address', style: AppTextStyles.inputHint),
              LoginInput(controller: emailController, hint: 'Enter your email'),
              const SizedBox(height: 24),
              const Text('Password', style: AppTextStyles.inputHint),
              LoginInput(controller: passwordController, hint: 'Enter your password', obscure: true),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (v) => setState(() => rememberMe = v ?? false),
                    side: const BorderSide(color: AppColors.hint),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    checkColor: Colors.black,
                    activeColor: AppColors.white,
                  ),
                  const Text('Remember me', style: AppTextStyles.inputHint),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Forgot Password?', style: AppTextStyles.bannerAction),
                  )
                ],
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(error!, style: AppTextStyles.errorText),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: loading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: loading
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
