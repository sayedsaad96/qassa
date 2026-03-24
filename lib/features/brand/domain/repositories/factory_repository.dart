import 'package:dartz/dartz.dart';
import '../entities/entities.dart';

abstract class FactoryRepository {
  Future<Either<String, List<FactoryEntity>>> getFactories({
    String? specialty,
    String? city,
  });
  Future<Either<String, FactoryEntity>> getFactoryById(String id);
  Future<Either<String, void>> createFactoryProfile(FactoryEntity factory);
}
