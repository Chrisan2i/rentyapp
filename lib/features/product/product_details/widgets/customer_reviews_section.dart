// lib/features/product/widgets/customer_reviews_section.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/features/product/models/review_model.dart';
import '../../../../core/widgets/custom_network_image.dart';
import 'details_text_button.dart';
import 'section_card.dart';

/// A section widget that fetches and displays a preview of customer reviews.
class CustomerReviewsSection extends StatefulWidget {
  final String productId;
  final int totalReviews;

  const CustomerReviewsSection({
    super.key,
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

  /// Fetches the 2 most recent reviews for a given product.
  Future<List<ReviewModel>> _fetchReviews(String productId) async {
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
      // Re-throw to be caught by the FutureBuilder
      throw Exception('Failed to load reviews');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.totalReviews == 0) {
      return SectionCard(
        title: 'Customer Reviews (0)',
        child: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Be the first to leave a review!',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
      );
    }

    return FutureBuilder<List<ReviewModel>>(
      future: _reviewsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _ReviewsPlaceholder();
        }

        if (snapshot.hasError) {
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
              ...reviews.map((review) => _ReviewItem(review: review)),
              if (widget.totalReviews > reviews.length) ...[
                const SizedBox(height: 16),
                DetailsTextButton(
                  text: 'Show all ${widget.totalReviews} reviews',
                  onPressed: () {
                    // TODO: Implement navigation to all reviews screen
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

/// A private widget to display a single review item.
class _ReviewItem extends StatelessWidget {
  final ReviewModel review;

  const _ReviewItem({required this.review});

  @override
  Widget build(BuildContext context) {
    // Fallback initials if the user name is empty.
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
              child: CustomNetworkImage(
                imageUrl: review.userImageUrl,
                fit: BoxFit.cover,
                width: 40,
                height: 40,
                placeholder: (context) => const CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                errorWidget: (context, error) => Center(
                  child: Text(
                    userInitials,
                    style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                  ),
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

/// A placeholder (skeleton) widget for the review list while loading.
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
              Container(width: 100, height: 14, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 8),
              Container(width: 80, height: 12, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 10),
              Container(width: double.infinity, height: 13, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 6),
              Container(width: 150, height: 13, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4))),
            ],
          ),
        ),
      ],
    );
  }
}