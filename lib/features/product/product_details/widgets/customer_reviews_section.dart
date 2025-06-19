// lib/features/product/widgets/customer_reviews_section.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Importa el paquete
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/product/models/review_model.dart'; // Asegúrate que la ruta es correcta
import 'details_text_button.dart';
import 'section_card.dart';

/// Un widget de sección que busca y muestra una vista previa de las reseñas de clientes.
class CustomerReviewsSection extends StatefulWidget {
  final String productId;
  final int totalReviews;

  const CustomerReviewsSection({
    super.key, // MEJORA: super.key
    required this.productId,
    required this.totalReviews,
  });

  @override
  State<CustomerReviewsSection> createState() => _CustomerReviewsSectionState();
}

class _CustomerReviewsSectionState extends State<CustomerReviewsSection> {
  late final Future<List<ReviewModel>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = _fetchReviews(widget.productId);
  }

  /// Obtiene las reseñas más recientes de la subcolección de un producto.
  Future<List<ReviewModel>> _fetchReviews(String productId) async {
    // Si no hay reseñas totales, no hacemos la llamada a la base de datos.
    if (widget.totalReviews == 0) return [];

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .limit(2)
          .get();
      return snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint("Error fetching reviews: $e");
      // Propagamos el error para que el FutureBuilder lo maneje.
      throw Exception('Failed to load reviews');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si sabemos que no hay reseñas, no mostramos nada.
    if (widget.totalReviews == 0) {
      return SectionCard(
        title: 'Customer Reviews (0)',
        child: const Center(
          child: Text(
            'Be the first to leave a review!',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return FutureBuilder<List<ReviewModel>>(
      future: _reviewsFuture,
      builder: (context, snapshot) {
        // --- MEJORA: Lógica de carga y error más explícita ---
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un placeholder mientras carga
          return const _ReviewsPlaceholder();
        }

        if (snapshot.hasError) {
          // Muestra un mensaje si la carga falla
          return SectionCard(
            title: 'Customer Reviews',
            child: const Center(child: Text('Could not load reviews.', style: TextStyle(color: AppColors.error))),
          );
        }

        final reviews = snapshot.data ?? [];

        return SectionCard(
          title: 'Customer Reviews (${widget.totalReviews})',
          child: Column(
            children: [
              ...reviews.map((review) => _ReviewItem(review: review)).toList(),

              if (widget.totalReviews > reviews.length) ...[
                const SizedBox(height: 16),
                DetailsTextButton(
                  text: 'Show all ${widget.totalReviews} reviews',
                  onPressed: () {
                    // TODO: Implementar navegación a la pantalla de todas las reseñas
                    debugPrint('Navigate to all reviews for product ${widget.productId}');
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Widget privado para mostrar un solo ítem de reseña.
class _ReviewItem extends StatelessWidget {
  final ReviewModel review;

  const _ReviewItem({required this.review}); // super.key es opcional en widgets privados

  @override
  Widget build(BuildContext context) {
    final String userInitials = review.userName.isNotEmpty ? review.userName[0].toUpperCase() : 'A';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.surface,
            child: ClipOval(
              // --- MEJORA: Usamos CachedNetworkImage para robustez ---
              child: CachedNetworkImage(
                imageUrl: review.userImageUrl,
                fit: BoxFit.cover,
                width: 40,
                height: 40,
                placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
                errorWidget: (context, url, error) => Center(
                  child: Text(userInitials, style: const TextStyle(color: AppColors.white)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(review.userName, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (index) => Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  )),
                ),
                const SizedBox(height: 8),
                Text(review.comment, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// Widget privado para mostrar un esqueleto de carga.
class _ReviewsPlaceholder extends StatelessWidget {
  const _ReviewsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Customer Reviews',
      child: Column(
        children: [
          _buildPlaceholderItem(),
          const SizedBox(height: 16),
          _buildPlaceholderItem(),
        ],
      ),
    );
  }

  Widget _buildPlaceholderItem() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(radius: 20, backgroundColor: AppColors.surface),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 100, height: 14, color: AppColors.surface),
              const SizedBox(height: 8),
              Container(width: 80, height: 12, color: AppColors.surface),
              const SizedBox(height: 10),
              Container(width: double.infinity, height: 13, color: AppColors.surface),
              const SizedBox(height: 6),
              Container(width: 150, height: 13, color: AppColors.surface),
            ],
          ),
        ),
      ],
    );
  }
}