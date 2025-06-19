
class AddressModel {
  final String? street;
  final String? city;
  final String? state;
  final String? country;

  AddressModel({this.street, this.city, this.state, this.country});

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      street: map['street'],
      city: map['city'],
      state: map['state'],
      country: map['country'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'country': country,
    };
  }
}

class UserPreferencesModel {
  final String? bio;
  final AddressModel? address;
  final bool receiveNotifications;
  final String theme; // 'system', 'light', 'dark'
  final List<String> categoriesOfInterest;

  UserPreferencesModel({
    this.bio,
    this.address,
    this.receiveNotifications = true,
    this.theme = 'system',
    this.categoriesOfInterest = const [],
  });

  factory UserPreferencesModel.fromMap(Map<String, dynamic> map) {
    return UserPreferencesModel(
      bio: map['bio'],
      address: map['address'] != null ? AddressModel.fromMap(map['address']) : null,
      receiveNotifications: map['receiveNotifications'] ?? true,
      theme: map['theme'] ?? 'system',
      categoriesOfInterest: List<String>.from(map['categoriesOfInterest'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bio': bio,
      'address': address?.toMap(),
      'receiveNotifications': receiveNotifications,
      'theme': theme,
      'categoriesOfInterest': categoriesOfInterest,
    };
  }
}