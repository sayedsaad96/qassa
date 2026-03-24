import 'package:dartz/dartz.dart';
import '../entities/offer_entity.dart';

abstract class OfferRepository {
  Future<Either<String, List<OfferEntity>>> getOffersByRequest(String requestId);
  Future<Either<String, List<OfferEntity>>> getOffersByFactory(String factoryId);
  Future<Either<String, OfferEntity>> sendOffer({
    required String requestId,
    required String factoryId,
    required String factoryName,
    required double pricePerPiece,
    required int leadTimeDays,
    String? notes,
  });
  Future<Either<String, void>> acceptOffer(String offerId);
  Future<Either<String, void>> rejectOffer(String offerId);
}
