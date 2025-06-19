// lib/features/product/widgets/customer_reviews_section.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/product/models/review_model.dart'; // Asegúrate que esta ruta es correcta
import 'details_text_button.dart';
import 'section_card.dart';

/// Un widget de sección que busca y muestra una vista previa de las reseñas de clientes.
class CustomerReviewsSection extends StatefulWidget {
  final String productId;
  final int totalReviews;

  const CustomerReviewsSection({
    Key? key,
    required this.productId,
    required this.totalReviews,
  }) : super(key: key);

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
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .limit(2)
          .get();
      // ¡CORREGIDO! Ahora el modelo tiene el constructor .fromFirestore
      return snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint("Error fetching reviews: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ReviewModel>>(
      future: _reviewsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink(); // No muestra nada si no hay reseñas
        }

        final reviews = snapshot.data!;
        return SectionCard(
          title: 'Customer Reviews',
          child: Column(
            children: [
              ...reviews.map((review) => _ReviewItem(review: review)).toList(),
              if (widget.totalReviews > reviews.length) ...[
                const SizedBox(height: 16),
                DetailsTextButton(
                  text: 'Show More Reviews',
                  onPressed: () {
                    debugPrint('Navigate to all reviews for product ${widget.productId}');
                    // TODO: Implementar navegación
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

  const _ReviewItem({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary, // Un color de fallback consistente
            // ¡CORREGIDO! Usamos los nuevos getters del modelo
            backgroundImage: review.userImageUrl.isNotEmpty ? NetworkImage(review.userImageUrl) : null,
            child: review.userImageUrl.isEmpty
            // ¡CORREGIDO! Usamos los nuevos getters del modelo
                ? Text(review.userName.isNotEmpty ? review.userName[0].toUpperCase() : 'A', style: const TextStyle(color: AppColors.white))
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ¡CORREGIDO! Usamos los nuevos getters del modelo
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