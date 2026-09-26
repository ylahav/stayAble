import 'dart:io';

import 'package:flutter/foundation.dart';

/// Compile-time fallback used as the default StayAble site.
/// Standalone weekly catalog checks use this when no server was saved.
/// Network setup and Settings can override it.
String resolvePayloadUrl() {
  const fromEnv = String.fromEnvironment('PAYLOAD_URL');
  if (fromEnv.isNotEmpty) return normalizePayloadUrl(fromEnv);
  if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:3000';
  return 'http://localhost:3000';
}

String normalizePayloadUrl(String raw) {
  var value = raw.trim();
  if (value.isEmpty) {
    throw const FormatException('Server address is empty');
  }
  if (!value.contains('://')) {
    value = 'https://$value';
  }
  final uri = Uri.tryParse(value);
  if (uri == null || uri.host.isEmpty) {
    throw const FormatException('Server address is not a valid URL');
  }
  if (uri.scheme != 'http' && uri.scheme != 'https') {
    throw const FormatException('Server address must start with http or https');
  }
  if (value.endsWith('/')) {
    return value.substring(0, value.length - 1);
  }
  return value;
}
