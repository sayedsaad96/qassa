import 'package:dartz/dartz.dart';
import '../entities/upload_image_params.dart';
import '../repositories/factory_profile_repository.dart';

class UploadPortfolioImagesUseCase {
  final FactoryProfileRepository repository;

  UploadPortfolioImagesUseCase(this.repository);

  Future<Either<String, List<String>>> call(
    String ownerId,
    List<UploadImageParams> images,
  ) async {
    return await repository.uploadPortfolioImages(ownerId, images);
  }
}
