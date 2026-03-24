import 'package:dartz/dartz.dart';
import '../repositories/offer_repository.dart';

class AcceptOfferUseCase {
  final OfferRepository _repo;
  AcceptOfferUseCase(this._repo);

  Future<Either<String, void>> call(String offerId) =>
      _repo.acceptOffer(offerId);
}
