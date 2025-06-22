// lib/features/auth/register/register_page.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/auth/login/widgets/custom_text_form_field.dart';
import 'package:rentyapp/features/auth/login/widgets/login_social_button.dart';
import 'package:rentyapp/features/auth/register/register_controller.dart';
import 'package:rentyapp/features/auth/register/widgets/register_header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _termsAccepted = false;
  late final RegisterController _registerController;

  @override
  void initState() {
    super.initState();
    _registerController = context.read<RegisterController>();
    _registerController.addListener(_onRegisterStateChanged);
  }

  void _onRegisterStateChanged() {
    if (!mounted) return;
    if (_registerController.state == RegisterState.success) {
      // AuthWrapper en main.dart se encargará de la navegación.
    }
  }

  @override
  void dispose() {
    _registerController.removeListener(_onRegisterStateChanged);
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitRegister() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must accept the Terms of Service and Privacy Policy.')),
      );
      return;
    }

    _registerController.register(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      fullName: _fullNameController.text.trim(),
      username: _usernameController.text.trim(),
      phone: _phoneController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RegisterController>();
    final isLoading = controller.state == RegisterState.loading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const RegisterHeader(),
                const SizedBox(height: 32),
                CustomTextFormField(controller: _fullNameController, labelText: 'Full Name', hintText: 'Your full name', validator: (v) => v!.isEmpty ? 'Full name is required' : null),
                const SizedBox(height: 16),
                CustomTextFormField(controller: _usernameController, labelText: 'Username (Optional)', hintText: 'Choose a username'),
                const SizedBox(height: 16),
                CustomTextFormField(controller: _emailController, labelText: 'Email Address', hintText: 'Enter your email', validator: (v) => (v!.isEmpty || !v.contains('@')) ? 'A valid email is required' : null),
                const SizedBox(height: 16),
                CustomTextFormField(controller: _phoneController, labelText: 'Phone Number', hintText: '(+58) 123 456 7890'),
                const SizedBox(height: 16),
                CustomTextFormField(controller: _passwordController, labelText: 'Password', hintText: 'Create a password', isPassword: true, validator: (v) => v!.length < 6 ? 'Password must be at least 6 characters' : null),
                const SizedBox(height: 16),
                CustomTextFormField(controller: _confirmPasswordController, labelText: 'Confirm Password', hintText: 'Repeat password', isPassword: true, validator: (v) => v != _passwordController.text ? 'Passwords do not match' : null),
                const SizedBox(height: 24),
                Row(
                  children: [
                    SizedBox(height: 24, width: 24, child: Checkbox(value: _termsAccepted, onChanged: (val) => setState(() => _termsAccepted = val!))),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.subtitle,
                          children: [
                            const TextSpan(text: 'I accept the '),
                            TextSpan(text: 'Terms of Service', style: AppTextStyles.bannerAction, recognizer: TapGestureRecognizer()..onTap = () => print('Open ToS')),
                            const TextSpan(text: ' and '),
                            TextSpan(text: 'Privacy Policy', style: AppTextStyles.bannerAction, recognizer: TapGestureRecognizer()..onTap = () => print('Open Privacy Policy')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (controller.state == RegisterState.error)
                  Padding(padding: const EdgeInsets.only(bottom: 16.0), child: Center(child: Text(controller.errorMessage!, style: AppTextStyles.errorText))),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submitRegister,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, disabledBackgroundColor: AppColors.primary.withOpacity(0.5)),
                    child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Sign Up', style: AppTextStyles.button),
                  ),
                ),
                const SizedBox(height: 32),
                Row(children: [const Expanded(child: Divider(color: AppColors.white10)), Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('or continue with', style: AppTextStyles.subtitle)), const Expanded(child: Divider(color: AppColors.white10))]),
                const SizedBox(height: 24),
                Row(
                  children: [
                    // <<<--- ¡AQUÍ ESTÁ LA CORRECCIÓN! ---<<<
                    // La ruta ahora incluye la carpeta 'images' que creamos.
                    Expanded(child: LoginSocialButton(label: 'Google', icon: Image.asset('assets/google_logo.png', height: 22), onTap: () {})),
                    const SizedBox(width: 16),
                    Expanded(child: LoginSocialButton(label: 'Apple', icon: const FaIcon(FontAwesomeIcons.apple, color: Colors.white, size: 26), onTap: () {})),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(color: AppColors.white10), borderRadius: BorderRadius.circular(8)),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.lock_outline, color: AppColors.textSecondary, size: 16), SizedBox(width: 8), Text('Your information is encrypted and protected', style: AppTextStyles.subtitle)]),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ", style: AppTextStyles.subtitle),
                    InkWell(onTap: () => Navigator.pop(context), child: const Text('Log in', style: AppTextStyles.bannerAction)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}