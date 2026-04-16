import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/get_factories_usecase.dart';

// ════════════════════════════════════
// FILTER MODEL
// ════════════════════════════════════
class FactoryFilter extends Equatable {
  final String? specialty;
  final String? city;
  final bool? fastResponderOnly;
  final int? maxLeadTimeDays;
  final int? maxMinQuantity;

  const FactoryFilter({
    this.specialty,
    this.city,
    this.fastResponderOnly,
    this.maxLeadTimeDays,
    this.maxMinQuantity,
  });

  bool get isEmpty =>
      specialty == null &&
      city == null &&
      (fastResponderOnly == null || fastResponderOnly == false) &&
      maxLeadTimeDays == null &&
      maxMinQuantity == null;

  int get activeCount {
    int count = 0;
    if (specialty != null) count++;
    if (city != null) count++;
    if (fastResponderOnly == true) count++;
    if (maxLeadTimeDays != null) count++;
    if (maxMinQuantity != null) count++;
    return count;
  }

  FactoryFilter copyWith({
    Object? specialty = _sentinel,
    Object? city = _sentinel,
    Object? fastResponderOnly = _sentinel,
    Object? maxLeadTimeDays = _sentinel,
    Object? maxMinQuantity = _sentinel,
  }) {
    return FactoryFilter(
      specialty: specialty == _sentinel ? this.specialty : specialty as String?,
      city: city == _sentinel ? this.city : city as String?,
      fastResponderOnly: fastResponderOnly == _sentinel
          ? this.fastResponderOnly
          : fastResponderOnly as bool?,
      maxLeadTimeDays: maxLeadTimeDays == _sentinel
          ? this.maxLeadTimeDays
          : maxLeadTimeDays as int?,
      maxMinQuantity: maxMinQuantity == _sentinel
          ? this.maxMinQuantity
          : maxMinQuantity as int?,
    );
  }

  @override
  List<Object?> get props =>
      [specialty, city, fastResponderOnly, maxLeadTimeDays, maxMinQuantity];
}

// Sentinel object for copyWith nullable fields
const Object _sentinel = Object();

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
  final List<FactoryEntity> allFactories; // original unfiltered
  final String? activeSpecialty;
  final String searchQuery;
  final FactoryFilter filter;

  const FactoriesLoaded({
    required this.factories,
    required this.allFactories,
    this.activeSpecialty,
    this.searchQuery = '',
    this.filter = const FactoryFilter(),
  });

  @override
  List<Object?> get props =>
      [factories, allFactories, activeSpecialty, searchQuery, filter];
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
      (factories) => emit(
        FactoriesLoaded(
          factories: factories,
          allFactories: factories,
          activeSpecialty: specialty,
        ),
      ),
    );
  }

  /// Filter by specialty chip
  void filterBySpecialty(String specialty) {
    loadFactories(specialty: specialty == 'الكل' ? null : specialty);
  }

  /// Search factories by name or city
  void search(String query) {
    final current = state;
    if (current is! FactoriesLoaded) return;

    final q = query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? current.allFactories
        : current.allFactories.where((f) {
            return f.name.toLowerCase().contains(q) ||
                f.city.toLowerCase().contains(q) ||
                f.specialties.any((s) => s.toLowerCase().contains(q));
          }).toList();

    emit(FactoriesLoaded(
      factories: filtered,
      allFactories: current.allFactories,
      activeSpecialty: current.activeSpecialty,
      searchQuery: query,
      filter: current.filter,
    ));
  }

  /// Apply advanced filter
  void applyFilter(FactoryFilter filter) {
    final current = state;
    if (current is! FactoriesLoaded) return;

    var filtered = current.allFactories;

    if (filter.specialty != null && filter.specialty != 'الكل') {
      filtered = filtered
          .where((f) => f.specialties.contains(filter.specialty))
          .toList();
    }
    if (filter.city != null) {
      filtered =
          filtered.where((f) => f.city == filter.city).toList();
    }
    if (filter.fastResponderOnly == true) {
      filtered = filtered.where((f) => f.isFastResponder).toList();
    }
    if (filter.maxLeadTimeDays != null) {
      filtered = filtered
          .where((f) => f.leadTimeDays <= filter.maxLeadTimeDays!)
          .toList();
    }
    if (filter.maxMinQuantity != null) {
      filtered = filtered
          .where((f) => f.minQuantity <= filter.maxMinQuantity!)
          .toList();
    }

    // Also apply current search query
    final q = current.searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      filtered = filtered.where((f) {
        return f.name.toLowerCase().contains(q) ||
            f.city.toLowerCase().contains(q) ||
            f.specialties.any((s) => s.toLowerCase().contains(q));
      }).toList();
    }

    emit(FactoriesLoaded(
      factories: filtered,
      allFactories: current.allFactories,
      activeSpecialty: filter.specialty,
      searchQuery: current.searchQuery,
      filter: filter,
    ));
  }

  void clearFilter() {
    final current = state;
    if (current is! FactoriesLoaded) return;
    emit(FactoriesLoaded(
      factories: current.allFactories,
      allFactories: current.allFactories,
      searchQuery: '',
      filter: const FactoryFilter(),
    ));
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
}
