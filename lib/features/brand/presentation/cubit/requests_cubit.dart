import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/create_request_usecase.dart';
import '../../domain/usecases/get_requests_usecase.dart';
import '../../../../core/services/user_service.dart';

// ════════════════════════════════════
// STATES
// ════════════════════════════════════
abstract class RequestsState extends Equatable {
  const RequestsState();
  @override
  List<Object?> get props => [];
}

class RequestsInitial extends RequestsState {}
class RequestsLoading extends RequestsState {}

class RequestsLoaded extends RequestsState {
  final List<RequestEntity> requests;
  final String activeTab;
  const RequestsLoaded(this.requests, {this.activeTab = 'active'});
  @override
  List<Object?> get props => [requests, activeTab];
}

class RequestCreated extends RequestsState {
  final RequestEntity request;
  const RequestCreated(this.request);
  @override
  List<Object?> get props => [request];
}

class RequestsError extends RequestsState {
  final String message;
  const RequestsError(this.message);
  @override
  List<Object?> get props => [message];
}

// ════════════════════════════════════
// CUBIT
// ════════════════════════════════════
class RequestsCubit extends Cubit<RequestsState> {
  final CreateRequestUseCase createRequestUseCase;
  final GetRequestsUseCase getRequestsUseCase;
  final UserService userService;

  String _activeTab = 'active';

  RequestsCubit({
    required this.createRequestUseCase,
    required this.getRequestsUseCase,
    required this.userService,
  }) : super(RequestsInitial());

  Future<void> loadMyRequests() async {
    emit(RequestsLoading());
    final userId = userService.currentUserId;
    if (userId == null) {
      emit(const RequestsError('غير مسجل الدخول'));
      return;
    }
    final result = await getRequestsUseCase(brandId: userId);
    result.fold(
      (error) => emit(RequestsError(error)),
      (all) => emit(RequestsLoaded(_filterByTab(all, _activeTab), activeTab: _activeTab)),
    );
  }

  Future<void> loadAllRequests({String? specialty}) async {
    emit(RequestsLoading());
    final result = await getRequestsUseCase(specialty: specialty);
    result.fold(
      (error) => emit(RequestsError(error)),
      (requests) => emit(RequestsLoaded(requests)),
    );
  }

  void switchTab(String tab) {
    _activeTab = tab;
    loadMyRequests();
  }

  Future<void> createRequest({
    required String productType,
    required int quantity,
    required String material,
    double? targetPrice,
    String? notes,
    String? referenceImageUrl,
  }) async {
    emit(RequestsLoading());

    final userId = userService.currentUserId ?? '';
    final brandNameVal = await userService.brandName;
    final initial = await userService.avatarInitial;

    final request = RequestEntity(
      id: '',
      brandId: userId,
      brandName: brandNameVal,
      brandAvatarInitial: initial,
      productType: productType,
      quantity: quantity,
      material: material,
      targetPricePerPiece: targetPrice,
      notes: notes,
      referenceImageUrl: referenceImageUrl,
      createdAt: DateTime.now(),
    );

    final result = await createRequestUseCase(request);
    result.fold(
      (error) => emit(RequestsError(error)),
      (created) => emit(RequestCreated(created)),
    );
  }

  List<RequestEntity> _filterByTab(List<RequestEntity> all, String tab) {
    switch (tab) {
      case 'completed':
        return all.where((r) => r.status == RequestStatus.completed).toList();
      case 'cancelled':
        return all.where((r) => r.status == RequestStatus.cancelled).toList();
      default:
        return all.where((r) => r.status == RequestStatus.active).toList();
    }
  }
}
