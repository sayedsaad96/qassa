import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/offer_entity.dart';

// ════════════════════════════════════
// OFFER MODEL
// ════════════════════════════════════
class OfferModel {
  final String id;
  final String requestId;
  final String factoryId;
  final String factoryName;
  final double factoryRating;
  final double pricePerPiece;
  final int leadTimeDays;
  final String? notes;
  final String status;
  final DateTime createdAt;
  final int quantity;
  final String productType;

  const OfferModel({
    required this.id,
    required this.requestId,
    required this.factoryId,
    required this.factoryName,
    this.factoryRating = 0.0,
    required this.pricePerPiece,
    required this.leadTimeDays,
    this.notes,
    this.status = 'pending',
    required this.createdAt,
    this.quantity = 0,
    this.productType = '',
  });

  factory OfferModel.fromJson(Map<String, dynamic> j) => OfferModel(
        id: j['id'] as String,
        requestId: j['request_id'] as String,
        factoryId: j['factory_id'] as String,
        factoryName: j['factory_name'] as String? ?? 'مصنع',
        factoryRating: (j['factory_rating'] as num?)?.toDouble() ?? 0.0,
        pricePerPiece: (j['price_per_piece'] as num).toDouble(),
        leadTimeDays: (j['lead_time_days'] as num).toInt(),
        notes: j['notes'] as String?,
        status: j['status'] as String? ?? 'pending',
        createdAt: DateTime.parse(
            j['created_at'] as String? ?? DateTime.now().toIso8601String()),
        quantity: (j['quantity'] as num?)?.toInt() ?? 0,
        productType: j['product_type'] as String? ?? '',
      );

  Map<String, dynamic> toInsertJson() => {
        'request_id': requestId,
        'factory_id': factoryId,
        'factory_name': factoryName,
        'factory_rating': factoryRating,
        'price_per_piece': pricePerPiece,
        'lead_time_days': leadTimeDays,
        if (notes != null) 'notes': notes,
        'status': 'pending',
      };

  OfferEntity toEntity() {
    OfferStatus entityStatus;
    switch (status) {
      case 'accepted':
        entityStatus = OfferStatus.accepted;
        break;
      case 'rejected':
        entityStatus = OfferStatus.rejected;
        break;
      default:
        entityStatus = OfferStatus.pending;
    }
    return OfferEntity(
      id: id,
      requestId: requestId,
      factoryId: factoryId,
      factoryName: factoryName,
      factoryRating: factoryRating,
      pricePerPiece: pricePerPiece,
      leadTimeDays: leadTimeDays,
      notes: notes,
      status: entityStatus,
      createdAt: createdAt,
      quantity: quantity,
      productType: productType,
    );
  }
}

// ════════════════════════════════════
// OFFER REMOTE DATASOURCE
// ════════════════════════════════════
abstract class OfferRemoteDataSource {
  Future<List<Map<String, dynamic>>> getOffersByRequest(String requestId);
  Future<List<Map<String, dynamic>>> getOffersByFactory(String factoryId);
  Future<Map<String, dynamic>> sendOffer(Map<String, dynamic> data);
  Future<void> updateOfferStatus(String offerId, String status);
}

class OfferRemoteDataSourceImpl implements OfferRemoteDataSource {
  final SupabaseClient _client;
  OfferRemoteDataSourceImpl(this._client);

  @override
  Future<List<Map<String, dynamic>>> getOffersByRequest(String requestId) async {
    final offers = await _client
        .from('offers')
        .select()
        .eq('request_id', requestId)
        .order('price_per_piece', ascending: true);

    final request = await _client
        .from('requests')
        .select('quantity, product_type')
        .eq('id', requestId)
        .maybeSingle();

    return List<Map<String, dynamic>>.from(offers)
        .map((o) => {
              ...o,
              'quantity': request?['quantity'] ?? 0,
              'product_type': request?['product_type'] ?? '',
            })
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getOffersByFactory(String factoryId) async {
    final offers = await _client
        .from('offers')
        .select('*, requests(quantity, product_type)')
        .eq('factory_id', factoryId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(offers).map((o) {
      final req = o['requests'] as Map<String, dynamic>?;
      return {
        ...o,
        'quantity': req?['quantity'] ?? 0,
        'product_type': req?['product_type'] ?? '',
        'requests': null,
      };
    }).toList();
  }

  @override
  Future<Map<String, dynamic>> sendOffer(Map<String, dynamic> data) async {
    return await _client.from('offers').insert(data).select().single();
  }

  @override
  Future<void> updateOfferStatus(String offerId, String status) async {
    await _client
        .from('offers')
        .update({'status': status})
        .eq('id', offerId);
  }
}
