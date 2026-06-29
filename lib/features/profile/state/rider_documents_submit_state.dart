import 'package:flutter/foundation.dart';

@immutable
class RiderDocumentsSubmitState {
  final bool isSubmitting;

  const RiderDocumentsSubmitState({
    this.isSubmitting = false,
  });

  RiderDocumentsSubmitState copyWith({
    bool? isSubmitting,
  }) {
    return RiderDocumentsSubmitState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
