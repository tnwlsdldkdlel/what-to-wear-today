import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnvironment {
  const AppEnvironment();

  String get supabaseUrl => _read('SUPABASE_URL');

  String get supabaseAnonKey => _read('SUPABASE_ANON_KEY');

  String _read(String key) {
    final value = dotenv.maybeGet(key) ?? Platform.environment[key];
    if (value == null || value.isEmpty) {
      throw StateError('Missing required environment variable: $key');
    }
    return value;
  }
}
