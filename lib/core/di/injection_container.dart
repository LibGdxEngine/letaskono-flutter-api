// lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:letaskono_flutter/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:letaskono_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:letaskono_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import '../network/http_client.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/use_cases/sign_up.dart';
import '../../features/auth/domain/use_cases/confirm_account.dart';
import '../../features/auth/domain/use_cases/submit_profile.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Register Dio client
  sl.registerLazySingleton(() => Dio());

  // Register HttpClient
  sl.registerLazySingleton(() => HttpClient(dio: sl()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(httpClient: sl()));

  // Register AuthRepositoryImpl
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl()),  // Provide the remote data source to the repository
  );

  // Repositories
  sl.registerLazySingleton(() => AuthRepositoryImpl(remoteDataSource: sl()));

  // Use Cases
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => ConfirmAccount(sl()));
  sl.registerLazySingleton(() => SubmitProfile(sl()));

  // Register Bloc
  sl.registerFactory(() => AuthBloc());
}
