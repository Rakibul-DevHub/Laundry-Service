/// App user roles — used for auth, routing, and feature access
enum Role {
  user,
  rider,
  provider;

  /// Convert string from backend or storage to [Role]
  /// Returns null if invalid (safe parsing)
  static Role? fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'user':
        return Role.user;
      case 'rider':
        return Role.rider;
      case 'provider':
        return Role.provider;
      default:
        return null;
    }
  }

  /// Serialize to string (for storage or API)
  String toJson() {
    switch (this) {
      case Role.user:
        return 'user';
      case Role.rider:
        return 'rider';
      case Role.provider:
        return 'provider';
    }
  }
}
