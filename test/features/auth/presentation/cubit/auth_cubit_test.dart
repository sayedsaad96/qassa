import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:qassa/features/auth/domain/entities/user_entity.dart';
import 'package:qassa/features/auth/domain/usecases/auth_usecases.dart';
import 'package:qassa/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:qassa/core/services/user_service.dart';

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

class MockSignInUseCase extends Mock implements SignInUseCase {}

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

class MockUserService extends Mock implements UserService {}

void main() {
  late AuthCubit authCubit;
  late MockSignUpUseCase mockSignUpUseCase;
  late MockSignInUseCase mockSignInUseCase;
  late MockSignOutUseCase mockSignOutUseCase;
  late MockUserService mockUserService;

  setUp(() {
    mockSignUpUseCase = MockSignUpUseCase();
    mockSignInUseCase = MockSignInUseCase();
    mockSignOutUseCase = MockSignOutUseCase();
    mockUserService = MockUserService();
    // stub clearCache so it is a no-op in all tests
    when(() => mockUserService.clearCache()).thenReturn(null);
    authCubit = AuthCubit(
      signUpUseCase: mockSignUpUseCase,
      signInUseCase: mockSignInUseCase,
      signOutUseCase: mockSignOutUseCase,
      userService: mockUserService,
    );
  });

  tearDown(() {
    authCubit.close();
  });

  final tDate = DateTime.parse("2025-01-01T00:00:00.000Z");

  final tUser = UserEntity(
    id: '1',
    email: 'test@test.com',
    name: 'Test User',
    role: 'brand',
    brandName: 'Test Brand',
    createdAt: tDate,
  );

  test('initial state should be AuthInitial', () {
    expect(authCubit.state, equals(AuthInitial()));
  });

  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthAuthenticated] when signUp is successful',
    build: () {
      when(
        () => mockSignUpUseCase(
          email: 'test@test.com',
          password: 'password123',
          name: 'Test User',
          role: 'brand',
          brandName: 'Test Brand',
        ),
      ).thenAnswer((_) async => Right(tUser));
      return authCubit;
    },
    act: (cubit) => cubit.signUp(
      email: 'test@test.com',
      password: 'password123',
      name: 'Test User',
      role: 'brand',
      brandName: 'Test Brand',
    ),
    expect: () => [AuthLoading(), AuthAuthenticated(tUser)],
  );

  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthError] when signUp fails',
    build: () {
      when(
        () => mockSignUpUseCase(
          email: 'test@test.com',
          password: 'password123',
          name: 'Test User',
          role: 'brand',
          brandName: 'Test Brand',
        ),
      ).thenAnswer((_) async => const Left('Signup error'));
      return authCubit;
    },
    act: (cubit) => cubit.signUp(
      email: 'test@test.com',
      password: 'password123',
      name: 'Test User',
      role: 'brand',
      brandName: 'Test Brand',
    ),
    expect: () => [AuthLoading(), const AuthError('Signup error')],
  );

  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthAuthenticated] when signIn is successful',
    build: () {
      when(
        () =>
            mockSignInUseCase(email: 'test@test.com', password: 'password123'),
      ).thenAnswer((_) async => Right(tUser));
      return authCubit;
    },
    act: (cubit) =>
        cubit.signIn(email: 'test@test.com', password: 'password123'),
    expect: () => [AuthLoading(), AuthAuthenticated(tUser)],
  );

  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthError] when signIn fails',
    build: () {
      when(
        () =>
            mockSignInUseCase(email: 'test@test.com', password: 'password123'),
      ).thenAnswer((_) async => const Left('Signin error'));
      return authCubit;
    },
    act: (cubit) =>
        cubit.signIn(email: 'test@test.com', password: 'password123'),
    expect: () => [AuthLoading(), const AuthError('Signin error')],
  );

  blocTest<AuthCubit, AuthState>(
    'emits [AuthUnauthenticated] when signOut is called',
    build: () {
      when(() => mockSignOutUseCase()).thenAnswer((_) async => Future.value());
      return authCubit;
    },
    act: (cubit) => cubit.signOut(),
    expect: () => [AuthUnauthenticated()],
  );
}
