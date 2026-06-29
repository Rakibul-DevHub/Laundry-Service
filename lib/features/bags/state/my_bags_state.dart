import 'package:flutter/foundation.dart';
import '../models/bag_model.dart';

@immutable
class MyBagsState {
  final List<BagModel> bags;
  final bool isLoading;
  final String? error;

  const MyBagsState({
    this.bags = const <BagModel>[],
    this.isLoading = false,
    this.error,
  });

  MyBagsState copyWith({
    List<BagModel>? bags,
    bool? isLoading,
    String? error,
  }) {
    return MyBagsState(
      bags: bags ?? this.bags,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
