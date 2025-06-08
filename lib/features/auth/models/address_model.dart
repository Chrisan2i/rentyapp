class AddressModel {
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;

  AddressModel({
    this.street,
    this.city,
    this.state,
    this.country,
    this.zipCode,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      street: map['street'],
      city: map['city'],
      state: map['state'],
      country: map['country'],
      zipCode: map['zipCode'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
    };
  }

  @override
  String toString() {
    return [
      if (street != null) street,
      if (city != null) city,
      if (state != null) state,
      if (country != null) country,
      if (zipCode != null) zipCode,
    ].where((e) => e != null && e!.isNotEmpty).join(', ');
  }
}
