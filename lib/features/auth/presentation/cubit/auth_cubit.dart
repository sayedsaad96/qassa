import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../../../core/services/user_service.dart';

// ── State ─────────────────────────────────────────────
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

class AuthUnauthenticated extends AuthState {}

class AuthAccountDeleted extends AuthState {}

// ── Cubit ─────────────────────────────────────────────
class AuthCubit extends Cubit<AuthState> {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final UserService userService;

  AuthCubit({
    required this.signUpUseCase,
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.deleteAccountUseCase,
    required this.userService,
  }) : super(AuthInitial());

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
    String? brandName,
  }) async {
    emit(AuthLoading());

    final result = await signUpUseCase(
      email: email,
      password: password,
      name: name,
      role: role,
      brandName: brandName,
    );

    result.fold((error) => emit(AuthError(error)), (user) {
      userService.clearCache(); // clear any previous user's cached data
      emit(AuthAuthenticated(user));
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());

    final result = await signInUseCase(email: email, password: password);

    result.fold((error) => emit(AuthError(error)), (user) {
      userService.clearCache(); // clear previous user's cached data
      emit(AuthAuthenticated(user));
    });
  }

  Future<void> signOut() async {
    userService.clearCache(); // clear cache BEFORE sign-out
    await signOutUseCase();
    emit(AuthUnauthenticated());
  }

  Future<void> deleteAccount() async {
    emit(AuthLoading());
    try {
      userService.clearCache();
      await deleteAccountUseCase();
      emit(AuthAccountDeleted());
    } catch (e) {
      emit(const AuthError('فشل في حذف الحساب، حاول مرة أخرى'));
    }
  }

  void reset() {
    emit(AuthInitial());
  }
}
