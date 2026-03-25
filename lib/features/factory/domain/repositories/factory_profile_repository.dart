import 'package:dartz/dartz.dart';
import '../entities/factory_profile_entity.dart';
import '../entities/upload_image_params.dart';

abstract class FactoryProfileRepository {
  Future<Either<String, FactoryProfileEntity>> getProfile(String ownerId);
  Future<Either<String, FactoryProfileEntity>> createProfile(
    FactoryProfileEntity profile,
  );
  Future<Either<String, FactoryProfileEntity>> updateProfile(
    FactoryProfileEntity profile,
  );
  Future<Either<String, List<String>>> uploadPortfolioImages(
    String ownerId,
    List<UploadImageParams> images,
  );
}
