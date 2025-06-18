import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/product/models/product_model.dart';


import 'widgets/customer_reviews_section.dart';
import 'widgets/location_card.dart';
import 'widgets/owner_info_card.dart';
import 'widgets/product_header.dart';
import 'widgets/product_image_gallery.dart';
import 'widgets/rental_details_card.dart';
import 'package:rentyapp/features/send_rental_request/send_rental_request_view.dart';


class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Product Details', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageGallery(images: product.images),
            const SizedBox(height: 24),
            ProductHeader(
              title: product.title,
              pricePerDay: product.rentalPrices['day'] ?? 0.0,
              rating: product.rating,
            ),
            const SizedBox(height: 16),
            Text(
              product.description,
              style: TextStyle(color: AppColors.white.withOpacity(0.7), fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 24),
            OwnerInfoCard(ownerId: product.ownerId),
            const SizedBox(height: 24),
            CustomerReviewsSection(
              productId: product.productId,
              totalReviews: product.totalReviews,
            ),
            const SizedBox(height: 24),
            RentalDetailsCard(rentalDetails: product.rentalDetails),
            const SizedBox(height: 24),
            LocationCard(location: product.location),
          ],
        ),
      ),
      bottomNavigationBar: _buildRentNowButton(context),
    );
  }

  /// Construye el botón de "Rent Now" en la parte inferior de la pantalla.
  Widget _buildRentNowButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      color: AppColors.background,
      child: ElevatedButton(
        onPressed: () {
          // --- CAMBIO AQUÍ ---
          // Navega a la pantalla de solicitud de alquiler.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SendRentalRequestView(product: product),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Rent Now', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}