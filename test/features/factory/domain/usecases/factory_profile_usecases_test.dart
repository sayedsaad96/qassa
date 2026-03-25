import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:qassa/features/factory/domain/entities/factory_profile_entity.dart';
import 'package:qassa/features/factory/domain/repositories/factory_profile_repository.dart';
import 'package:qassa/features/factory/domain/usecases/get_factory_profile_usecase.dart';
import 'package:qassa/features/factory/domain/usecases/create_factory_profile_usecase.dart';
import 'package:qassa/features/factory/domain/usecases/update_factory_profile_usecase.dart';

class MockFactoryProfileRepository extends Mock
    implements FactoryProfileRepository {}

class FakeFactoryProfileEntity extends Fake implements FactoryProfileEntity {}

void main() {
  late MockFactoryProfileRepository mockFactoryProfileRepository;
  late GetFactoryProfileUseCase getFactoryProfileUseCase;
  late CreateFactoryProfileUseCase createFactoryProfileUseCase;
  late UpdateFactoryProfileUseCase updateFactoryProfileUseCase;

  setUpAll(() {
    registerFallbackValue(FakeFactoryProfileEntity());
  });

  setUp(() {
    mockFactoryProfileRepository = MockFactoryProfileRepository();
    getFactoryProfileUseCase = GetFactoryProfileUseCase(
      mockFactoryProfileRepository,
    );
    createFactoryProfileUseCase = CreateFactoryProfileUseCase(
      mockFactoryProfileRepository,
    );
    updateFactoryProfileUseCase = UpdateFactoryProfileUseCase(
      mockFactoryProfileRepository,
    );
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

  group('GetFactoryProfileUseCase', () {
    test('should return profile', () async {
      when(
        () => mockFactoryProfileRepository.getProfile('user1'),
      ).thenAnswer((_) async => const Right(tProfile));

      final result = await getFactoryProfileUseCase('user1');

      expect(result, const Right(tProfile));
      verify(() => mockFactoryProfileRepository.getProfile('user1'));
      verifyNoMoreInteractions(mockFactoryProfileRepository);
    });
  });

  group('CreateFactoryProfileUseCase', () {
    test('should act efficiently', () async {
      when(
        () => mockFactoryProfileRepository.createProfile(any()),
      ).thenAnswer((_) async => const Right(tProfile));

      final result = await createFactoryProfileUseCase(tProfile);

      expect(result, const Right(tProfile));
      verify(() => mockFactoryProfileRepository.createProfile(tProfile));
      verifyNoMoreInteractions(mockFactoryProfileRepository);
    });
  });

  group('UpdateFactoryProfileUseCase', () {
    test('should return updated profile', () async {
      when(
        () => mockFactoryProfileRepository.updateProfile(any()),
      ).thenAnswer((_) async => const Right(tProfile));

      final result = await updateFactoryProfileUseCase(tProfile);

      expect(result, const Right(tProfile));
      verify(() => mockFactoryProfileRepository.updateProfile(tProfile));
      verifyNoMoreInteractions(mockFactoryProfileRepository);
    });
  });
}
