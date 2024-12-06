// request_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:letaskono_flutter/core/di/injection_container.dart';
import 'package:letaskono_flutter/features/users/domain/entities/UserDetailsEntity.dart';
import 'package:letaskono_flutter/features/users/domain/entities/user_entity.dart';

import '../../domain/use_cases/fetch_favourites.dart';
import '../../domain/use_cases/fetch_user_details.dart';
import '../../domain/use_cases/fetch_users.dart';
import '../../domain/use_cases/send_request.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UsersEvent, UserState> {
  final FetchUsers fetchUsersUseCase = sl<FetchUsers>();
  final FetchFavourites fetchFavouritesUseCase = sl<FetchFavourites>();
  final FetchUserDetails fetchUserDetailsUseCase = sl<FetchUserDetails>();
  final SendRequest sendRequestUseCase = sl<SendRequest>();

  UserBloc() : super(UsersInitial()) {
    on<FetchUsersEvent>((event, emit) async {
      final currentState = state;
      if (currentState is UsersLoaded || currentState is UserLoadingMore) {
        if (!event.isRefreshing && !(currentState as UsersLoaded).hasMore)
          return; // Prevent fetch if no more data

        emit(UserLoadingMore((currentState as UsersLoaded).users,
            currentState.currentPage, currentState.hasMore));

        try {
          final newUsers =
              await fetchUsersUseCase(page: event.page); // Fetch notifications
          final hasMore = newUsers.isNotEmpty; // Check if more data exists

          emit(UsersLoaded(currentState.users + newUsers, event.page, hasMore));
        } catch (error) {
          emit(UsersError(error.toString()));
        }
      } else {
        // Initial load
        try {
          final users = await fetchUsersUseCase(page: event.page);
          emit(UsersLoaded(users, event.page, users.isNotEmpty));
        } catch (error) {
          emit(UsersError(error.toString()));
        }
      }
    });
    on<FetchFavouritesEvent>((event, emit) async {
      final currentState = state;
      if (currentState is UsersLoaded || currentState is UserLoadingMore) {
        if (!event.isRefreshing && !(currentState as UsersLoaded).hasMore)
          return; // Prevent fetch if no more data

        emit(UserLoadingMore((currentState as UsersLoaded).users,
            currentState.currentPage, currentState.hasMore));

        try {
          final newUsers =
          await fetchFavouritesUseCase(page: event.page); // Fetch notifications
          final hasMore = newUsers.isNotEmpty; // Check if more data exists

          emit(UsersLoaded(currentState.users + newUsers, event.page, hasMore));
        } catch (error) {
          emit(UsersError(error.toString()));
        }
      } else {
        // Initial load
        try {
          final users = await fetchFavouritesUseCase(page: event.page);
          emit(UsersLoaded(users, event.page, users.isNotEmpty));
        } catch (error) {
          emit(UsersError(error.toString()));
        }
      }
    });

    on<FetchUserDetailsEvent>((event, emit) async {
      emit(UserLoading());

      UserDetailsEntity? user;
      try {
        user = await fetchUserDetailsUseCase(event.userId);
        emit(UserDetailsLoaded(user!));
      } catch (error) {
        emit(UsersError(error.toString()));
      }
    });
  }
}
