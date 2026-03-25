import 'package:dartz/dartz.dart';
import '../entities/factory_profile_entity.dart';
import '../repositories/factory_profile_repository.dart';

class GetFactoryProfileUseCase {
  final FactoryProfileRepository repository;

  GetFactoryProfileUseCase(this.repository);

  Future<Either<String, FactoryProfileEntity>> call(String ownerId) async {
    return await repository.getProfile(ownerId);
  }
}
