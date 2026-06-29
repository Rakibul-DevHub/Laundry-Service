enum Gender {
  male,
  female,
  others;


  /// Convert string from backend or storage to [Gender]
  /// Returns null if invalid (safe parsing)
  static Gender? fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      case 'others':
        return Gender.others;
      default:
        return null;
    }
  }

  /// Serialize to string (for storage or API)
  String toJson() {
    switch (this) {
      case Gender.male:
        return 'male';
      case Gender.female:
        return 'female';
      case Gender.others:
        return 'other';
    }
  }
}
