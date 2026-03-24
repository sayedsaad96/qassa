import 'package:dartz/dartz.dart';
import '../entities/entities.dart';
import '../repositories/factory_repository.dart';

class GetFactoriesUseCase {
  final FactoryRepository _repo;
  GetFactoriesUseCase(this._repo);

  Future<Either<String, List<FactoryEntity>>> call({
    String? specialty,
    String? city,
  }) =>
      _repo.getFactories(specialty: specialty, city: city);
}

class GetFactoryByIdUseCase {
  final FactoryRepository _repo;
  GetFactoryByIdUseCase(this._repo);

  Future<Either<String, FactoryEntity>> call(String id) =>
      _repo.getFactoryById(id);
}
