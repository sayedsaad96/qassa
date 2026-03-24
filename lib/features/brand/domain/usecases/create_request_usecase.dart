import 'package:dartz/dartz.dart';
import '../entities/entities.dart';
import '../repositories/request_repository.dart';

class CreateRequestUseCase {
  final RequestRepository _repo;
  CreateRequestUseCase(this._repo);

  Future<Either<String, RequestEntity>> call(RequestEntity request) =>
      _repo.createRequest(request);
}
