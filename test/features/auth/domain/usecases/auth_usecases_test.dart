import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:qassa/features/auth/domain/entities/user_entity.dart';
import 'package:qassa/features/auth/domain/repositories/auth_repository.dart';
import 'package:qassa/features/auth/domain/usecases/auth_usecases.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignUpUseCase signUpUseCase;
  late SignInUseCase signInUseCase;
  late SignOutUseCase signOutUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signUpUseCase = SignUpUseCase(mockAuthRepository);
    signInUseCase = SignInUseCase(mockAuthRepository);
    signOutUseCase = SignOutUseCase(mockAuthRepository);
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

  group('SignUpUseCase', () {
    test('should return UserEntity on successful signup', () async {
      // arrange
      when(
        () => mockAuthRepository.signUp(
          email: 'test@test.com',
          password: 'password123',
          name: 'Test User',
          role: 'brand',
          brandName: 'Test Brand',
        ),
      ).thenAnswer((_) async => Right(tUser));

      // act
      final result = await signUpUseCase(
        email: 'test@test.com',
        password: 'password123',
        name: 'Test User',
        role: 'brand',
        brandName: 'Test Brand',
      );

      // assert
      expect(result, Right(tUser));
      verify(
        () => mockAuthRepository.signUp(
          email: 'test@test.com',
          password: 'password123',
          name: 'Test User',
          role: 'brand',
          brandName: 'Test Brand',
        ),
      );
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Error string on failed signup', () async {
      // arrange
      when(
        () => mockAuthRepository.signUp(
          email: 'test@test.com',
          password: 'password123',
          name: 'Test User',
          role: 'brand',
          brandName: 'Test Brand',
        ),
      ).thenAnswer((_) async => const Left('Signup failed'));

      // act
      final result = await signUpUseCase(
        email: 'test@test.com',
        password: 'password123',
        name: 'Test User',
        role: 'brand',
        brandName: 'Test Brand',
      );

      // assert
      expect(result, const Left('Signup failed'));
    });
  });

  group('SignInUseCase', () {
    test('should return UserEntity on successful signin', () async {
      // arrange
      when(
        () => mockAuthRepository.signIn(
          email: 'test@test.com',
          password: 'password123',
        ),
      ).thenAnswer((_) async => Right(tUser));

      // act
      final result = await signInUseCase(
        email: 'test@test.com',
        password: 'password123',
      );

      // assert
      expect(result, Right(tUser));
      verify(
        () => mockAuthRepository.signIn(
          email: 'test@test.com',
          password: 'password123',
        ),
      );
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Error string on failed signin', () async {
      // arrange
      when(
        () => mockAuthRepository.signIn(
          email: 'test@test.com',
          password: 'password123',
        ),
      ).thenAnswer((_) async => const Left('Signin failed'));

      // act
      final result = await signInUseCase(
        email: 'test@test.com',
        password: 'password123',
      );

      // assert
      expect(result, const Left('Signin failed'));
    });
  });

  group('SignOutUseCase', () {
    test('should complete successfully', () async {
      // arrange
      when(
        () => mockAuthRepository.signOut(),
      ).thenAnswer((_) async => Future.value());

      // act
      await signOutUseCase();

      // assert
      verify(() => mockAuthRepository.signOut());
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
