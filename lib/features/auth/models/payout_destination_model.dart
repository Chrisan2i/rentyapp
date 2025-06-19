// lib/models/user/payout_destination_model.dart

class PayoutDestinationModel {
  final String destinationId;
  final String alias;
  final String type; // 've_bank_account', 'binance_pay', 'zelle'
  final bool isDefault;
  final Map<String, dynamic> destinationDetails;

  PayoutDestinationModel({
    required this.destinationId,
    required this.alias,
    required this.type,
    this.isDefault = false,
    required this.destinationDetails,
  });

  factory PayoutDestinationModel.fromMap(Map<String, dynamic> map, String id) {
    return PayoutDestinationModel(
      destinationId: id,
      alias: map['alias'] ?? '',
      type: map['type'] ?? '',
      isDefault: map['isDefault'] ?? false,
      destinationDetails: Map<String, dynamic>.from(map['destinationDetails'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'alias': alias,
      'type': type,
      'isDefault': isDefault,
      'destinationDetails': destinationDetails,
    };
  }
}