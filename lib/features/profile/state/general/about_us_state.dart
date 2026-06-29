import 'package:flutter/foundation.dart';

@immutable
class AboutUsState {
  final String htmlContent;
  final bool isLoading;
  final String? error;

  const AboutUsState({
    this.htmlContent = '',
    this.isLoading = false,
    this.error,
  });

  AboutUsState copyWith({
    String? htmlContent,
    bool? isLoading,
    String? error,
  }) {
    return AboutUsState(
      htmlContent: htmlContent ?? this.htmlContent,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}