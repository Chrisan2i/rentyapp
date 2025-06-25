// lib/features/profile/widgets/edit_profile_form.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/controllers/controller.dart';
import 'edit_profile_avatar.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();

  File? _newProfileImage;
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final user = Provider.of<AppController>(context, listen: false).currentUser;
      if (user != null) {
        _fullNameController.text = user.fullName;
        _usernameController.text = user.username;
        _phoneController.text = user.phone ?? '';
        _isInitialized = true;
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() => _newProfileImage = File(pickedFile.path));
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final controller = Provider.of<AppController>(context, listen: false);
    final user = controller.currentUser!;

    try {
      String imageUrl = user.profileImageUrl;
      if (_newProfileImage != null) {
        // imageUrl = await controller.uploadProfileImage(_newProfileImage!);
      }
      final updatedData = {
        'fullName': _fullNameController.text.trim(),
        'username': _usernameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'profileImageUrl': imageUrl,
      };
      await controller.updateUserProfile(updatedData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          // ✨ MEJORA: Texto en español.
          const SnackBar(content: Text('Perfil actualizado con éxito'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          // ✨ MEJORA: Texto en español.
          SnackBar(content: Text('Error al actualizar: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✨ MEJORA: Estilo de input centralizado para consistencia.
    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.white10)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.white10)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
      filled: true,
      fillColor: AppColors.surface,
      labelStyle: const TextStyle(color: AppColors.white70),
    );

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Consumer<AppController>(
            builder: (context, controller, child) {
              return EditProfileAvatar(
                imageFile: _newProfileImage,
                imageUrl: controller.currentUser!.profileImageUrl,
                userName: controller.currentUser!.fullName, // Pasamos el nombre para el fallback
                onTap: _pickImage,
              );
            },
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _fullNameController,
            // ✨ MEJORA: Texto en español y estilo aplicado.
            decoration: inputDecoration.copyWith(labelText: 'Nombre completo'),
            validator: (val) => val!.isEmpty ? 'Este campo es requerido' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _usernameController,
            decoration: inputDecoration.copyWith(labelText: 'Nombre de usuario', prefixText: '@'),
            validator: (val) => val!.isEmpty ? 'Este campo es requerido' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: inputDecoration.copyWith(labelText: 'Teléfono'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50, // ✨ MEJORA: Altura estándar para botones.
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveChanges,
              child: _isLoading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
              // ✨ MEJORA: Texto en español.
                  : const Text('Guardar Cambios', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }
}