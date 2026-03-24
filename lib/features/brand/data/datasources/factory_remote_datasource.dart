import 'package:supabase_flutter/supabase_flutter.dart';

// ════════════════════════════════════
// FACTORY DATASOURCE
// ════════════════════════════════════
abstract class FactoryRemoteDataSource {
  Future<List<Map<String, dynamic>>> getFactories({
    String? specialty,
    String? city,
  });
  Future<Map<String, dynamic>> getFactoryById(String id);
  Future<void> createFactory(Map<String, dynamic> data);
}

class FactoryRemoteDataSourceImpl implements FactoryRemoteDataSource {
  final SupabaseClient _client;
  FactoryRemoteDataSourceImpl(this._client);

  @override
  Future<List<Map<String, dynamic>>> getFactories({
    String? specialty,
    String? city,
  }) async {
    var query = _client
        .from('factories')
        .select()
        .order('rating', ascending: false);

    final data = await query;

    // Client-side filter for specialties (array contains)
    var results = List<Map<String, dynamic>>.from(data);
    if (specialty != null && specialty != 'الكل') {
      results = results
          .where((f) =>
              (f['specialties'] as List?)?.contains(specialty) ?? false)
          .toList();
    }
    if (city != null) {
      results = results
          .where((f) => (f['city'] as String?) == city)
          .toList();
    }
    return results;
  }

  @override
  Future<Map<String, dynamic>> getFactoryById(String id) async {
    return await _client.from('factories').select().eq('id', id).single();
  }

  @override
  Future<void> createFactory(Map<String, dynamic> data) async {
    await _client.from('factories').upsert(data);
  }
}

