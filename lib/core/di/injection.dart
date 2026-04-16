import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/user_service.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

import '../../features/brand/data/datasources/factory_remote_datasource.dart';
import '../../features/brand/data/datasources/request_remote_datasource.dart';
import '../../features/brand/data/repositories/factory_repository_impl.dart';
import '../../features/brand/data/repositories/request_repository_impl.dart';
import '../../features/brand/domain/repositories/factory_repository.dart';
import '../../features/brand/domain/repositories/request_repository.dart';
import '../../features/brand/domain/usecases/get_factories_usecase.dart';
import '../../features/brand/domain/usecases/create_request_usecase.dart';
import '../../features/brand/domain/usecases/get_requests_usecase.dart';
import '../../features/brand/domain/usecases/get_request_by_id_usecase.dart';
import '../../features/brand/presentation/cubit/factories_cubit.dart';
import '../../features/brand/presentation/cubit/requests_cubit.dart';

import '../../features/factory/data/datasources/factory_profile_remote_datasource.dart';
import '../../features/factory/data/repositories/factory_profile_repository_impl.dart';
import '../../features/factory/domain/repositories/factory_profile_repository.dart';
import '../../features/factory/domain/usecases/get_factory_profile_usecase.dart';
import '../../features/factory/domain/usecases/create_factory_profile_usecase.dart';
import '../../features/factory/domain/usecases/update_factory_profile_usecase.dart';
import '../../features/factory/domain/usecases/upload_portfolio_images_usecase.dart';
import '../../features/factory/presentation/cubit/factory_profile_cubit.dart';

import '../../features/offers/data/datasources/offer_remote_datasource.dart';
import '../../features/offers/data/repositories/offer_repository_impl.dart';
import '../../features/offers/domain/repositories/offer_repository.dart';
import '../../features/offers/domain/usecases/get_offers_usecase.dart';
import '../../features/offers/domain/usecases/send_offer_usecase.dart';
import '../../features/offers/domain/usecases/accept_offer_usecase.dart';
import '../../features/offers/presentation/cubit/offers_cubit.dart';

import '../../features/notifications/data/datasources/notification_remote_datasource.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // ── Supabase Client ──────────────────────────────────
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // ── Services ─────────────────────────────────────────
  sl.registerLazySingleton<UserService>(() => UserService(sl()));

  // ── Auth ─────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUseCase(sl()));
  sl.registerLazySingleton(
    () => AuthCubit(
      signUpUseCase: sl(),
      signInUseCase: sl(),
      signOutUseCase: sl(),
      deleteAccountUseCase: sl(),
      userService: sl(),
    ),
  );

  // ── Factories ─────────────────────────────────────────
  sl.registerLazySingleton<FactoryRemoteDataSource>(
    () => FactoryRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<FactoryRepository>(
    () => FactoryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetFactoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetFactoryByIdUseCase(sl()));
  sl.registerLazySingleton(
    () =>
        FactoriesCubit(getFactoriesUseCase: sl(), getFactoryByIdUseCase: sl()),
  );

  // ── Factory Profile ──────────────────────────────────
  sl.registerLazySingleton<FactoryProfileRemoteDataSource>(
    () => FactoryProfileRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<FactoryProfileRepository>(
    () => FactoryProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetFactoryProfileUseCase(sl()));
  sl.registerLazySingleton(() => CreateFactoryProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateFactoryProfileUseCase(sl()));
  sl.registerLazySingleton(() => UploadPortfolioImagesUseCase(sl()));
  sl.registerLazySingleton(
    () => FactoryProfileCubit(
      getFactoryProfileUseCase: sl(),
      createFactoryProfileUseCase: sl(),
      updateFactoryProfileUseCase: sl(),
      uploadPortfolioImagesUseCase: sl(),
    ),
  );

  // ── Requests ─────────────────────────────────────────
  sl.registerLazySingleton<RequestRemoteDataSource>(
    () => RequestRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<RequestRepository>(
    () => RequestRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => CreateRequestUseCase(sl()));
  sl.registerLazySingleton(() => GetRequestsUseCase(sl()));
  sl.registerLazySingleton(() => GetRequestByIdUseCase(sl()));
  sl.registerLazySingleton(
    () => RequestsCubit(
      createRequestUseCase: sl(),
      getRequestsUseCase: sl(),
      userService: sl(),
    ),
  );

  // ── Offers ────────────────────────────────────────────
  sl.registerLazySingleton<OfferRemoteDataSource>(
    () => OfferRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<OfferRepository>(() => OfferRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetOffersUseCase(sl()));
  sl.registerLazySingleton(() => SendOfferUseCase(sl()));
  sl.registerLazySingleton(() => AcceptOfferUseCase(sl()));
  sl.registerLazySingleton(
    () => OffersCubit(
      getOffersUseCase: sl(),
      sendOfferUseCase: sl(),
      acceptOfferUseCase: sl(),
      userService: sl(),
    ),
  );

  // ── Notifications ──────────────────────────────────────
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton(
    () => NotificationsCubit(
      dataSource: sl(),
      getUserId: () => sl<UserService>().currentUserId,
    ),
  );
}
