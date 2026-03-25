import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:qassa/features/factory/domain/entities/factory_profile_entity.dart';
import 'package:qassa/features/factory/domain/usecases/get_factory_profile_usecase.dart';
import 'package:qassa/features/factory/domain/usecases/create_factory_profile_usecase.dart';
import 'package:qassa/features/factory/domain/usecases/update_factory_profile_usecase.dart';
import 'package:qassa/features/factory/domain/usecases/upload_portfolio_images_usecase.dart';
import 'package:qassa/features/factory/presentation/cubit/factory_profile_cubit.dart';

class MockGetFactoryProfileUseCase extends Mock
    implements GetFactoryProfileUseCase {}

class MockCreateFactoryProfileUseCase extends Mock
    implements CreateFactoryProfileUseCase {}

class MockUpdateFactoryProfileUseCase extends Mock
    implements UpdateFactoryProfileUseCase {}

class MockUploadPortfolioImagesUseCase extends Mock
    implements UploadPortfolioImagesUseCase {}

class FakeFactoryProfileEntity extends Fake implements FactoryProfileEntity {}

void main() {
  late FactoryProfileCubit factoryProfileCubit;
  late MockGetFactoryProfileUseCase mockGetFactoryProfileUseCase;
  late MockCreateFactoryProfileUseCase mockCreateFactoryProfileUseCase;
  late MockUpdateFactoryProfileUseCase mockUpdateFactoryProfileUseCase;
  late MockUploadPortfolioImagesUseCase mockUploadPortfolioImagesUseCase;

  setUpAll(() {
    registerFallbackValue(FakeFactoryProfileEntity());
  });

  setUp(() {
    mockGetFactoryProfileUseCase = MockGetFactoryProfileUseCase();
    mockCreateFactoryProfileUseCase = MockCreateFactoryProfileUseCase();
    mockUpdateFactoryProfileUseCase = MockUpdateFactoryProfileUseCase();
    mockUploadPortfolioImagesUseCase = MockUploadPortfolioImagesUseCase();

    factoryProfileCubit = FactoryProfileCubit(
      getFactoryProfileUseCase: mockGetFactoryProfileUseCase,
      createFactoryProfileUseCase: mockCreateFactoryProfileUseCase,
      updateFactoryProfileUseCase: mockUpdateFactoryProfileUseCase,
      uploadPortfolioImagesUseCase: mockUploadPortfolioImagesUseCase,
    );
  });

  tearDown(() {
    factoryProfileCubit.close();
  });

  const tProfile = FactoryProfileEntity(
    id: 'f1',
    ownerId: 'user1',
    name: 'Factory 1',
    city: 'Cairo',
    specialties: ['Cotton'],
    minQuantity: 100,
    leadTimeDays: 7,
    rating: 5.0,
    reviewCount: 0,
    portfolioImages: [],
    isFastResponder: true,
  );

  test('initial state should be FactoryProfileInitial', () {
    expect(factoryProfileCubit.state, equals(FactoryProfileInitial()));
  });

  group('loadProfile', () {
    blocTest<FactoryProfileCubit, FactoryProfileState>(
      'emits [Loading, Loaded] when profile fetches successfully',
      build: () {
        when(
          () => mockGetFactoryProfileUseCase('user1'),
        ).thenAnswer((_) async => const Right(tProfile));
        return factoryProfileCubit;
      },
      act: (cubit) => cubit.loadProfile('user1'),
      expect: () => [
        FactoryProfileLoading(),
        const FactoryProfileLoaded(tProfile),
      ],
    );

    blocTest<FactoryProfileCubit, FactoryProfileState>(
      'emits [Loading, NotFound] when profile is not found',
      build: () {
        when(
          () => mockGetFactoryProfileUseCase('user1'),
        ).thenAnswer((_) async => const Left('Profile not found'));
        return factoryProfileCubit;
      },
      act: (cubit) => cubit.loadProfile('user1'),
      expect: () => [FactoryProfileLoading(), FactoryProfileNotFound()],
    );

    blocTest<FactoryProfileCubit, FactoryProfileState>(
      'emits [Loading, Error] when generic error occurs',
      build: () {
        when(
          () => mockGetFactoryProfileUseCase('user1'),
        ).thenAnswer((_) async => const Left('DB Error'));
        return factoryProfileCubit;
      },
      act: (cubit) => cubit.loadProfile('user1'),
      expect: () => [
        FactoryProfileLoading(),
        const FactoryProfileError('DB Error'),
      ],
    );
  });

  group('createProfile', () {
    blocTest<FactoryProfileCubit, FactoryProfileState>(
      'emits [Loading, Created] when profile pushes successfully',
      build: () {
        when(
          () => mockCreateFactoryProfileUseCase(any()),
        ).thenAnswer((_) async => const Right(tProfile));
        return factoryProfileCubit;
      },
      act: (cubit) => cubit.createProfile(tProfile),
      expect: () => [
        FactoryProfileLoading(),
        const FactoryProfileCreated(tProfile),
      ],
    );
  });

  group('updateProfile', () {
    blocTest<FactoryProfileCubit, FactoryProfileState>(
      'emits [Loading, Updated] when profile updates successfully',
      build: () {
        when(
          () => mockUpdateFactoryProfileUseCase(any()),
        ).thenAnswer((_) async => const Right(tProfile));
        return factoryProfileCubit;
      },
      act: (cubit) => cubit.updateProfile(tProfile),
      expect: () => [
        FactoryProfileLoading(),
        const FactoryProfileUpdated(tProfile),
      ],
    );
  });
}
