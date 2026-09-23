import 'package:flutter/services.dart';

Future<String>? _cached;

/// Version string from pubspec.yaml (`1.0.1` or `1.0.1+3`).
Future<String> loadAppVersionLabel() {
  return _cached ??= _load();
}

Future<String> _load() async {
  final source = await rootBundle.loadString('pubspec.yaml');
  final raw = parsePubspecVersion(source) ?? '0.0.0';
  return 'v$raw';
}

String? parsePubspecVersion(String source) {
  for (final line in source.split('\n')) {
    final trimmed = line.trim();
    if (trimmed.startsWith('#') || !trimmed.startsWith('version:')) continue;
    final value = trimmed
        .substring('version:'.length)
        .trim()
        .replaceAll('"', '')
        .replaceAll("'", '');
    if (value.isNotEmpty) return value;
  }
  return null;
}
