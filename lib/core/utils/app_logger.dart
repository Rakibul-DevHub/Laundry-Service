import 'package:flutter/foundation.dart'; // Replaced dart:developer

enum LogLevel { debug, info, warning, error }

class AppLogger {
  static AppLogger? _instance;
  AppLogger._internal();
  factory AppLogger() {
    _instance ??= AppLogger._internal();
    return _instance!;
  }

  bool enableLogs = true;

  void d(String message) {
    _log(LogLevel.debug, message);
  }

  void i(String message) {
    _log(LogLevel.info, message);
  }

  void w(String message) {
    _log(LogLevel.warning, message);
  }

  void e(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace);
  }

  void _log(
      LogLevel level,
      String message, {
        Object? error,
        StackTrace? stackTrace,
      }) {
    if (!enableLogs) {
      return;
    }

    final String callerInfo = _getCallerInfo();
    final String emoji = _getLevelEmoji(level);
    final String timestamp = DateTime.now().toIso8601String();

    final String formattedMessage = '''
$emoji $timestamp
$message
at $callerInfo'''
        .trim();

    // Switched to debugPrint for guaranteed console visibility
    debugPrint(formattedMessage);

    // Print actual error and stacktrace if provided
    if (error != null) debugPrint('Error: $error');
    if (stackTrace != null) debugPrint('Stack Trace:\n$stackTrace');
  }

  String _getCallerInfo() {
    try {
      final StackTrace stackTrace = StackTrace.current;
      final List<String> frames = stackTrace.toString().split('\n');

      for (int i = 3; i < frames.length; i++) {
        final String frame = frames[i].trim();
        if (!frame.startsWith('#')) {
          continue;
        }

        final int openParen = frame.indexOf('(');
        final int closeParen = frame.indexOf(')', openParen);
        if (openParen == -1 || closeParen == -1) {
          continue;
        }

        final String location = frame.substring(openParen + 1, closeParen);
        String filePath;

        // Made this dynamic so it works for drop_n_fresh or any package name
        if (location.startsWith('package:')) {
          final int slashIndex = location.indexOf('/', 'package:'.length);
          if (slashIndex != -1) {
            filePath = 'lib/${location.substring(slashIndex + 1)}';
          } else {
            filePath = location;
          }
        } else {
          filePath = location;
        }

        final int lastColon = filePath.lastIndexOf(':');
        if (lastColon != -1) {
          final String linePart = filePath.substring(lastColon + 1);
          // Fixed the Regex check
          if (RegExp(r'^\d+$').hasMatch(linePart)) {
            filePath = filePath.substring(0, lastColon);
          }
        }

        return filePath;
      }
      return 'unknown:0';
    } catch (e) {
      return 'logger_error:0';
    }
  }

  String _getLevelEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🐞';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
    }
  }
}