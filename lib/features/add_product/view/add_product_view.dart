import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'package:rentyapp/features/add_product/widgets/step_header.dart';
import 'package:rentyapp/features/add_product/widgets/category_step.dart';
import 'package:rentyapp/features/add_product/widgets/next_button.dart';
import 'package:rentyapp/features/add_product/widgets/add_photos_step.dart';
import 'package:rentyapp/features/add_product/widgets/product_details_step.dart';
import 'package:rentyapp/features/add_product/widgets/pricing_availability_step.dart';
import 'package:rentyapp/features/add_product/widgets/location_step.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentyapp/core/widgets/cloudinary_service.dart'; // o donde lo guardes


class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  int currentStep = 0;

  // Paso 0
  String? selectedCategory;

  // Paso 1
  List<String> imageUrls = [];

  // Paso 2
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String condition = 'new';
  int quantity = 1;

  // Paso 3
  Map<String, bool> selectedRates = {
    'day': false,
    'hour': false,
    'week': false,
    'month': false,
  };
  Map<String, TextEditingController> rateControllers = {
    'day': TextEditingController(),
    'hour': TextEditingController(),
    'week': TextEditingController(),
    'month': TextEditingController(),
  };
  final depositController = TextEditingController();
  List<DateTime> availableDates = [];
  bool instantBooking = false;

  // Paso 4
  final addressController = TextEditingController();
  double? latitude;
  double? longitude;
  bool offersDelivery = false;

  void _useMockLocation() {
    setState(() {
      latitude = 10.5;
      longitude = -66.91;
    });
  }
  Future<void> _handleAddPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (picked != null) {
      final url = await CloudinaryService.uploadImage(picked);
      if (url != null) {
        setState(() => imageUrls.add(url));
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')),
          );
        }
      }
    }
  }


  Widget _buildStep() {
    switch (currentStep) {
      case 0:
        return CategoryStep(
          selectedCategory: selectedCategory,
          onCategorySelected: (category) {
            setState(() => selectedCategory = category);
          },
        );
      case 1:
        return AddPhotosStep(
          photos: imageUrls,
          onAddPhoto: (url) => setState(() => imageUrls.add(url)),
          onRemovePhoto: (url) => setState(() => imageUrls.remove(url)),
        );
      case 2:
        return ProductDetailsStep(
          titleController: titleController,
          descriptionController: descriptionController,
          condition: condition,
          quantity: quantity,
          onConditionChanged: (value) {
            if (value != null) setState(() => condition = value);
          },
          onQuantityChanged: (val) => setState(() => quantity = val),
        );
      case 3:
        return PricingAvailabilityStep(
          selectedRates: selectedRates,
          rateControllers: rateControllers,
          depositController: depositController,
          availableDates: availableDates,
          instantBooking: instantBooking,
          onToggleInstantBooking: () =>
              setState(() => instantBooking = !instantBooking),
          onToggleDate: (date) {
            setState(() {
              if (availableDates.any((d) =>
              d.year == date.year &&
                  d.month == date.month &&
                  d.day == date.day)) {
                availableDates.removeWhere((d) =>
                d.year == date.year &&
                    d.month == date.month &&
                    d.day == date.day);
              } else {
                availableDates.add(date);
              }
            });
          },
          onRateTypeToggle: (type) =>
              setState(() => selectedRates[type] = !(selectedRates[type] ?? false)),
        );
      case 4:
        return LocationStep(
          addressController: addressController,
          latitude: latitude,
          longitude: longitude,
          onUseCurrentLocation: _useMockLocation,
          offersDelivery: offersDelivery,
          onToggleDelivery: () =>
              setState(() => offersDelivery = !offersDelivery),
        );
      default:
        return const SizedBox();
    }
  }

  void _nextStep() {
    if (currentStep < 4) {
      setState(() => currentStep++);
    } else {
      _submitProduct();
    }
  }

  Future<void> _submitProduct() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Not authenticated');
      if (selectedCategory == null || selectedCategory!.isEmpty) {
        throw Exception('Category is required');
      }
      if (imageUrls.isEmpty) {
        throw Exception('At least one image is required');
      }

      final now = DateTime.now();
      final productId = const Uuid().v4();

      Map<String, double> rentalPrices = {};
      selectedRates.forEach((key, selected) {
        if (selected) {
          final value = rateControllers[key]?.text.trim();
          if (value != null && value.isNotEmpty) {
            rentalPrices[key] = double.tryParse(value) ?? 0.0;
          }
        }
      });

      final product = {
        'productId': productId,
        'ownerId': user.uid,
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'category': selectedCategory!,
        'rentalPrices': rentalPrices,
        'images': imageUrls,
        'isAvailable': true,
        'rating': 0.0,
        'totalReviews': 0,
        'views': 0,
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
        'location': {
          'address': addressController.text.trim(),
          'latitude': latitude,
          'longitude': longitude,
          'delivery': offersDelivery,
        },
      };

      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .set(product);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product published successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: Column(
          children: [
            StepHeader(currentStep: currentStep),
            const SizedBox(height: 24),
            Expanded(child: SingleChildScrollView(child: _buildStep())),
            const SizedBox(height: 12),
            NextButton(onPressed: _nextStep),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
