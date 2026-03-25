import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:qassa/core/services/user_service.dart';
import 'package:qassa/features/offers/domain/entities/offer_entity.dart';
import 'package:qassa/features/offers/domain/usecases/get_offers_usecase.dart';
import 'package:qassa/features/offers/domain/usecases/send_offer_usecase.dart';
import 'package:qassa/features/offers/domain/usecases/accept_offer_usecase.dart';
import 'package:qassa/features/offers/presentation/cubit/offers_cubit.dart';

class MockGetOffersUseCase extends Mock implements GetOffersUseCase {}

class MockSendOfferUseCase extends Mock implements SendOfferUseCase {}

class MockAcceptOfferUseCase extends Mock implements AcceptOfferUseCase {}

class MockUserService extends Mock implements UserService {}

void main() {
  late OffersCubit offersCubit;
  late MockGetOffersUseCase mockGetOffersUseCase;
  late MockSendOfferUseCase mockSendOfferUseCase;
  late MockAcceptOfferUseCase mockAcceptOfferUseCase;
  late MockUserService mockUserService;

  setUp(() {
    mockGetOffersUseCase = MockGetOffersUseCase();
    mockSendOfferUseCase = MockSendOfferUseCase();
    mockAcceptOfferUseCase = MockAcceptOfferUseCase();
    mockUserService = MockUserService();

    offersCubit = OffersCubit(
      getOffersUseCase: mockGetOffersUseCase,
      sendOfferUseCase: mockSendOfferUseCase,
      acceptOfferUseCase: mockAcceptOfferUseCase,
      userService: mockUserService,
    );
  });

  tearDown(() {
    offersCubit.close();
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
    quantity: 100,
    productType: 'T-shirt',
  );

  final tOffersList = [tOffer];

  test('initial state should be OffersInitial', () {
    expect(offersCubit.state, equals(OffersInitial()));
  });

  group('loadOffers', () {
    blocTest<OffersCubit, OffersState>(
      'emits [OffersLoading, OffersLoaded] when successful',
      build: () {
        when(
          () => mockGetOffersUseCase(requestId: 'req1'),
        ).thenAnswer((_) async => Right(tOffersList));
        return offersCubit;
      },
      act: (cubit) => cubit.loadOffers('req1'),
      expect: () => [OffersLoading(), OffersLoaded(tOffersList)],
    );

    blocTest<OffersCubit, OffersState>(
      'emits [OffersLoading, OffersError] when failure happens',
      build: () {
        when(
          () => mockGetOffersUseCase(requestId: 'req1'),
        ).thenAnswer((_) async => const Left('Failed'));
        return offersCubit;
      },
      act: (cubit) => cubit.loadOffers('req1'),
      expect: () => [OffersLoading(), const OffersError('Failed')],
    );
  });

  group('loadMyOffers', () {
    blocTest<OffersCubit, OffersState>(
      'emits [OffersLoading, OffersLoaded] when current user is logged in',
      build: () {
        when(() => mockUserService.currentUserId).thenReturn('factory1');
        when(
          () => mockGetOffersUseCase(factoryId: 'factory1'),
        ).thenAnswer((_) async => Right(tOffersList));
        return offersCubit;
      },
      act: (cubit) => cubit.loadMyOffers(),
      expect: () => [OffersLoading(), OffersLoaded(tOffersList)],
    );

    blocTest<OffersCubit, OffersState>(
      'emits [OffersLoading, OffersError] when current user is not logged in',
      build: () {
        when(() => mockUserService.currentUserId).thenReturn(null);
        return offersCubit;
      },
      act: (cubit) => cubit.loadMyOffers(),
      expect: () => [OffersLoading(), const OffersError('غير مسجل الدخول')],
    );
  });

  group('sendOffer', () {
    blocTest<OffersCubit, OffersState>(
      'emits [OffersLoading, OfferSent] on success',
      build: () {
        when(() => mockUserService.currentUserId).thenReturn('factory1');
        when(
          () => mockUserService.factoryName,
        ).thenAnswer((_) async => 'Test Factory');
        when(
          () => mockSendOfferUseCase(
            requestId: 'req1',
            factoryId: 'factory1',
            factoryName: 'Test Factory',
            pricePerPiece: 50.0,
            leadTimeDays: 7,
            notes: 'test',
          ),
        ).thenAnswer((_) async => Right(tOffer));
        return offersCubit;
      },
      act: (cubit) => cubit.sendOffer(
        requestId: 'req1',
        pricePerPiece: 50.0,
        leadTimeDays: 7,
        notes: 'test',
      ),
      expect: () => [OffersLoading(), OfferSent(tOffer)],
    );
  });

  group('acceptOffer', () {
    blocTest<OffersCubit, OffersState>(
      'emits [OffersLoading, OfferAccepted] on success when offers are cached',
      build: () {
        when(
          () => mockGetOffersUseCase(requestId: 'req12345678'),
        ).thenAnswer((_) async => Right(tOffersList));
        when(
          () => mockAcceptOfferUseCase('offer1'),
        ).thenAnswer((_) async => const Right(null));
        return offersCubit;
      },
      act: (cubit) async {
        await cubit.loadOffers('req12345678');
        await cubit.acceptOffer(offerId: 'offer1', requestId: 'req12345678');
      },
      expect: () => [
        OffersLoading(),
        OffersLoaded(tOffersList),
        OffersLoading(),
        isA<OfferAccepted>(),
      ],
    );

    blocTest<OffersCubit, OffersState>(
      'emits Error if offers are not cached',
      build: () {
        when(
          () => mockAcceptOfferUseCase('offer1'),
        ).thenAnswer((_) async => const Right(null));
        return offersCubit;
      },
      act: (cubit) => cubit.acceptOffer(offerId: 'offer1', requestId: 'req1'),
      expect: () => [
        OffersLoading(),
        const OffersError('بيانات الطلب مش موجودة'),
      ],
    );
  });
}
