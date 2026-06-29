// features/services/user/state/user_services_state.dart

import '../models/user_service_model.dart';

class UserServicesState {
  final List<UserServiceModel> services;
  final bool isLoading;
  final bool isLoadingMore; // For pagination
  final String? error;
  final int currentPage;
  final int totalPages;

  const UserServicesState({
    this.services = const <UserServiceModel>[],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  UserServicesState copyWith({
    List<UserServiceModel>? services,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    int? totalPages,
  }) {
    return UserServicesState(
      services: services ?? this.services,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
