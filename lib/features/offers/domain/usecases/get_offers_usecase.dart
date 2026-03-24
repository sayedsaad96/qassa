import 'package:dartz/dartz.dart';
import '../entities/offer_entity.dart';
import '../repositories/offer_repository.dart';

class GetOffersUseCase {
  final OfferRepository _repo;
  GetOffersUseCase(this._repo);

  Future<Either<String, List<OfferEntity>>> call({
    String? requestId,
    String? factoryId,
  }) {
    if (requestId != null) return _repo.getOffersByRequest(requestId);
    if (factoryId != null) return _repo.getOffersByFactory(factoryId);
    return Future.value(const Right([]));
  }
}
