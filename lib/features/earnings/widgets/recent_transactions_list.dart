// ARCHIVO: lib/features/earnings/widgets/recent_transactions_list.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentyapp/core/theme/app_colors.dart';
import 'package:rentyapp/core/theme/app_text_styles.dart';
import 'package:rentyapp/features/auth/models/transaction_model.dart';

class RecentTransactionsList extends StatelessWidget {
  final List<TransactionModel> transactions;
  const RecentTransactionsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Transactions', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 16),
        ListView.separated(
          itemCount: transactions.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => const Divider(color: AppColors.white10, height: 1),
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return _buildTransactionTile(transaction);
          },
        ),
      ],
    );
  }

  Widget _buildTransactionTile(TransactionModel transaction) {
    final bool isCredit = transaction.amount > 0;
    final formatCurrency = NumberFormat.simpleCurrency(decimalDigits: 2, name: '');

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: CircleAvatar(
        backgroundColor: (isCredit ? AppColors.success : AppColors.danger).withOpacity(0.1),
        child: Icon(
          isCredit ? Icons.arrow_downward : Icons.arrow_upward,
          color: isCredit ? AppColors.success : AppColors.danger,
          size: 20,
        ),
      ),
      title: Text(transaction.description, style: AppTextStyles.inputLabel),
      subtitle: Text(
        DateFormat('MMMM d, yyyy').format(transaction.createdAt),
        style: AppTextStyles.subtitle.copyWith(fontSize: 12),
      ),
      trailing: Text(
        '${isCredit ? '+' : ''}\$${formatCurrency.format(transaction.amount.abs())}',
        style: TextStyle(
          color: isCredit ? AppColors.success : AppColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}