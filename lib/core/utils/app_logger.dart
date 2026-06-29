import 'dart:developer' as developer;

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

    // Get the caller info (skip the first few frames)
    final String callerInfo = _getCallerInfo();

    final String emoji = _getLevelEmoji(level);
    final String timestamp = DateTime.now().toIso8601String();

    // Format: 🐞 2025-01-05T10:00:00.000
    //         message
    //         at path/to/file.dart:123
    final String formattedMessage =
        '''
    $emoji $timestamp
    $message
    at $callerInfo'''
            .trim();

    developer.log(
      formattedMessage,
      name: level.name.toUpperCase(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  String _getCallerInfo() {
    try {
      final StackTrace stackTrace = StackTrace.current;
      final List<String> frames = stackTrace.toString().split('\n');

      // Look for the first frame outside this logger
      for (int i = 3; i < frames.length; i++) {
        final String frame = frames[i].trim();
        if (!frame.startsWith('#')){
           continue;
        }

        // Example: "#3      someMethod (package:app/main.dart:42:15)"
        final int openParen = frame.indexOf('(');
        final int closeParen = frame.indexOf(')', openParen);
        if (openParen == -1 || closeParen == -1){
           continue;
        }

        final String location = frame.substring(
          openParen + 1,
          closeParen,
        ); // "package:app/main.dart:42:15"

        // Convert "package:app/..." → "lib/..."
        String filePath;
        if (location.startsWith('package:app/')) {
          // Replace "package:app/" with "lib/"
          filePath = 'lib/${location.substring('package:app/'.length)}';
        } else if (location.startsWith('package:')) {
          // Fallback: just remove "package:xyz/"
          final int slashIndex = location.indexOf('/', 'package:'.length);
          if (slashIndex != -1) {
            filePath = 'lib/${location.substring(slashIndex + 1)}';
          } else {
            filePath = location;
          }
        } else {
          filePath = location;
        }

        // Remove column number (everything after last :)
        final int lastColon = filePath.lastIndexOf(':');
        if (lastColon != -1) {
          final String linePart = filePath.substring(lastColon + 1);
          if (linePart.allMatches(RegExp(r'^\d+$').toString()).isNotEmpty) {
            // It's a line number, so keep file:line
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
