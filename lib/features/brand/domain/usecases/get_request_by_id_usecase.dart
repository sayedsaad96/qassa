import 'package:dartz/dartz.dart';
import '../entities/entities.dart';
import '../repositories/request_repository.dart';

class GetRequestByIdUseCase {
  final RequestRepository _repo;
  GetRequestByIdUseCase(this._repo);

  Future<Either<String, RequestEntity>> call(String requestId) =>
      _repo.getRequestById(requestId);
}
