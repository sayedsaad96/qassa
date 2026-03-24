import 'package:dartz/dartz.dart';
import '../../domain/entities/offer_entity.dart';
import '../../domain/repositories/offer_repository.dart';
import '../datasources/offer_remote_datasource.dart';

class OfferRepositoryImpl implements OfferRepository {
  final OfferRemoteDataSource _ds;
  OfferRepositoryImpl(this._ds);

  @override
  Future<Either<String, List<OfferEntity>>> getOffersByRequest(
      String requestId) async {
    try {
      final data = await _ds.getOffersByRequest(requestId);
      return Right(data.map((j) => OfferModel.fromJson(j).toEntity()).toList());
    } catch (e) {
      return Left(_err(e));
    }
  }

  @override
  Future<Either<String, List<OfferEntity>>> getOffersByFactory(
      String factoryId) async {
    try {
      final data = await _ds.getOffersByFactory(factoryId);
      return Right(data.map((j) => OfferModel.fromJson(j).toEntity()).toList());
    } catch (e) {
      return Left(_err(e));
    }
  }

  @override
  Future<Either<String, OfferEntity>> sendOffer({
    required String requestId,
    required String factoryId,
    required String factoryName,
    required double pricePerPiece,
    required int leadTimeDays,
    String? notes,
  }) async {
    try {
      final data = await _ds.sendOffer({
        'request_id': requestId,
        'factory_id': factoryId,
        'factory_name': factoryName,
        'price_per_piece': pricePerPiece,
        'lead_time_days': leadTimeDays,
        'notes': ?notes,
        'status': 'pending',
      });
      return Right(OfferModel.fromJson(data).toEntity());
    } catch (e) {
      return Left(_err(e));
    }
  }

  @override
  Future<Either<String, void>> acceptOffer(String offerId) async {
    try {
      await _ds.updateOfferStatus(offerId, 'accepted');
      return const Right(null);
    } catch (e) {
      return Left(_err(e));
    }
  }

  @override
  Future<Either<String, void>> rejectOffer(String offerId) async {
    try {
      await _ds.updateOfferStatus(offerId, 'rejected');
      return const Right(null);
    } catch (e) {
      return Left(_err(e));
    }
  }

  String _err(Object e) {
    final s = e.toString().toLowerCase();
    if (s.contains('network') || s.contains('socket') ||
        s.contains('connection')) {
      return 'في مشكلة في الإنترنت، جرب تاني';
    }
    return 'حدث خطأ، حاول مرة أخرى';
  }
}
