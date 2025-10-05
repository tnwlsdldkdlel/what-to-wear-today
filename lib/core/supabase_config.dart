import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://eoiatgueebqotgmalgvg.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVvaWF0Z3VlZWJxb3RnbWFsZ3ZnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk2NDU1NzUsImV4cCI6MjA3NTIyMTU3NX0.0GcxTtLMgXQ-F8XQyE6CzRGkgk6kme5XN7pfu2CsQtw';

  static Future<void> initialize() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }
}
