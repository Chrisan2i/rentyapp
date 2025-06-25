// lib/features/add_product/add_product_view.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// --- Models, Widgets & Services ---
import 'package:rentyapp/features/product/models/product_model.dart';
import 'package:rentyapp/features/add_product/widgets/step_header.dart';
import 'package:rentyapp/features/add_product/widgets/category_step.dart';
import 'package:rentyapp/features/add_product/widgets/add_photos_step.dart';
import 'package:rentyapp/features/add_product/widgets/product_details_step.dart';
import 'package:rentyapp/features/add_product/widgets/pricing_availability_step.dart';
import 'package:rentyapp/features/add_product/widgets/location_step.dart';
import 'package:rentyapp/core/widgets/cloudinary_service.dart';
import 'package:rentyapp/features/add_product/widgets/next_button.dart'; // Renamed for consistency

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  int _currentStep = 0;
  bool _isPublishing = false;

  // --- Step Data ---
  String? _selectedCategory;
  final List<String> _imageUrls = [];
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _condition = 'new';

  final Map<String, bool> _selectedRates = {'day': false, 'week': false, 'month': false};
  final Map<String, TextEditingController> _rateControllers = {
    'day': TextEditingController(),
    'week': TextEditingController(),
    'month': TextEditingController(),
  };
  final _securityDepositController = TextEditingController();
  bool _instantBooking = false;

  final _addressController = TextEditingController();
  double? _latitude;
  double? _longitude;
  bool _offersDelivery = false;

  // Getter to validate the current step
  bool get isStepValid {
    switch (_currentStep) {
      case 0:
        return _selectedCategory != null && _selectedCategory!.isNotEmpty;
      case 1:
        return _imageUrls.isNotEmpty;
      case 2:
        return _titleController.text.trim().isNotEmpty && _descriptionController.text.trim().isNotEmpty;
      case 3:
      // Validates that at least one rate is selected and has a valid numeric value > 0.
        return _selectedRates.entries.any((entry) {
          if (entry.value) {
            final value = _rateControllers[entry.key]?.text.trim();
            return value != null && value.isNotEmpty && (double.tryParse(value) ?? 0) > 0;
          }
          return false;
        });
      case 4:
        return _addressController.text.trim().isNotEmpty && _latitude != null && _longitude != null;
      default:
        return false;
    }
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to rebuild the UI when form fields change (e.g., to enable/disable the next button)
    _titleController.addListener(_rebuild);
    _descriptionController.addListener(_rebuild);
    _addressController.addListener(_rebuild);
    _securityDepositController.addListener(_rebuild);
    _rateControllers.forEach((_, controller) => controller.addListener(_rebuild));
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _titleController.removeListener(_rebuild);
    _descriptionController.removeListener(_rebuild);
    _addressController.removeListener(_rebuild);
    _securityDepositController.removeListener(_rebuild);
    _rateControllers.forEach((_, controller) {
      controller.removeListener(_rebuild);
      controller.dispose();
    });
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    } else {
      _submitProduct();
    }
  }

  // --- Refined Product Submission Logic ---
  Future<void> _submitProduct() async {
    if (!isStepValid) return;
    setState(() => _isPublishing = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated. Please log in.');
      }

      final productId = const Uuid().v4();

      // 1. Build the PricingDetails object from controllers
      final pricingDetails = PricingDetails(
        perDay: _selectedRates['day']! ? double.tryParse(_rateControllers['day']!.text.trim()) : null,
        perWeek: _selectedRates['week']! ? double.tryParse(_rateControllers['week']!.text.trim()) : null,
        perMonth: _selectedRates['month']! ? double.tryParse(_rateControllers['month']!.text.trim()) : null,
      );

      // 2. Safely parse the security deposit
      final securityDeposit = double.tryParse(_securityDepositController.text.trim()) ?? 0.0;

      // 3. Create a ProductModel instance with all form data
      final newProduct = ProductModel(
        productId: productId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory!,
        images: _imageUrls,
        isAvailable: true, // A new product is available by default
        rentalPrices: pricingDetails,
        securityDeposit: securityDeposit,
        minimumRentalDays: 1,  // Default values you could make configurable in the future
        maximumRentalDays: 90,
        rentedPeriods: [], // A new product has no rented periods yet
        location: {
          'address': _addressController.text.trim(),
          'latitude': _latitude!,
          'longitude': _longitude!,
          'offersDelivery': _offersDelivery,
        },
        ownerId: user.uid,
        rating: 0.0,
        totalReviews: 0,
        createdAt: DateTime.now(), // toMap will handle Timestamp conversion
        updatedAt: DateTime.now(),
      );

      // 4. Convert the object to a map and save to Firestore
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .set(newProduct.toMap()); // Using our model's toMap() method!

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product published successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Go back to the previous screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error publishing product: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPublishing = false);
      }
    }
  }

  Future<void> _handleAddPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (picked == null) return;

    // Show a temporary loading indicator
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uploading image...')));

    final url = await CloudinaryService.uploadImage(picked);

    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide the "uploading" message

    if (url != null) {
      setState(() => _imageUrls.add(url));
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to upload image')));
    }
  }

  void _useMockLocation() {
    setState(() {
      _latitude = 10.5;
      _longitude = -66.91;
      _addressController.text = "Plaza Venezuela, Caracas, Venezuela"; // Auto-fill the address
    });
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return CategoryStep(
          selectedCategory: _selectedCategory,
          onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
        );
      case 1:
        return AddPhotosStep(
          photos: _imageUrls,
          onAddPhoto: _handleAddPhoto,
          onRemovePhoto: (url) => setState(() => _imageUrls.remove(url)),
        );
      case 2:
        return ProductDetailsStep(
          titleController: _titleController,
          descriptionController: _descriptionController,
          condition: _condition,
          onConditionChanged: (val) => setState(() => _condition = val ?? 'new'),
        );
      case 3:
        return PricingAvailabilityStep(
          selectedRates: _selectedRates,
          rateControllers: _rateControllers,
          securityDepositController: _securityDepositController,
          instantBooking: _instantBooking,
          onToggleInstantBooking: () => setState(() => _instantBooking = !_instantBooking),
          onRateTypeToggle: (type) => setState(() => _selectedRates[type] = !(_selectedRates[type] ?? false)),
        );
      case 4:
        return LocationStep(
          addressController: _addressController,
          latitude: _latitude,
          longitude: _longitude,
          onUseCurrentLocation: _useMockLocation, // Replace with actual location logic later
          offersDelivery: _offersDelivery,
          onToggleDelivery: () => setState(() => _offersDelivery = !_offersDelivery),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonText = _currentStep < 4 ? 'Next' : 'Publish Item';

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            StepHeader(currentStep: _currentStep),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildStepContent(),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: ActionButton(
                text: buttonText,
                isLoading: _isPublishing,
                onPressed: isStepValid && !_isPublishing ? _nextStep : null,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}