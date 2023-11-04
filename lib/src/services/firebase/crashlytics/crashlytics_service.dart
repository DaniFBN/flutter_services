import 'dart:isolate';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

final class CrashlyticsService {
  CrashlyticsService._();

  static final instance = CrashlyticsService._();
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  // Ignored because method name is self explanatory
  // ignore: avoid_positional_boolean_parameters
  Future<void> enableCrashlytics(bool enabled) async {
    await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
  }

  Future<void> setCustomKey(String key, String value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  Future<void> reportError(Object message, StackTrace stackTrace) async {
    await _crashlytics.recordError(message, stackTrace);
  }

  Future<void> reportFlutterError(FlutterErrorDetails details) async {
    await _crashlytics.recordFlutterError(details);
  }

  static SendPort get isolateErrorListener {
    return RawReceivePort((pair) async {
      final List errorAndStacktrace = pair;
      final exception = errorAndStacktrace[0];
      final stackTrace = errorAndStacktrace[1];

      await FirebaseCrashlytics.instance.recordError(exception, stackTrace);
    }).sendPort;
  }
}
