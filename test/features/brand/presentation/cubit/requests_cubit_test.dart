import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:qassa/core/services/user_service.dart';
import 'package:qassa/features/brand/domain/entities/entities.dart';
import 'package:qassa/features/brand/domain/usecases/create_request_usecase.dart';
import 'package:qassa/features/brand/domain/usecases/get_requests_usecase.dart';
import 'package:qassa/features/brand/presentation/cubit/requests_cubit.dart';

class MockCreateRequestUseCase extends Mock implements CreateRequestUseCase {}

class MockGetRequestsUseCase extends Mock implements GetRequestsUseCase {}

class MockUserService extends Mock implements UserService {}

class FakeRequestEntity extends Fake implements RequestEntity {}

void main() {
  late RequestsCubit requestsCubit;
  late MockCreateRequestUseCase mockCreateRequestUseCase;
  late MockGetRequestsUseCase mockGetRequestsUseCase;
  late MockUserService mockUserService;

  setUpAll(() {
    registerFallbackValue(FakeRequestEntity());
  });

  setUp(() {
    mockCreateRequestUseCase = MockCreateRequestUseCase();
    mockGetRequestsUseCase = MockGetRequestsUseCase();
    mockUserService = MockUserService();

    requestsCubit = RequestsCubit(
      createRequestUseCase: mockCreateRequestUseCase,
      getRequestsUseCase: mockGetRequestsUseCase,
      userService: mockUserService,
    );
  });

  tearDown(() {
    requestsCubit.close();
  });

  final tDate = DateTime.parse("2025-01-01T00:00:00.000Z");

  final tRequest = RequestEntity(
    id: 'req1',
    brandId: 'user1',
    brandName: 'Test Brand',
    productType: 'T-shirt',
    quantity: 100,
    status: RequestStatus.active,
    createdAt: tDate,
  );

  final tRequestCompleted = RequestEntity(
    id: 'req2',
    brandId: 'user1',
    brandName: 'Test Brand',
    productType: 'T-shirt',
    quantity: 100,
    status: RequestStatus.completed,
    createdAt: tDate,
  );

  final tRequestsList = [tRequest, tRequestCompleted];

  test('initial state should be RequestsInitial', () {
    expect(requestsCubit.state, equals(RequestsInitial()));
  });

  group('loadMyRequests', () {
    blocTest<RequestsCubit, RequestsState>(
      'emits [RequestsLoading, RequestsLoaded] when getMyRequests returns data successfully',
      build: () {
        when(() => mockUserService.currentUserId).thenReturn('user1');
        when(
          () => mockGetRequestsUseCase(brandId: 'user1'),
        ).thenAnswer((_) async => Right(tRequestsList));
        return requestsCubit;
      },
      act: (cubit) => cubit.loadMyRequests(),
      expect: () => [
        RequestsLoading(),
        RequestsLoaded([
          tRequest,
        ], activeTab: 'active'), // only active by default
      ],
    );

    blocTest<RequestsCubit, RequestsState>(
      'emits [RequestsLoading, RequestsError] when currentUserId is null',
      build: () {
        when(() => mockUserService.currentUserId).thenReturn(null);
        return requestsCubit;
      },
      act: (cubit) => cubit.loadMyRequests(),
      expect: () => [RequestsLoading(), const RequestsError('غير مسجل الدخول')],
    );

    blocTest<RequestsCubit, RequestsState>(
      'emits [RequestsLoading, RequestsError] when usecase returns error',
      build: () {
        when(() => mockUserService.currentUserId).thenReturn('user1');
        when(
          () => mockGetRequestsUseCase(brandId: 'user1'),
        ).thenAnswer((_) async => const Left('Failed to load'));
        return requestsCubit;
      },
      act: (cubit) => cubit.loadMyRequests(),
      expect: () => [RequestsLoading(), const RequestsError('Failed to load')],
    );
  });

  group('loadAllRequests', () {
    blocTest<RequestsCubit, RequestsState>(
      'emits [RequestsLoading, RequestsLoaded] when getRequestsUseCase returns data',
      build: () {
        when(
          () => mockGetRequestsUseCase(specialty: null),
        ).thenAnswer((_) async => Right(tRequestsList));
        return requestsCubit;
      },
      act: (cubit) => cubit.loadAllRequests(),
      expect: () => [
        RequestsLoading(),
        RequestsLoaded(tRequestsList), // returns all unmodified
      ],
    );
  });

  group('switchTab', () {
    blocTest<RequestsCubit, RequestsState>(
      'emits correct active tab filtered results',
      build: () {
        when(() => mockUserService.currentUserId).thenReturn('user1');
        when(
          () => mockGetRequestsUseCase(brandId: 'user1'),
        ).thenAnswer((_) async => Right(tRequestsList));
        return requestsCubit;
      },
      act: (cubit) => cubit.switchTab('completed'),
      expect: () => [
        RequestsLoading(),
        RequestsLoaded([tRequestCompleted], activeTab: 'completed'),
      ],
    );
  });

  group('createRequest', () {
    blocTest<RequestsCubit, RequestsState>(
      'emits [RequestsLoading, RequestCreated] upon successful request creation',
      build: () {
        when(() => mockUserService.currentUserId).thenReturn('user1');
        when(
          () => mockUserService.brandName,
        ).thenAnswer((_) async => 'Test Brand');
        when(() => mockUserService.avatarInitial).thenAnswer((_) async => 'T');
        when(
          () => mockCreateRequestUseCase(any()),
        ).thenAnswer((_) async => Right(tRequest));
        return requestsCubit;
      },
      act: (cubit) => cubit.createRequest(
        productType: 'T-shirt',
        quantity: 100,
        material: 'cotton',
      ),
      expect: () => [RequestsLoading(), RequestCreated(tRequest)],
    );
  });
}
