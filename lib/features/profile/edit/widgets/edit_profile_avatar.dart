import 'package:flutter/material.dart';
import 'dart:io';

class EditProfileAvatar extends StatelessWidget {
  final File? imageFile;
  final String imageUrl;
  final VoidCallback onTap;

  const EditProfileAvatar({
    super.key,
    required this.imageFile,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: imageFile != null
            ? FileImage(imageFile!)
            : NetworkImage(imageUrl) as ImageProvider,
      ),
    );
  }
}
