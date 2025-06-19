// register_page.dart
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/auth/services/auth_service.dart';
import 'widgets/register_header.dart';
import 'widgets/register_input_field.dart';
import 'widgets/register_footer.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _loading = false;
  String? _error;

  void _register() async {
    if (_password.text != _confirm.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final user = await AuthService().register(
      email: _email.text.trim(),
      password: _password.text.trim(),
      fullName: _name.text.trim(),
      username: _username.text.trim(),
      phone: _phone.text.trim(),
    );

    if (user != null) {
      print("✅ Registro exitoso: ${user.email}");
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _error = "Error al crear la cuenta";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const RegisterHeader(),
              const SizedBox(height: 30),

              RegisterInputField(label: 'Full Name', controller: _name, hint: 'Your full name'),
              const SizedBox(height: 16),
              RegisterInputField(label: 'Username (Optional)', controller: _username, hint: 'Choose a username'),
              const SizedBox(height: 16),
              RegisterInputField(label: 'Email Address', controller: _email, hint: 'Enter your email'),
              const SizedBox(height: 16),
              RegisterInputField(label: 'Phone Number', controller: _phone, hint: '(+58) 123 456 7890'),
              const SizedBox(height: 16),
              RegisterInputField(label: 'Password', controller: _password, hint: 'Create a password', obscure: true),
              const SizedBox(height: 16),
              RegisterInputField(label: 'Confirm Password', controller: _confirm, hint: 'Repeat password', obscure: true),
              const SizedBox(height: 20),

              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_error!, style: AppTextStyles.errorText),
                ),

              RegisterFooter(
                isLoading: _loading,
                onRegister: _register,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
