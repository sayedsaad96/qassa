import 'package:supabase_flutter/supabase_flutter.dart';

abstract class RequestRemoteDataSource {
  Future<List<Map<String, dynamic>>> getRequestsByBrand(String brandId);
  Future<List<Map<String, dynamic>>> getAllActiveRequests({String? specialty});
  Future<Map<String, dynamic>> getRequestById(String requestId);
  Future<Map<String, dynamic>> createRequest(Map<String, dynamic> data);
  Future<void> updateRequestStatus(String id, String status);
}

class RequestRemoteDataSourceImpl implements RequestRemoteDataSource {
  final SupabaseClient _client;
  RequestRemoteDataSourceImpl(this._client);

  @override
  Future<List<Map<String, dynamic>>> getRequestsByBrand(String brandId) async {
    final data = await _client
        .from('requests')
        .select('*, offers(count)')
        .eq('brand_id', brandId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data).map((r) {
      final offerCount = ((r['offers'] as List?)?.isNotEmpty ?? false)
          ? (r['offers'] as List).first['count'] as int? ?? 0
          : 0;
      return {...r, 'offer_count': offerCount};
    }).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getAllActiveRequests(
      {String? specialty}) async {
    final data = await _client
        .from('requests')
        .select('*, offers(count)')
        .eq('status', 'active')
        .order('created_at', ascending: false);

    var results = List<Map<String, dynamic>>.from(data).map((r) {
      final offerCount = ((r['offers'] as List?)?.isNotEmpty ?? false)
          ? (r['offers'] as List).first['count'] as int? ?? 0
          : 0;
      return {...r, 'offer_count': offerCount};
    }).toList();

    if (specialty != null && specialty != 'الكل') {
      results = results.where((r) => r['product_type'] == specialty).toList();
    }
    return results;
  }

  @override
  Future<Map<String, dynamic>> getRequestById(String requestId) async {
    final data = await _client
        .from('requests')
        .select('*, offers(count)')
        .eq('id', requestId)
        .single();

    final offerCount = ((data['offers'] as List?)?.isNotEmpty ?? false)
        ? (data['offers'] as List).first['count'] as int? ?? 0
        : 0;
    return {...data, 'offer_count': offerCount};
  }

  @override
  Future<Map<String, dynamic>> createRequest(Map<String, dynamic> data) async {
    return await _client.from('requests').insert(data).select().single();
  }

  @override
  Future<void> updateRequestStatus(String id, String status) async {
    await _client
        .from('requests')
        .update({'status': status})
        .eq('id', id);
  }
}
