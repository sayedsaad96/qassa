import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/offer_entity.dart';
import '../../domain/usecases/get_offers_usecase.dart';
import '../../domain/usecases/send_offer_usecase.dart';
import '../../domain/usecases/accept_offer_usecase.dart';
import '../../../../core/services/user_service.dart';

// ════════════════════════════════════
// STATES
// ════════════════════════════════════
abstract class OffersState extends Equatable {
  const OffersState();
  @override
  List<Object?> get props => [];
}

class OffersInitial extends OffersState {}
class OffersLoading extends OffersState {}

class OffersLoaded extends OffersState {
  final List<OfferEntity> offers;
  const OffersLoaded(this.offers);
  @override
  List<Object?> get props => [offers];
}

class OfferSent extends OffersState {
  final OfferEntity offer;
  const OfferSent(this.offer);
  @override
  List<Object?> get props => [offer];
}

class OfferAccepted extends OffersState {
  final Map<String, dynamic> orderData;
  const OfferAccepted(this.orderData);
  @override
  List<Object?> get props => [orderData];
}

class OffersError extends OffersState {
  final String message;
  const OffersError(this.message);
  @override
  List<Object?> get props => [message];
}

// ════════════════════════════════════
// CUBIT
// ════════════════════════════════════
class OffersCubit extends Cubit<OffersState> {
  final GetOffersUseCase getOffersUseCase;
  final SendOfferUseCase sendOfferUseCase;
  final AcceptOfferUseCase acceptOfferUseCase;
  final UserService userService;

  List<OfferEntity> _cachedOffers = [];

  OffersCubit({
    required this.getOffersUseCase,
    required this.sendOfferUseCase,
    required this.acceptOfferUseCase,
    required this.userService,
  }) : super(OffersInitial());

  Future<void> loadOffers(String requestId) async {
    emit(OffersLoading());
    final result = await getOffersUseCase(requestId: requestId);
    result.fold(
      (error) => emit(OffersError(error)),
      (offers) {
        _cachedOffers = offers;
        emit(OffersLoaded(offers));
      },
    );
  }

  Future<void> loadMyOffers() async {
    emit(OffersLoading());
    final factoryId = userService.currentUserId;
    if (factoryId == null) {
      emit(const OffersError('غير مسجل الدخول'));
      return;
    }
    final result = await getOffersUseCase(factoryId: factoryId);
    result.fold(
      (error) => emit(OffersError(error)),
      (offers) {
        _cachedOffers = offers;
        emit(OffersLoaded(offers));
      },
    );
  }

  Future<void> sendOffer({
    required String requestId,
    required double pricePerPiece,
    required int leadTimeDays,
    String? notes,
  }) async {
    emit(OffersLoading());

    final factoryId = userService.currentUserId ?? '';
    final factoryNameVal = await userService.factoryName;

    final result = await sendOfferUseCase(
      requestId: requestId,
      factoryId: factoryId,
      factoryName: factoryNameVal,
      pricePerPiece: pricePerPiece,
      leadTimeDays: leadTimeDays,
      notes: notes,
    );

    result.fold(
      (error) => emit(OffersError(error)),
      (offer) => emit(OfferSent(offer)),
    );
  }

  Future<void> acceptOffer({
    required String offerId,
    required String requestId,
  }) async {
    emit(OffersLoading());

    final result = await acceptOfferUseCase(offerId);
    result.fold(
      (error) => emit(OffersError(error)),
      (_) {
        final offer = _cachedOffers.where((o) => o.id == offerId).firstOrNull;
        if (offer == null) {
          emit(const OffersError('بيانات الطلب مش موجودة'));
          return;
        }
        emit(OfferAccepted({
          'factory_name': offer.factoryName,
          'product_type': offer.productType,
          'quantity': offer.quantity,
          'price_per_piece': offer.pricePerPiece.toStringAsFixed(0),
          'total': offer.totalFormatted,
          'lead_time_days': offer.leadTimeDays,
          'request_number': requestId.substring(0, 8).toUpperCase(),
        }));
      },
    );
  }
}
