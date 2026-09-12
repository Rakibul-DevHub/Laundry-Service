import 'dart:convert';

import '../../shared/enums/role.dart';

class JwtUtils {
  JwtUtils._();

  static bool isAccessTokenActive(String? token) {
    if (token == null || token.trim().isEmpty) {
      return false;
    }

    final Map<String, dynamic>? payload = decodePayload(token);
    if (payload == null) {
      return true;
    }

    final Object? exp = payload['exp'];
    if (exp is! num) {
      return true;
    }

    final DateTime expiry = DateTime.fromMillisecondsSinceEpoch(
      exp.toInt() * 1000,
      isUtc: true,
    );
    return DateTime.now().toUtc().isBefore(
      expiry.subtract(const Duration(seconds: 15)),
    );
  }

  static Role? roleFromToken(String? token) {
    final Map<String, dynamic>? payload = decodePayload(token);
    if (payload == null) {
      return null;
    }
    return Role.fromString(
      (payload['role'] ?? payload['authRole'])?.toString(),
    );
  }

  static Map<String, dynamic>? decodePayload(String? token) {
    if (token == null || token.isEmpty) {
      return null;
    }

    final List<String> parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }

    try {
      final String normalized = base64Url.normalize(parts[1]);
      final String decoded = utf8.decode(base64Url.decode(normalized));
      final Object? json = jsonDecode(decoded);
      if (json is Map) {
        return json.map(
          (dynamic key, dynamic value) =>
              MapEntry<String, dynamic>(key.toString(), value),
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
