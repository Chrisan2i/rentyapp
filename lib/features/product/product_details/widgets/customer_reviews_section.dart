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
    // La lógica de fetch se inicia una sola vez cuando el widget se crea.
    _reviewsFuture = _fetchReviews(widget.productId);
  }

  /// Obtiene las reseñas más recientes de la subcolección de un producto.
  Future<List<ReviewModel>> _fetchReviews(String productId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .collection('reviews') // Asume la subcolección 'reviews'
          .orderBy('createdAt', descending: true)
          .limit(2) // Limita a 2 para la vista previa
          .get();
      return snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint("Error fetching reviews: $e");
      // Retorna una lista vacía en caso de error para no romper la UI.
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ReviewModel>>(
      future: _reviewsFuture,
      builder: (context, snapshot) {
        // Estado de carga
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        // Si no hay datos o la lista está vacía, no muestra nada.
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        // Si hay datos, muestra la tarjeta de reseñas.
        final reviews = snapshot.data!;
        return SectionCard(
          title: 'Customer Reviews',
          child: Column(
            children: [
              // Mapea la lista de reseñas a widgets de ReviewItem
              ...reviews.map((review) => _ReviewItem(review: review)).toList(),
              // Muestra el botón "Ver más" solo si hay más reseñas que las mostradas
              if (widget.totalReviews > reviews.length) ...[
                const SizedBox(height: 16),
                DetailsTextButton(
                  text: 'Show More Reviews',
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
/// Se mantiene dentro de este archivo porque solo es usado por CustomerReviewsSection.
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
            backgroundColor: Colors.indigo, // Color de fallback
            backgroundImage: review.userImageUrl.isNotEmpty ? NetworkImage(review.userImageUrl) : null,
            child: review.userImageUrl.isEmpty
                ? Text(review.userName.isNotEmpty ? review.userName[0].toUpperCase() : 'A', style: const TextStyle(color: AppColors.white))
                : null,
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