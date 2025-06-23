// lib/features/add_product/add_product_view.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// --- Tus widgets de pasos ---
import 'package:rentyapp/features/add_product/widgets/step_header.dart';
import 'package:rentyapp/features/add_product/widgets/category_step.dart';
import 'package:rentyapp/features/add_product/widgets/add_photos_step.dart';
import 'package:rentyapp/features/add_product/widgets/product_details_step.dart';
import 'package:rentyapp/features/add_product/widgets/pricing_availability_step.dart';
import 'package:rentyapp/features/add_product/widgets/location_step.dart';
// --- Tus servicios y widgets base ---
import 'package:rentyapp/core/widgets/cloudinary_service.dart';
import 'package:rentyapp/features/add_product/widgets/next_button.dart'; // <<<--- IMPORTANTE: Importa el nuevo botón

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  int currentStep = 0;
  bool _isPublishing = false; // Estado para el spinner de carga

  // --- Datos de los pasos ---
  String? selectedCategory;
  List<String> imageUrls = [];
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String condition = 'new';
  int quantity = 1;
  Map<String, bool> selectedRates = {'day': false, 'hour': false, 'week': false, 'month': false};
  Map<String, TextEditingController> rateControllers = {
    'day': TextEditingController(), 'hour': TextEditingController(),
    'week': TextEditingController(), 'month': TextEditingController(),
  };
  final depositController = TextEditingController();
  List<DateTime> availableDates = [];
  bool instantBooking = false;
  final addressController = TextEditingController();
  double? latitude;
  double? longitude;
  bool offersDelivery = false;

  // <<<--- NUEVO: Getter para validar el estado del paso actual ---<<<
  bool get isStepValid {
    switch (currentStep) {
      case 0:
        return selectedCategory != null && selectedCategory!.isNotEmpty;
      case 1:
        return imageUrls.isNotEmpty;
      case 2:
        return titleController.text.trim().isNotEmpty && descriptionController.text.trim().isNotEmpty;
      case 3:
        return selectedRates.entries.any((entry) {
          if (entry.value) {
            final value = rateControllers[entry.key]?.text.trim();
            return value != null && value.isNotEmpty && (double.tryParse(value) ?? 0) > 0;
          }
          return false;
        });
      case 4:
        return addressController.text.trim().isNotEmpty && latitude != null && longitude != null;
      default:
        return false;
    }
  }

  @override
  void initState() {
    super.initState();
    // Añadir listeners para que la UI se actualice y el botón se habilite/deshabilite en tiempo real
    titleController.addListener(_rebuild);
    descriptionController.addListener(_rebuild);
    addressController.addListener(_rebuild);
    rateControllers.forEach((_, controller) => controller.addListener(_rebuild));
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    // Limpiar todos los controladores y listeners para evitar memory leaks
    titleController.removeListener(_rebuild);
    descriptionController.removeListener(_rebuild);
    addressController.removeListener(_rebuild);
    rateControllers.forEach((_, controller) {
      controller.removeListener(_rebuild);
      controller.dispose();
    });
    depositController.dispose();
    super.dispose();
  }

  // --- Lógica de los pasos y envío ---

  void _nextStep() {
    if (currentStep < 4) {
      setState(() => currentStep++);
    } else {
      _submitProduct();
    }
  }

  Future<void> _submitProduct() async {
    if (!isStepValid) return; // Doble chequeo
    setState(() => _isPublishing = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Not authenticated');

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

      final productData = {
        'productId': productId, 'ownerId': user.uid, 'title': titleController.text.trim(),
        'description': descriptionController.text.trim(), 'category': selectedCategory!,
        'rentalPrices': rentalPrices, 'images': imageUrls, 'isAvailable': true,
        'rating': 0.0, 'totalReviews': 0, 'views': 0,
        'createdAt': now.toIso8601String(), 'updatedAt': now.toIso8601String(),
        'location': {
          'address': addressController.text.trim(), 'latitude': latitude,
          'longitude': longitude, 'delivery': offersDelivery,
        },
      };

      await FirebaseFirestore.instance.collection('products').doc(productId).set(productData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product published successfully')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() => _isPublishing = false);
      }
    }
  }

  Future<void> _handleAddPhoto() async {
    // ... tu código de _handleAddPhoto no cambia ...
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (picked != null) {
      // Opcional: mostrar un indicador de carga mientras sube la imagen
      final url = await CloudinaryService.uploadImage(picked);
      if (url != null) {
        setState(() => imageUrls.add(url));
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')),
          );
        }
      }
    }
  }

  void _useMockLocation() {
    // ... tu código de _useMockLocation no cambia ...
    setState(() {
      latitude = 10.5;
      longitude = -66.91;
    });
  }

  Widget _buildStep() {
    switch (currentStep) {
      case 0:
        return CategoryStep(selectedCategory: selectedCategory, onCategorySelected: (cat) => setState(() => selectedCategory = cat));
      case 1:
        return AddPhotosStep(photos: imageUrls, onAddPhoto: _handleAddPhoto, onRemovePhoto: (url) => setState(() => imageUrls.remove(url)));
      case 2:
        return ProductDetailsStep(
            titleController: titleController, descriptionController: descriptionController,
            condition: condition, quantity: quantity,
            onConditionChanged: (val) => setState(() => condition = val ?? 'new'),
            onQuantityChanged: (val) => setState(() => quantity = val));
      case 3:
        return PricingAvailabilityStep(
            selectedRates: selectedRates, rateControllers: rateControllers, depositController: depositController,
            availableDates: availableDates, instantBooking: instantBooking,
            onToggleInstantBooking: () => setState(() => instantBooking = !instantBooking),
            onToggleDate: (date) {
              setState(() {
                if (availableDates.any((d) => isSameDay(d, date))) {
                  availableDates.removeWhere((d) => isSameDay(d, date));
                } else {
                  availableDates.add(date);
                }
              });
            },
            onRateTypeToggle: (type) => setState(() => selectedRates[type] = !(selectedRates[type] ?? false)));
      case 4:
        return LocationStep(
            addressController: addressController, latitude: latitude, longitude: longitude,
            onUseCurrentLocation: _useMockLocation, offersDelivery: offersDelivery,
            onToggleDelivery: () => setState(() => offersDelivery = !offersDelivery));
      default:
        return const SizedBox();
    }
  }

  bool isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    // El texto del botón cambia en el último paso
    final buttonText = currentStep < 4 ? 'Next' : 'Publish Product';

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: Column(
          children: [
            StepHeader(currentStep: currentStep),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildStep(),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              // <<<--- CAMBIO CLAVE: Usando el ActionButton mejorado ---<<<
              child: ActionButton(
                text: buttonText,
                isLoading: _isPublishing,
                // El botón se habilita si el paso es válido y no se está publicando
                onPressed: isStepValid && !_isPublishing ? _nextStep : null,
                width: double.infinity, // Ocupa todo el ancho disponible
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}