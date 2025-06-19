// lib/models/user/payment_method_model.dart

class PaymentMethodModel {
  final String paymentMethodId;
  final String alias;
  final String type; // 'stripe_card'
  final bool isDefault;
  final Map<String, dynamic> providerDetails;

  PaymentMethodModel({
    required this.paymentMethodId,
    required this.alias,
    required this.type,
    this.isDefault = false,
    required this.providerDetails,
  });

  factory PaymentMethodModel.fromMap(Map<String, dynamic> map, String id) {
    return PaymentMethodModel(
      paymentMethodId: id,
      alias: map['alias'] ?? '',
      type: map['type'] ?? '',
      isDefault: map['isDefault'] ?? false,
      providerDetails: Map<String, dynamic>.from(map['providerDetails'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'alias': alias,
      'type': type,
      'isDefault': isDefault,
      'providerDetails': providerDetails,
    };
  }
}