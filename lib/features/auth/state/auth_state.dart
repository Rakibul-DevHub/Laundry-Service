part of '../providers/auth_providers.dart';

class AuthState {
  final bool isLoggedIn;
  final Role? role;

  const AuthState({this.isLoggedIn = false, this.role});

  AuthState copyWith({bool? isLoggedIn, Role? role}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      role: role ?? this.role,
    );
  }

  @override
  String toString() {
    return "AuthState ==> isLoggedIn : $isLoggedIn || role : $role";
  }
}
