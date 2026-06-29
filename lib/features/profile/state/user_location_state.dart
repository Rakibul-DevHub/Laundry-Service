import '../model/user_location_model.dart';

class UserLocationState {
  final List<UserLocation> savedLocations;
  final List<SearchedLocation> searchResults;
  final bool isLoading;
  final bool isSearching;
  final bool isSaving;
  final bool isUpdating;
  final String? error;
  final String? searchError;

  const UserLocationState({
    this.savedLocations = const <UserLocation>[],
    this.searchResults = const <SearchedLocation>[],
    this.isLoading = false,
    this.isSearching = false,
    this.isSaving = false,
    this.isUpdating = false,
    this.error,
    this.searchError,
  });

  UserLocationState copyWith({
    List<UserLocation>? savedLocations,
    List<SearchedLocation>? searchResults,
    bool? isLoading,
    bool? isSearching,
    bool? isSaving,
    bool? isUpdating,
    String? error,
    String? searchError,
  }) {
    return UserLocationState(
      savedLocations: savedLocations ?? this.savedLocations,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      isSaving: isSaving ?? this.isSaving,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error ?? this.error,
      searchError: searchError ?? this.searchError,
    );
  }

  // Helper: Get default location if exists
  UserLocation? get defaultLocation => savedLocations.firstWhere(
    (UserLocation loc) => loc.isDefault,
  );

  // Helper: Check if a location is the default
  bool isDefault(String locationId) => savedLocations.any(
    (UserLocation loc) => loc.id == locationId && loc.isDefault,
  );
}
