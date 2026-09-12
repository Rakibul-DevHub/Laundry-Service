part of '../providers/auth_providers.dart';

class AuthState {
  final bool isLoggedIn;
  final Role? role;
  final bool isInitialized;

  const AuthState({
    this.isLoggedIn = false,
    this.role,
    this.isInitialized = false,
  });

  AuthState copyWith({bool? isLoggedIn, Role? role, bool? isInitialized}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      role: role ?? this.role,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  String toString() {
    return "AuthState ==> isLoggedIn : $isLoggedIn || role : $role || isInitialized : $isInitialized";
  }
}
