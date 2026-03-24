import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/get_factories_usecase.dart';

// ════════════════════════════════════
// STATES
// ════════════════════════════════════
abstract class FactoriesState extends Equatable {
  const FactoriesState();
  @override
  List<Object?> get props => [];
}

class FactoriesInitial extends FactoriesState {}
class FactoriesLoading extends FactoriesState {}

class FactoriesLoaded extends FactoriesState {
  final List<FactoryEntity> factories;
  final String? activeFilter;
  const FactoriesLoaded(this.factories, {this.activeFilter});
  @override
  List<Object?> get props => [factories, activeFilter];
}

class FactoryDetailLoaded extends FactoriesState {
  final FactoryEntity factory;
  const FactoryDetailLoaded(this.factory);
  @override
  List<Object?> get props => [factory];
}

class FactoriesError extends FactoriesState {
  final String message;
  const FactoriesError(this.message);
  @override
  List<Object?> get props => [message];
}

// ════════════════════════════════════
// CUBIT
// ════════════════════════════════════
class FactoriesCubit extends Cubit<FactoriesState> {
  final GetFactoriesUseCase getFactoriesUseCase;
  final GetFactoryByIdUseCase getFactoryByIdUseCase;

  FactoriesCubit({
    required this.getFactoriesUseCase,
    required this.getFactoryByIdUseCase,
  }) : super(FactoriesInitial());

  Future<void> loadFactories({String? specialty}) async {
    emit(FactoriesLoading());
    final result = await getFactoriesUseCase(
      specialty: specialty == 'الكل' ? null : specialty,
    );
    result.fold(
      (error) => emit(FactoriesError(error)),
      (factories) => emit(FactoriesLoaded(factories, activeFilter: specialty)),
    );
  }

  /// Fetches a single factory by ID directly — no full-list scan.
  Future<void> loadFactoryById(String id) async {
    emit(FactoriesLoading());
    final result = await getFactoryByIdUseCase(id);
    result.fold(
      (error) => emit(FactoriesError(error)),
      (factory) => emit(FactoryDetailLoaded(factory)),
    );
  }

  void filterBySpecialty(String specialty) {
    loadFactories(specialty: specialty == 'الكل' ? null : specialty);
  }
}
