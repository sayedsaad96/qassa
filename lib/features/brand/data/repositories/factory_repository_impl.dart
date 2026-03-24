import 'package:dartz/dartz.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/factory_repository.dart';
import '../datasources/factory_remote_datasource.dart';
import '../models/models.dart';

class FactoryRepositoryImpl implements FactoryRepository {
  final FactoryRemoteDataSource _ds;
  FactoryRepositoryImpl(this._ds);

  @override
  Future<Either<String, List<FactoryEntity>>> getFactories({
    String? specialty,
    String? city,
  }) async {
    try {
      final data = await _ds.getFactories(specialty: specialty, city: city);
      return Right(data.map((j) => FactoryModel.fromJson(j).toEntity()).toList());
    } catch (e) {
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<String, FactoryEntity>> getFactoryById(String id) async {
    try {
      final data = await _ds.getFactoryById(id);
      return Right(FactoryModel.fromJson(data).toEntity());
    } catch (e) {
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<String, void>> createFactoryProfile(FactoryEntity factory) async {
    try {
      await _ds.createFactory(FactoryModel(
        id: factory.id,
        ownerId: factory.ownerId,
        name: factory.name,
        city: factory.city,
        specialties: factory.specialties,
        minQuantity: factory.minQuantity,
        leadTimeDays: factory.leadTimeDays,
        createdAt: factory.createdAt,
      ).toJson());
      return const Right(null);
    } catch (e) {
      return Left(_mapError(e));
    }
  }

  String _mapError(Object e) {
    final s = e.toString().toLowerCase();
    if (s.contains('network') || s.contains('socket') || s.contains('connection')) {
      return 'في مشكلة في الإنترنت، جرب تاني';
    }
    return 'حدث خطأ، حاول مرة أخرى';
  }
}
