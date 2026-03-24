import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/send_otp_usecase.dart';

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

// ── Cubit ─────────────────────────────────────────────
class AuthCubit extends Cubit<AuthState> {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;

  AuthCubit({
    required this.signUpUseCase,
    required this.signInUseCase,
    required this.signOutUseCase,
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

    result.fold(
      (error) => emit(AuthError(error)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());

    final result = await signInUseCase(email: email, password: password);

    result.fold(
      (error) => emit(AuthError(error)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> signOut() async {
    await signOutUseCase();
    emit(AuthUnauthenticated());
  }

  void reset() {
    emit(AuthInitial());
  }
}
