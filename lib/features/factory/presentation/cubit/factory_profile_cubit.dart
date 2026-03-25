import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/factory_profile_entity.dart';
import '../../domain/usecases/get_factory_profile_usecase.dart';
import '../../domain/usecases/create_factory_profile_usecase.dart';
import '../../domain/usecases/update_factory_profile_usecase.dart';
import '../../domain/usecases/upload_portfolio_images_usecase.dart';
import '../../domain/entities/upload_image_params.dart';

abstract class FactoryProfileState extends Equatable {
  const FactoryProfileState();

  @override
  List<Object?> get props => [];
}

class FactoryProfileInitial extends FactoryProfileState {}

class FactoryProfileLoading extends FactoryProfileState {}

class FactoryProfileLoaded extends FactoryProfileState {
  final FactoryProfileEntity profile;

  const FactoryProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class FactoryProfileCreated extends FactoryProfileState {
  final FactoryProfileEntity profile;

  const FactoryProfileCreated(this.profile);

  @override
  List<Object?> get props => [profile];
}

class FactoryProfileUpdated extends FactoryProfileState {
  final FactoryProfileEntity profile;

  const FactoryProfileUpdated(this.profile);

  @override
  List<Object?> get props => [profile];
}

class FactoryProfileNotFound extends FactoryProfileState {}

class FactoryProfileError extends FactoryProfileState {
  final String message;

  const FactoryProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class FactoryProfileCubit extends Cubit<FactoryProfileState> {
  final GetFactoryProfileUseCase getFactoryProfileUseCase;
  final CreateFactoryProfileUseCase createFactoryProfileUseCase;
  final UpdateFactoryProfileUseCase updateFactoryProfileUseCase;
  final UploadPortfolioImagesUseCase uploadPortfolioImagesUseCase;

  FactoryProfileCubit({
    required this.getFactoryProfileUseCase,
    required this.createFactoryProfileUseCase,
    required this.updateFactoryProfileUseCase,
    required this.uploadPortfolioImagesUseCase,
  }) : super(FactoryProfileInitial());

  Future<void> loadProfile(String ownerId) async {
    emit(FactoryProfileLoading());
    final result = await getFactoryProfileUseCase(ownerId);
    result.fold((error) {
      if (error == 'Profile not found') {
        emit(FactoryProfileNotFound());
      } else {
        emit(FactoryProfileError(error));
      }
    }, (profile) => emit(FactoryProfileLoaded(profile)));
  }

  Future<void> createProfile(
    FactoryProfileEntity profile, {
    List<UploadImageParams>? newImages,
  }) async {
    emit(FactoryProfileLoading());

    if (newImages != null && newImages.isNotEmpty) {
      final uploadResult = await uploadPortfolioImagesUseCase(
        profile.ownerId,
        newImages,
      );
      if (uploadResult.isLeft()) {
        final error = uploadResult.fold((l) => l, (r) => '');
        emit(FactoryProfileError(error));
        return;
      }
      final urls = uploadResult.getOrElse(() => []);
      profile = profile.copyWith(
        portfolioImages: [...profile.portfolioImages, ...urls],
      );
    }

    final result = await createFactoryProfileUseCase(profile);
    result.fold(
      (error) => emit(FactoryProfileError(error)),
      (createdProfile) => emit(FactoryProfileCreated(createdProfile)),
    );
  }

  Future<void> updateProfile(
    FactoryProfileEntity profile, {
    List<UploadImageParams>? newImages,
  }) async {
    emit(FactoryProfileLoading());

    if (newImages != null && newImages.isNotEmpty) {
      final uploadResult = await uploadPortfolioImagesUseCase(
        profile.ownerId,
        newImages,
      );
      if (uploadResult.isLeft()) {
        final error = uploadResult.fold((l) => l, (r) => '');
        emit(FactoryProfileError(error));
        return;
      }
      final urls = uploadResult.getOrElse(() => []);
      profile = profile.copyWith(
        portfolioImages: [...profile.portfolioImages, ...urls],
      );
    }

    final result = await updateFactoryProfileUseCase(profile);
    result.fold(
      (error) => emit(FactoryProfileError(error)),
      (updatedProfile) => emit(FactoryProfileUpdated(updatedProfile)),
    );
  }
}
