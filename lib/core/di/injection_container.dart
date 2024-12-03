// lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:letaskono_flutter/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:letaskono_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:letaskono_flutter/features/auth/domain/use_cases/password_reset.dart';
import 'package:letaskono_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:letaskono_flutter/features/users/data/data_sources/user_remote_data_source.dart';
import 'package:letaskono_flutter/features/users/data/repositories/user_repository_impl.dart';
import 'package:letaskono_flutter/features/users/domain/repositories/user_repository.dart';
import 'package:letaskono_flutter/features/users/domain/use_cases/add_to_favourites.dart';
import 'package:letaskono_flutter/features/users/domain/use_cases/fetch_user_details.dart';
import 'package:letaskono_flutter/features/users/domain/use_cases/fetch_users.dart';
import 'package:letaskono_flutter/features/users/domain/use_cases/remove_from_favourites.dart';
import 'package:letaskono_flutter/features/users/domain/use_cases/send_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/domain/use_cases/password_verify.dart';
import '../../features/auth/domain/use_cases/sign_in.dart';
import '../network/http_client.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/use_cases/sign_up.dart';
import '../../features/auth/domain/use_cases/confirm_account.dart';
import '../../features/auth/domain/use_cases/submit_profile.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Register Dio client

  sl.registerLazySingleton(() => Dio());

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Register HttpClient
  sl.registerLazySingleton(() => HttpClient(dio: sl()));
  // Ensure all async dependencies are initialized before proceeding
  await sl.allReady();
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(httpClient: sl(), prefs: sl()));
  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(httpClient: sl(), prefs: sl()));

  // Register AuthRepositoryImpl
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
        remoteDataSource:
            sl()), // Provide the remote data source to the repository
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
        remoteDataSource:
            sl()), // Provide the remote data source to the repository
  );

  // Repositories
  sl.registerLazySingleton(() => AuthRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => UserRepositoryImpl(remoteDataSource: sl()));

  // Use Cases
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => PasswordReset(sl()));
  sl.registerLazySingleton(() => PasswordVerify(sl()));
  sl.registerLazySingleton(() => ConfirmAccount(sl()));
  sl.registerLazySingleton(() => CompleteProfile(sl()));

  sl.registerLazySingleton(() => FetchUsers(sl()));
  sl.registerLazySingleton(() => FetchUserDetails(sl()));
  sl.registerLazySingleton(() => SendRequest(sl()));
  sl.registerLazySingleton(() => AddToFavourites(sl()));
  sl.registerLazySingleton(() => RemoveFromFavourites(sl()));

  // Register Bloc
  sl.registerFactory(() => AuthBloc());
}
