import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<String, UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
    String? brandName,
  });

  Future<Either<String, UserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<UserEntity?> getCurrentUser();
  Future<void> signOut();
}
