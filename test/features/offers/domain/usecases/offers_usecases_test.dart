import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:qassa/features/offers/domain/entities/offer_entity.dart';
import 'package:qassa/features/offers/domain/repositories/offer_repository.dart';
import 'package:qassa/features/offers/domain/usecases/send_offer_usecase.dart';
import 'package:qassa/features/offers/domain/usecases/get_offers_usecase.dart';
import 'package:qassa/features/offers/domain/usecases/accept_offer_usecase.dart';

class MockOfferRepository extends Mock implements OfferRepository {}

void main() {
  late MockOfferRepository mockOfferRepository;
  late SendOfferUseCase sendOfferUseCase;
  late GetOffersUseCase getOffersUseCase;
  late AcceptOfferUseCase acceptOfferUseCase;

  setUp(() {
    mockOfferRepository = MockOfferRepository();
    sendOfferUseCase = SendOfferUseCase(mockOfferRepository);
    getOffersUseCase = GetOffersUseCase(mockOfferRepository);
    acceptOfferUseCase = AcceptOfferUseCase(mockOfferRepository);
  });

  final tDate = DateTime.parse("2025-01-01T00:00:00.000Z");

  final tOffer = OfferEntity(
    id: 'offer1',
    requestId: 'req1',
    factoryId: 'factory1',
    factoryName: 'Test Factory',
    pricePerPiece: 50.0,
    leadTimeDays: 7,
    status: OfferStatus.pending,
    createdAt: tDate,
  );

  final tOffersList = [tOffer];

  group('SendOfferUseCase', () {
    test('should return OfferEntity when successful', () async {
      // arrange
      when(
        () => mockOfferRepository.sendOffer(
          requestId: 'req1',
          factoryId: 'factory1',
          factoryName: 'Test Factory',
          pricePerPiece: 50.0,
          leadTimeDays: 7,
        ),
      ).thenAnswer((_) async => Right(tOffer));

      // act
      final result = await sendOfferUseCase(
        requestId: 'req1',
        factoryId: 'factory1',
        factoryName: 'Test Factory',
        pricePerPiece: 50.0,
        leadTimeDays: 7,
      );

      // assert
      expect(result, Right(tOffer));
      verify(
        () => mockOfferRepository.sendOffer(
          requestId: 'req1',
          factoryId: 'factory1',
          factoryName: 'Test Factory',
          pricePerPiece: 50.0,
          leadTimeDays: 7,
        ),
      );
      verifyNoMoreInteractions(mockOfferRepository);
    });
  });

  group('GetOffersUseCase', () {
    test('should return offers for request if requestId is provided', () async {
      // arrange
      when(
        () => mockOfferRepository.getOffersByRequest('req1'),
      ).thenAnswer((_) async => Right(tOffersList));

      // act
      final result = await getOffersUseCase(requestId: 'req1');

      // assert
      expect(result, Right(tOffersList));
      verify(() => mockOfferRepository.getOffersByRequest('req1'));
      verifyNoMoreInteractions(mockOfferRepository);
    });

    test('should return offers for factory if factoryId is provided', () async {
      // arrange
      when(
        () => mockOfferRepository.getOffersByFactory('factory1'),
      ).thenAnswer((_) async => Right(tOffersList));

      // act
      final result = await getOffersUseCase(factoryId: 'factory1');

      // assert
      expect(result, Right(tOffersList));
      verify(() => mockOfferRepository.getOffersByFactory('factory1'));
      verifyNoMoreInteractions(mockOfferRepository);
    });

    test('should return empty list if both ids are null', () async {
      // act
      final result = await getOffersUseCase();

      // assert
      expect(result, const Right<String, List<OfferEntity>>([]));
      verifyNoMoreInteractions(mockOfferRepository);
    });
  });

  group('AcceptOfferUseCase', () {
    test('should complete successfully', () async {
      // arrange
      when(
        () => mockOfferRepository.acceptOffer('offer1'),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await acceptOfferUseCase('offer1');

      // assert
      expect(result, const Right(null));
      verify(() => mockOfferRepository.acceptOffer('offer1'));
      verifyNoMoreInteractions(mockOfferRepository);
    });
  });
}
