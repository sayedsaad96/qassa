import 'package:dartz/dartz.dart';
import '../entities/factory_profile_entity.dart';
import '../repositories/factory_profile_repository.dart';

class UpdateFactoryProfileUseCase {
  final FactoryProfileRepository repository;

  UpdateFactoryProfileUseCase(this.repository);

  Future<Either<String, FactoryProfileEntity>> call(
    FactoryProfileEntity profile,
  ) async {
    return await repository.updateProfile(profile);
  }
}
