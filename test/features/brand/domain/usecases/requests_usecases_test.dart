import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:qassa/features/brand/domain/entities/entities.dart';
import 'package:qassa/features/brand/domain/repositories/request_repository.dart';
import 'package:qassa/features/brand/domain/usecases/create_request_usecase.dart';
import 'package:qassa/features/brand/domain/usecases/get_requests_usecase.dart';

class MockRequestRepository extends Mock implements RequestRepository {}

class FakeRequestEntity extends Fake implements RequestEntity {}

void main() {
  late MockRequestRepository mockRequestRepository;
  late CreateRequestUseCase createRequestUseCase;
  late GetRequestsUseCase getRequestsUseCase;

  setUpAll(() {
    registerFallbackValue(FakeRequestEntity());
  });

  setUp(() {
    mockRequestRepository = MockRequestRepository();
    createRequestUseCase = CreateRequestUseCase(mockRequestRepository);
    getRequestsUseCase = GetRequestsUseCase(mockRequestRepository);
  });

  final tDate = DateTime.parse("2025-01-01T00:00:00.000Z");

  final tRequest = RequestEntity(
    id: 'req1',
    brandId: 'brand1',
    brandName: 'Test Brand',
    productType: 'T-shirt',
    quantity: 100,
    createdAt: tDate,
  );

  final tRequestsList = [tRequest];

  group('CreateRequestUseCase', () {
    test('should return RequestEntity when creation is successful', () async {
      // arrange
      when(
        () => mockRequestRepository.createRequest(any()),
      ).thenAnswer((_) async => Right(tRequest));

      // act
      final result = await createRequestUseCase(tRequest);

      // assert
      expect(result, Right(tRequest));
      verify(() => mockRequestRepository.createRequest(tRequest));
      verifyNoMoreInteractions(mockRequestRepository);
    });

    test('should return Error string when creation fails', () async {
      // arrange
      when(
        () => mockRequestRepository.createRequest(any()),
      ).thenAnswer((_) async => const Left('Creation Error'));

      // act
      final result = await createRequestUseCase(tRequest);

      // assert
      expect(result, const Left('Creation Error'));
    });
  });

  group('GetRequestsUseCase', () {
    test('should return requests for brand if brandId is given', () async {
      // arrange
      when(
        () => mockRequestRepository.getRequestsByBrand('brand1'),
      ).thenAnswer((_) async => Right(tRequestsList));

      // act
      final result = await getRequestsUseCase(brandId: 'brand1');

      // assert
      expect(result, Right(tRequestsList));
      verify(() => mockRequestRepository.getRequestsByBrand('brand1'));
      verifyNoMoreInteractions(mockRequestRepository);
    });

    test('should return all active requests if no brandId is given', () async {
      // arrange
      when(
        () => mockRequestRepository.getAllActiveRequests(),
      ).thenAnswer((_) async => Right(tRequestsList));

      // act
      final result = await getRequestsUseCase();

      // assert
      expect(result, Right(tRequestsList));
      verify(() => mockRequestRepository.getAllActiveRequests(specialty: null));
      verifyNoMoreInteractions(mockRequestRepository);
    });

    test(
      'should return all active requests filtered by specialty if specialty is given',
      () async {
        // arrange
        when(
          () => mockRequestRepository.getAllActiveRequests(specialty: 'cotton'),
        ).thenAnswer((_) async => Right(tRequestsList));

        // act
        final result = await getRequestsUseCase(specialty: 'cotton');

        // assert
        expect(result, Right(tRequestsList));
        verify(
          () => mockRequestRepository.getAllActiveRequests(specialty: 'cotton'),
        );
        verifyNoMoreInteractions(mockRequestRepository);
      },
    );
  });
}
