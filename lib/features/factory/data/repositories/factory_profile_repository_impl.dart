import 'package:dartz/dartz.dart';
import '../../domain/entities/factory_profile_entity.dart';
import '../../domain/entities/upload_image_params.dart';
import '../../domain/repositories/factory_profile_repository.dart';
import '../datasources/factory_profile_remote_datasource.dart';
import '../models/factory_profile_model.dart';

class FactoryProfileRepositoryImpl implements FactoryProfileRepository {
  final FactoryProfileRemoteDataSource remoteDataSource;

  FactoryProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, FactoryProfileEntity>> getProfile(
    String ownerId,
  ) async {
    try {
      final profile = await remoteDataSource.getProfile(ownerId);
      if (profile == null) {
        return const Left('Profile not found');
      }
      return Right(profile.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, FactoryProfileEntity>> createProfile(
    FactoryProfileEntity profile,
  ) async {
    try {
      final model = FactoryProfileModel.fromEntity(profile);
      final createdProfile = await remoteDataSource.createProfile(model);
      return Right(createdProfile.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, FactoryProfileEntity>> updateProfile(
    FactoryProfileEntity profile,
  ) async {
    try {
      final model = FactoryProfileModel.fromEntity(profile);
      final updatedProfile = await remoteDataSource.updateProfile(model);
      return Right(updatedProfile.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<String>>> uploadPortfolioImages(
    String ownerId,
    List<UploadImageParams> images,
  ) async {
    try {
      final urls = await remoteDataSource.uploadPortfolioImages(
        ownerId,
        images,
      );
      return Right(urls);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
