import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warn, error }

class Log {
  static LogLevel _minLevel = kDebugMode ? LogLevel.debug : LogLevel.info;

  static void setMinLevel(LogLevel level) => _minLevel = level;

  static void d(String tag, String message) => _log(LogLevel.debug, tag, message);
  static void i(String tag, String message) => _log(LogLevel.info, tag, message);
  static void w(String tag, String message) => _log(LogLevel.warn, tag, message);
  static void e(String tag, String message, [Object? error, StackTrace? stack]) {
    _log(LogLevel.error, tag, message);
    if (error != null) {
      _log(LogLevel.error, tag, 'Error: $error');
    }
    if (stack != null && kDebugMode) {
      _log(LogLevel.error, tag, 'Stack: $stack');
    }
  }

  static void _log(LogLevel level, String tag, String message) {
    if (level.index < _minLevel.index) return;
    final prefix = switch (level) {
      LogLevel.debug => 'D',
      LogLevel.info => 'I',
      LogLevel.warn => 'W',
      LogLevel.error => 'E',
    };
    final line = '[$prefix/$tag] $message';
    dev.log(line, name: 'AlpinSession');
    if (kDebugMode) {
      // ignore: avoid_print
      print(line);
    }
  }
}
