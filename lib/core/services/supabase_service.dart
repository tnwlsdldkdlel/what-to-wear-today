import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/outfit_submission.dart';

class SupabaseService {
  SupabaseClient get _client => Supabase.instance.client;

  Future<void> submitOutfit(OutfitSubmission submission) async {
    try {
      await _client.from('outfit_submissions').insert(submission.toJson());
    } on PostgrestException catch (error) {
      throw StateError('Failed to submit outfit: ${error.message}');
    }
  }
}
