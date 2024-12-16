// request_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:letaskono_flutter/core/di/injection_container.dart';
import 'package:letaskono_flutter/features/users/domain/entities/UserDetailsEntity.dart';
import 'package:letaskono_flutter/features/users/domain/entities/search_entity.dart';
import 'package:letaskono_flutter/features/users/domain/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final prefs = sl<SharedPreferences>();

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
          final newUsers = await fetchFavouritesUseCase(
              page: event.page); // Fetch notifications
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
        emit(UserDetailsLoaded(user));
      } catch (error) {
        emit(UsersError(error.toString()));
      }
    });

    on<ApplyFiltersEvent>((event, emit) async {
      emit(UserLoading());
      await prefs.setDouble('filter_age_min', event.ageMin.toDouble());
      await prefs.setDouble('filter_age_max', event.ageMax.toDouble());
      await prefs.setString('filter_marital_status', event.maritalStatus);
      await prefs.setString('ordering', event.ordering);

      final searchObject = SearchEntity(
        ageMin: event.ageMin.toString(),
        ageMax: event.ageMax.toString(),
        maritalStatus: event.maritalStatus,
        country: event.countries[0],
        selectedStates: event.states,
        gender: event.gender,
        ordering: event.ordering,
      );
      try {
        final filteredUsers =
            await fetchUsersUseCase(page: 1, query: searchObject);
        emit(
            UsersLoaded(List.from(filteredUsers), 1, filteredUsers.isNotEmpty));
      } catch (error) {
        emit(UsersError(error.toString()));
      }
    });
  }

  Future<SearchEntity> _getUserPreferences() async {
    String? ageMin = prefs.getString('filter_age_min');
    String? ageMax = prefs.getString('filter_age_max');
    String? maritalStatus = prefs.getString('filter_marital_status');
    return SearchEntity(
      ageMin: ageMin,
      ageMax: ageMax,
      maritalStatus: maritalStatus,
    );
  }
}
