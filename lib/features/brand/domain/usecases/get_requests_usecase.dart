import 'package:dartz/dartz.dart';
import '../entities/entities.dart';
import '../repositories/request_repository.dart';

class GetRequestsUseCase {
  final RequestRepository _repo;
  GetRequestsUseCase(this._repo);

  Future<Either<String, List<RequestEntity>>> call({
    String? brandId,
    String? specialty,
  }) {
    if (brandId != null) return _repo.getRequestsByBrand(brandId);
    return _repo.getAllActiveRequests(specialty: specialty);
  }
}
