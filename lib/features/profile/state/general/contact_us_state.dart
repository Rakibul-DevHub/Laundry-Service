import 'package:flutter/foundation.dart';

@immutable
class ContactUsState {
  final String htmlContent;
  final bool isLoading;
  final String? error;

  const ContactUsState({
    this.htmlContent = '',
    this.isLoading = false,
    this.error,
  });

  ContactUsState copyWith({
    String? htmlContent,
    bool? isLoading,
    String? error,
  }) {
    return ContactUsState(
      htmlContent: htmlContent ?? this.htmlContent,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}