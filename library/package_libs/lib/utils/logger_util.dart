import 'dart:developer' as developer;

import 'package:logger/logger.dart';

class LoggerUtil {
  static final Logger logger = Logger(
      filter: null,
      printer: PrettyPrinter(
        stackTraceBeginIndex: 2,
        methodCount: 2,
        colors: true,
        printEmojis: false,
        noBoxingByDefault: false,
      ),
      output: null);

  static void init() {
    Logger.level = Level.all;
  }

  static void log(dynamic message, {LoggerType type = LoggerType.info}) {
    loggerWithType(message, type: type);
  }

  static void loggerWithType(
    dynamic message, {
    LoggerType type = LoggerType.debug,
  }) {
    switch (type) {
      case LoggerType.trace:
        logger.t(message);
        break;
      case LoggerType.debug:
        logger.d(message);
        break;
      case LoggerType.info:
        logger.i(message);
        break;
      case LoggerType.warning:
        logger.w(message);
        break;
      case LoggerType.error:
        logger.e(message);
        break;
      case LoggerType.fatal:
        logger.f(message);
        break;
      case LoggerType.easy:
        developer.log(message.toString());
        break;
    }
  }

  static void warning(dynamic message, {Object? error, StackTrace? stackTrace}) {
    logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void error(dynamic message, {Object? error, StackTrace? stackTrace}) {
    logger.e(message, error: error, stackTrace: stackTrace);
  }
}

enum LoggerType {
  trace,
  debug,
  info,
  warning,
  error,
  fatal,
  easy,
}

void log(dynamic message, {LoggerType type = LoggerType.easy}) {
  LoggerUtil.loggerWithType(message, type: type);
}
