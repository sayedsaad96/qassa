import 'package:dartz/dartz.dart';
import '../entities/factory_profile_entity.dart';
import '../repositories/factory_profile_repository.dart';

class CreateFactoryProfileUseCase {
  final FactoryProfileRepository repository;

  CreateFactoryProfileUseCase(this.repository);

  Future<Either<String, FactoryProfileEntity>> call(
    FactoryProfileEntity profile,
  ) async {
    return await repository.createProfile(profile);
  }
}
