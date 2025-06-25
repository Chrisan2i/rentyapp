import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/product/models/product_model.dart';
import 'package:rentyapp/features/auth/models/user_model.dart';
import 'package:rentyapp/features/auth/services/auth_service.dart';
import 'package:rentyapp/features/send_rental_request/send_rental_request_view.dart';

// Importa todos los widgets que esta pantalla utiliza
import 'widgets/customer_reviews_section.dart';
import 'widgets/location_card.dart';
import 'widgets/owner_info_card.dart';
import 'widgets/product_header.dart';
import 'widgets/product_image_gallery.dart';
import 'widgets/rental_details_card.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  UserModel? _owner;
  bool _isLoadingOwner = true;

  @override
  void initState() {
    super.initState();
    _fetchOwnerDetails();
  }

  /// Busca los datos completos del propietario usando el ownerId del producto.
  Future<void> _fetchOwnerDetails() async {
    // --- MEJORA: Manejo de robustez ---
    if (widget.product.ownerId.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoadingOwner = false;
          _owner = null; // No hay dueño que buscar
        });
      }
      return;
    }

    final ownerData = await AuthService().getUserData(widget.product.ownerId);
    if (mounted) {
      setState(() {
        _owner = ownerData;
        _isLoadingOwner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 0, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductImageGallery(images: widget.product.images),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      ProductHeader(
                        title: widget.product.title,
                        prices: widget.product.rentalPrices,
                        rating: widget.product.rating,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.product.description,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
                      ),
                      const SizedBox(height: 24),

                      // Llama al nuevo método que construye la sección del propietario
                      _buildOwnerSection(),

                      const SizedBox(height: 24),
                      CustomerReviewsSection(
                        productId: widget.product.productId,
                        totalReviews: widget.product.totalReviews,
                      ),
                      const SizedBox(height: 24),
                      RentalDetailsCard(
                        prices: widget.product.rentalPrices,
                        minimumRentalDays: widget.product.minimumRentalDays,
                        depositAmount: widget.product.securityDeposit,
                      ),
                      const SizedBox(height: 24),
                      LocationCard(location: widget.product.location),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40.0,
            left: 15.0,
            child: CircleAvatar(
              backgroundColor: Colors.black.withAlpha(128),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildRentNowButton(context),
    );
  }

  /// --- MEJORA: Widget de carga y error para la información del propietario ---
  /// Este método mejora la experiencia de usuario durante la carga.
  Widget _buildOwnerSection() {
    if (_isLoadingOwner) {
      // Muestra un esqueleto/placeholder en lugar de un spinner para evitar saltos en el layout.
      return const OwnerInfoCard.placeholder();
    }

    if (_owner != null) {
      // Si el dueño se encontró, muestra la tarjeta con los datos.
      return OwnerInfoCard(ownerInfo: _owner!);
    } else {
      // Si no se encontró (o hubo un error), muestra un mensaje.
      return const Text(
        'Owner information is not available.',
        style: TextStyle(color: AppColors.textSecondary),
      );
    }
  }

  /// --- MEJORA: Lógica de negocio en el botón ---
  /// El botón ahora se deshabilita si el producto no está disponible o si el
  /// usuario actual es el propietario.
  Widget _buildRentNowButton(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final bool isOwner = currentUserId == widget.product.ownerId;
    final bool canRent = widget.product.isAvailable && !isOwner;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      color: AppColors.background.withAlpha(242),
      child: ElevatedButton(
        // El botón se deshabilita si canRent es false.
        onPressed: canRent
            ? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SendRentalRequestView(product: widget.product),
            ),
          );
        }
            : null,
        style: ElevatedButton.styleFrom(
          // Cambia de color si está deshabilitado para dar feedback visual.
          backgroundColor: canRent ? AppColors.primary : Colors.grey[700],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        // Muestra un texto diferente si el usuario es el propietario.
        child: Text(
          isOwner ? 'This is Your Product' : 'Rent Now',
          style: TextStyle(
            color: canRent ? AppColors.white : Colors.grey[400],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}