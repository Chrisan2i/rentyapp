// ARCHIVO: lib/features/profile/widgets/edit_profile_form.dart

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
      // Se usa 'AppController' para obtener los datos iniciales.
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

    // Se usa 'AppController' para acceder a los métodos.
    final controller = Provider.of<AppController>(context, listen: false);
    final user = controller.currentUser!; // '!' es seguro aquí.

    try {
      String imageUrl = user.profileImageUrl;
      if (_newProfileImage != null) {
        // Lógica para subir imagen aquí...
        // imageUrl = await controller.uploadImage(_newProfileImage!);
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
          const SnackBar(content: Text('Perfil actualizado'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Se usa 'AppController' en el Consumer.
          Consumer<AppController>(
            builder: (context, controller, child) {
              return EditProfileAvatar(
                imageFile: _newProfileImage,
                // '!' es seguro aquí por la lógica en la vista padre.
                imageUrl: controller.currentUser!.profileImageUrl,
                onTap: _pickImage,
              );
            },
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(labelText: 'Nombre completo'),
            validator: (val) => val!.isEmpty ? 'Campo requerido' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Nombre de usuario'),
            validator: (val) => val!.isEmpty ? 'Campo requerido' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Teléfono'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
              ),
              child: _isLoading
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
              )
                  : const Text('Guardar cambios', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}