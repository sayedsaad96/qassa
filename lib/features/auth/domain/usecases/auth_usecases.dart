import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;
  SignUpUseCase(this._repository);

  Future<Either<String, UserEntity>> call({
    required String email,
    required String password,
    required String name,
    required String role,
    String? brandName,
  }) => _repository.signUp(
    email: email,
    password: password,
    name: name,
    role: role,
    brandName: brandName,
  );
}

class SignInUseCase {
  final AuthRepository _repository;
  SignInUseCase(this._repository);

  Future<Either<String, UserEntity>> call({
    required String email,
    required String password,
  }) => _repository.signIn(email: email, password: password);
}

class GetCurrentUserUseCase {
  final AuthRepository _repository;
  GetCurrentUserUseCase(this._repository);

  Future<UserEntity?> call() => _repository.getCurrentUser();
}

class SignOutUseCase {
  final AuthRepository _repository;
  SignOutUseCase(this._repository);

  Future<void> call() => _repository.signOut();
}

class DeleteAccountUseCase {
  final AuthRepository _repository;
  DeleteAccountUseCase(this._repository);

  Future<void> call() => _repository.deleteAccount();
}
