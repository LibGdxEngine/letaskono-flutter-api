// lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:letaskono_flutter/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:letaskono_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:letaskono_flutter/features/auth/domain/use_cases/password_reset.dart';
import 'package:letaskono_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:letaskono_flutter/features/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:letaskono_flutter/features/chat/data/repository/chat_repository_impl.dart';
import 'package:letaskono_flutter/features/chat/domain/repository/chat_repository.dart';
import 'package:letaskono_flutter/features/chat/domain/use_cases/connect_to_chat.dart';
import 'package:letaskono_flutter/features/chat/domain/use_cases/disconnect_from_chat.dart';
import 'package:letaskono_flutter/features/chat/domain/use_cases/load_messages.dart';
import 'package:letaskono_flutter/features/chat/domain/use_cases/send_message.dart';
import 'package:letaskono_flutter/features/notifications/data/data_sources/notifications_remote_data_source.dart';
import 'package:letaskono_flutter/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:letaskono_flutter/features/notifications/domain/repositories/notification_repository.dart';
import 'package:letaskono_flutter/features/notifications/domain/use_cases/fetch_notifications.dart';
import 'package:letaskono_flutter/features/requests/data/data_sources/requests_remote_data_source.dart';
import 'package:letaskono_flutter/features/requests/data/repositories/request_repository_impl.dart';
import 'package:letaskono_flutter/features/requests/domain/repositories/request_repository.dart';
import 'package:letaskono_flutter/features/requests/domain/use_cases/fetch_requests.dart';
import 'package:letaskono_flutter/features/users/data/data_sources/user_remote_data_source.dart';
import 'package:letaskono_flutter/features/users/data/repositories/user_repository_impl.dart';
import 'package:letaskono_flutter/features/users/domain/repositories/user_repository.dart';
import 'package:letaskono_flutter/features/users/domain/use_cases/accept_request.dart';
import 'package:letaskono_flutter/features/users/domain/use_cases/add_to_blacklist.dart';
import 'package:letaskono_flutter/features/users/domain/use_cases/add_to_favourites.dart';
import 'package:letaskono_flutter/features/users/domain/use_cases/fetch_favourites.dart';

import 'package:letaskono_flutter/features/users/domain/use_cases/fetch_user_details.dart';
import 'package:letaskono_flutter/features/users/domain/use_cases/fetch_users.dart';
import 'package:letaskono_flutter/features/users/domain/use_cases/reject_request.dart';
import 'package:letaskono_flutter/features/users/domain/use_cases/remove_from_blacklist.dart';
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
  sl.registerLazySingleton<RequestsRemoteDataSource>(
      () => RequestsRemoteDataSourceImpl(httpClient: sl(), prefs: sl()));
  sl.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(httpClient: sl(), prefs: sl()));
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(
      httpClient: sl(),
      prefs: sl(),
    ),
  );

  // Register Repository Implementations
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
  sl.registerLazySingleton<RequestRepository>(
    () => RequestRepositoryImpl(
        remoteDataSource:
            sl()), // Provide the remote data source to the repository
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
        remoteDataSource:
            sl()), // Provide the remote data source to the repository
  );
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
        remoteDataSource:
            sl()), // Provide the remote data source to the repository
  );

  // Repositories
  sl.registerLazySingleton(() => AuthRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => UserRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => RequestRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => ChatRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(
      () => NotificationRepositoryImpl(remoteDataSource: sl()));

  // Use Cases
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => PasswordReset(sl()));
  sl.registerLazySingleton(() => PasswordVerify(sl()));
  sl.registerLazySingleton(() => ConfirmAccount(sl()));
  sl.registerLazySingleton(() => CompleteProfile(sl()));
  sl.registerLazySingleton(() => FetchUsers(sl()));
  sl.registerLazySingleton(() => FetchRequests(sl()));
  sl.registerLazySingleton(() => FetchFavourites(sl()));
  sl.registerLazySingleton(() => FetchUserDetails(sl()));
  sl.registerLazySingleton(() => SendRequest(sl()));
  sl.registerLazySingleton(() => AcceptRequest(sl()));
  sl.registerLazySingleton(() => RejectRequest(sl()));
  sl.registerLazySingleton(() => AddToFavourites(sl()));
  sl.registerLazySingleton(() => RemoveFromFavourites(sl()));
  sl.registerLazySingleton(() => AddToBlacklist(sl()));
  sl.registerLazySingleton(() => RemoveFromBlacklist(sl()));
  sl.registerLazySingleton(() => FetchNotifications(sl()));
  sl.registerLazySingleton(() => LoadMessages(sl()));
  sl.registerLazySingleton(() => ConnectToChat(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton(() => DisconnectFromChat(sl()));

  // Register Bloc
  sl.registerFactory(() => AuthBloc());
}
