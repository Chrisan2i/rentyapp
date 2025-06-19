// ARCHIVO: lib/features/profile/edit_profile_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/controllers/controller.dart';
import 'widgets/edit_profile_form.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Se usa 'AppController' para obtener el estado.
    final user = Provider.of<AppController>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: AppColors.background,
      // La lógica aquí asegura que EditProfileForm solo se construya si 'user' no es nulo.
      body: user == null
          ? const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      )
          : const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: EditProfileForm(),
      ),
    );
  }
}