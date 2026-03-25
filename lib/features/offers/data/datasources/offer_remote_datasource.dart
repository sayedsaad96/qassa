import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/offer_entity.dart';

part 'offer_remote_datasource.freezed.dart';
part 'offer_remote_datasource.g.dart';

// ════════════════════════════════════
// OFFER MODEL
// ════════════════════════════════════
@freezed
abstract class OfferModel with _$OfferModel {
  const OfferModel._();

  const factory OfferModel({
    required String id,
    @JsonKey(name: 'request_id') required String requestId,
    @JsonKey(name: 'factory_id') required String factoryId,
    @JsonKey(name: 'factory_name') @Default('مصنع') String factoryName,
    @JsonKey(name: 'factory_rating') @Default(0.0) double factoryRating,
    @JsonKey(name: 'price_per_piece') required double pricePerPiece,
    @JsonKey(name: 'lead_time_days') required int leadTimeDays,
    String? notes,
    @Default('pending') String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default(0) int quantity,
    @JsonKey(name: 'product_type') @Default('') String productType,
  }) = _OfferModel;

  factory OfferModel.fromJson(Map<String, dynamic> json) =>
      _$OfferModelFromJson(json);

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
  Future<List<Map<String, dynamic>>> getOffersByRequest(
    String requestId,
  ) async {
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
        .map(
          (o) => {
            ...o,
            'quantity': request?['quantity'] ?? 0,
            'product_type': request?['product_type'] ?? '',
          },
        )
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getOffersByFactory(
    String factoryId,
  ) async {
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
    await _client.from('offers').update({'status': status}).eq('id', offerId);
  }
}
