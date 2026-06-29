import 'package:flutter/foundation.dart';

@immutable
class PrivacyPolicyState {
  final String htmlContent;
  final bool isLoading;
  final String? error;

  const PrivacyPolicyState({
    this.htmlContent = '',
    this.isLoading = false,
    this.error,
  });

  PrivacyPolicyState copyWith({
    String? htmlContent,
    bool? isLoading,
    String? error,
  }) {
    return PrivacyPolicyState(
      htmlContent: htmlContent ?? this.htmlContent,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}