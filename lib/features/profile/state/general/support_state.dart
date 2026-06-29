import 'package:flutter/foundation.dart';

@immutable
class SupportState {
  final String htmlContent;
  final bool isLoading;
  final String? error;

  const SupportState({
    this.htmlContent = '',
    this.isLoading = false,
    this.error,
  });

  SupportState copyWith({
    String? htmlContent,
    bool? isLoading,
    String? error,
  }) {
    return SupportState(
      htmlContent: htmlContent ?? this.htmlContent,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}