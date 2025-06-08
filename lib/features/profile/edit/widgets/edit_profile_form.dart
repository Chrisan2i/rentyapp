import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/landing/controllers/controller.dart';
import 'edit_profile_avatar.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;

  File? _newProfileImage;
  bool _isLoading = false;

  @override
  void initState() {
    final user = Provider.of<Controller>(context, listen: false).currentUser!;
    _fullNameController = TextEditingController(text: user.fullName);
    _usernameController = TextEditingController(text: user.username);
    _phoneController = TextEditingController(text: user.phone);
    super.initState();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _newProfileImage = File(picked.path));
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Provider.of<Controller>(context, listen: false);
    final user = controller.currentUser!;
    setState(() => _isLoading = true);

    try {
      String imageUrl = user.profileImageUrl;

      if (_newProfileImage != null) {
        // Aquí deberías subirla a Cloudinary o Firebase Storage
        imageUrl = 'https://fakeupload.com/image.jpg'; // Reemplázalo
      }

      final updatedData = {
        'fullName': _fullNameController.text.trim(),
        'username': _usernameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'profileImageUrl': imageUrl,
      };

      await controller.updateUserProfile(updatedData);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado correctamente')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Controller>(context).currentUser!;

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Form(
      key: _formKey,
      child: Column(
        children: [
          EditProfileAvatar(
            imageFile: _newProfileImage,
            imageUrl: user.profileImageUrl,
            onTap: _pickImage,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(labelText: 'Nombre completo'),
            validator: (val) => val == null || val.isEmpty ? 'Campo requerido' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Nombre de usuario'),
            validator: (val) => val == null || val.isEmpty ? 'Campo requerido' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Teléfono'),
            validator: (val) => val == null || val.isEmpty ? 'Campo requerido' : null,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('Guardar cambios'),
          )
        ],
      ),
    );
  }
}
