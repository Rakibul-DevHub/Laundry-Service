import 'package:flutter/foundation.dart';

@immutable
class TermsAndConditionsState {
  final String htmlContent;
  final bool isLoading;
  final String? error;

  const TermsAndConditionsState({
    this.htmlContent = '',
    this.isLoading = false,
    this.error,
  });

  TermsAndConditionsState copyWith({
    String? htmlContent,
    bool? isLoading,
    String? error,
  }) {
    return TermsAndConditionsState(
      htmlContent: htmlContent ?? this.htmlContent,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}