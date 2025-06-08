class UserPreferences {
  final bool receiveNotifications;
  final String? preferredLanguage;
  final String? theme;
  final List<String>? categoriesOfInterest;
  final String? bio; // ✅ nuevo campo opcional

  UserPreferences({
    this.receiveNotifications = true,
    this.preferredLanguage,
    this.theme = 'system',
    this.categoriesOfInterest,
    this.bio,
  });

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      receiveNotifications: map['receiveNotifications'] ?? true,
      preferredLanguage: map['preferredLanguage'],
      theme: map['theme'] ?? 'system',
      categoriesOfInterest: List<String>.from(map['categoriesOfInterest'] ?? []),
      bio: map['bio'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'receiveNotifications': receiveNotifications,
      'preferredLanguage': preferredLanguage,
      'theme': theme,
      'categoriesOfInterest': categoriesOfInterest,
      'bio': bio,
    };
  }
}
