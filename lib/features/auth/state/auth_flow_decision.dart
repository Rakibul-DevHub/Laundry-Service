part of '../providers/auth_flow_providers.dart';

/// Sealed decision class (clean, type-safe)
sealed class AuthFlowDecision {
  const AuthFlowDecision();

  factory AuthFlowDecision.goToHome({required Role role}) = GoToHomeDecision;
  const factory AuthFlowDecision.goToOnboarding() = GoToOnboardingDecision;
  const factory AuthFlowDecision.goToLogin() = GoToLoginDecision;
  const factory AuthFlowDecision.goToRiderDocuments() = GoToRiderDocumentsDecision;
}

final class GoToHomeDecision extends AuthFlowDecision {
  final Role role;
  const GoToHomeDecision({required this.role});
}

class GoToOnboardingDecision extends AuthFlowDecision {
  const GoToOnboardingDecision();
}

class GoToLoginDecision extends AuthFlowDecision {
  const GoToLoginDecision();
}
class GoToRiderDocumentsDecision extends AuthFlowDecision {
  const GoToRiderDocumentsDecision();
}
