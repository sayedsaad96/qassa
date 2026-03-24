import 'package:dartz/dartz.dart';
import '../entities/offer_entity.dart';
import '../repositories/offer_repository.dart';

class SendOfferUseCase {
  final OfferRepository _repo;
  SendOfferUseCase(this._repo);

  Future<Either<String, OfferEntity>> call({
    required String requestId,
    required String factoryId,
    required String factoryName,
    required double pricePerPiece,
    required int leadTimeDays,
    String? notes,
  }) =>
      _repo.sendOffer(
        requestId: requestId,
        factoryId: factoryId,
        factoryName: factoryName,
        pricePerPiece: pricePerPiece,
        leadTimeDays: leadTimeDays,
        notes: notes,
      );
}
