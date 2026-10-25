import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Usage:
/// ```dart
/// logger.t('trace — very verbose');
/// logger.d('debug — development detail');
/// logger.i('info — notable event');
/// logger.w('warning — something unexpected but recoverable');
/// logger.e('error — something failed', error: e, stackTrace: s);
/// logger.f('fatal — unrecoverable');
/// ```
final logger = Logger(
  // In release builds suppress everything below warnings to keep logs clean.
  level: kReleaseMode ? Level.warning : Level.trace,
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 100,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);
