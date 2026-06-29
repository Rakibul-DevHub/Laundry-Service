import 'package:flutter/foundation.dart';

import '../models/banner_model.dart';

@immutable
class BannersState {
  final List<BannerModel> banners;
  final bool isLoading;
  final String? error;
  final int currentPage;

  const BannersState({
    this.banners = const <BannerModel>[],
    this.isLoading = false,
    this.error,
    this.currentPage = 0,
  });

  BannersState copyWith({
    List<BannerModel>? banners,
    bool? isLoading,
    String? error,
    int? currentPage,
  }) {
    return BannersState(
      banners: banners ?? this.banners,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
