import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  AuthRepositoryImpl(this._dataSource);

  @override
  Future<Either<String, UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
    String? brandName,
  }) async {
    try {
      final response = await _dataSource.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return const Left('فشل إنشاء الحساب، جرب تاني');
      }

      final userId = response.user!.id;

      // Upsert profile data
      await _dataSource.upsertUserProfile(
        userId: userId,
        email: email,
        name: name,
        role: role,
        brandName: brandName,
      );

      // Fetch full profile
      final userData = await _dataSource.getCurrentUserData();
      if (userData == null) {
        return const Left('تم إنشاء الحساب لكن فشل تحميل البيانات');
      }

      final model = UserModel.fromJson(userData);
      return Right(_modelToEntity(model));
    } catch (e) {
      debugPrint('❌ signUp error: $e');
      return Left(_mapSignUpError(e));
    }
  }

  @override
  Future<Either<String, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dataSource.signIn(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return const Left('فشل تسجيل الدخول');
      }

      final userData = await _dataSource.getCurrentUserData();
      if (userData == null) {
        return const Left('مفيش حساب بالبيانات دي');
      }

      final model = UserModel.fromJson(userData);
      return Right(_modelToEntity(model));
    } catch (e) {
      debugPrint('❌ signIn error: $e');
      return Left(_mapSignInError(e));
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final data = await _dataSource.getCurrentUserData();
    if (data == null) return null;
    return _modelToEntity(UserModel.fromJson(data));
  }

  @override
  Future<void> signOut() => _dataSource.signOut();

  UserEntity _modelToEntity(UserModel m) => UserEntity(
    id: m.id,
    email: m.email,
    name: m.name,
    role: m.role,
    brandName: m.brandName,
    phone: m.phone,
    createdAt: m.createdAt,
  );

  String _mapSignUpError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('already registered') ||
        msg.contains('already exists') ||
        msg.contains('unique')) {
      return 'الإيميل ده مسجل قبل كده، جرب تسجيل دخول';
    }
    if (msg.contains('weak password') || msg.contains('password')) {
      return 'الباسورد ضعيف، لازم يكون 6 حروف على الأقل';
    }
    if (msg.contains('invalid') && msg.contains('email')) {
      return 'الإيميل مش صح';
    }
    if (msg.contains('network') || msg.contains('socket')) {
      return 'في مشكلة في الإنترنت، جرب تاني';
    }
    return 'فشل إنشاء الحساب: ${e.toString().length > 100 ? e.toString().substring(0, 100) : e}';
  }

  String _mapSignInError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('invalid') ||
        msg.contains('wrong') ||
        msg.contains('credentials')) {
      return 'الإيميل أو الباسورد غلط';
    }
    if (msg.contains('not found') || msg.contains('no user')) {
      return 'مفيش حساب بالإيميل ده';
    }
    if (msg.contains('network') || msg.contains('socket')) {
      return 'في مشكلة في الإنترنت، جرب تاني';
    }
    return 'فشل تسجيل الدخول، حاول مرة أخرى';
  }
}
