class PaymentMethod {
  final String type; // 'binance', 'pagoMovil', 'transferencia'
  final String? binanceUser;
  final String? phoneNumber;
  final String? idOrRif;
  final String? bank;
  final String? accountNumber;

  PaymentMethod({
    required this.type,
    this.binanceUser,
    this.phoneNumber,
    this.idOrRif,
    this.bank,
    this.accountNumber,
  });

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      type: map['type'] ?? '',
      binanceUser: map['binanceUser'],
      phoneNumber: map['phoneNumber'],
      idOrRif: map['idOrRif'],
      bank: map['bank'],
      accountNumber: map['accountNumber'],
    );
  }

  Map<String, dynamic> toMapBinance() => {
    'binanceUser': binanceUser,
  };

  Map<String, dynamic> toMapPagoMovil() => {
    'phoneNumber': phoneNumber,
    'idOrRif': idOrRif,
    'bank': bank,
  };

  Map<String, dynamic> toMapTransferencia() => {
    'bank': bank,
    'accountNumber': accountNumber,
  };
}