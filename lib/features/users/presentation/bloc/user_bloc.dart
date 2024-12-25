// request_bloc.dart
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:letaskono_flutter/core/di/injection_container.dart';
import 'package:letaskono_flutter/features/users/domain/entities/UserDetailsEntity.dart';
import 'package:letaskono_flutter/features/users/domain/entities/search_entity.dart';
import 'package:letaskono_flutter/features/users/domain/entities/user_entity.dart';
import 'package:letaskono_flutter/features/users/domain/use_cases/set_offline.dart';
import 'package:letaskono_flutter/features/users/domain/use_cases/set_online.dart';
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
  final SetOnline setOnlineUseCase = sl<SetOnline>();
  final SetOffline setOfflineUseCase = sl<SetOffline>();
  final prefs = sl<SharedPreferences>();

  UserBloc() : super(UsersInitial()) {
    on<FetchUsersEvent>((event, emit) async {
      final currentState = state;
      final searchObject = await _getUserPreferences();

      if (currentState is UsersLoaded || currentState is UserLoadingMore) {
        if (!event.isRefreshing && !(currentState as UsersLoaded).hasMore)
          return; // Prevent fetch if no more data

        emit(UserLoadingMore((currentState as UsersLoaded).users,
            currentState.currentPage, currentState.hasMore));

        try {
          final newUsers = await fetchUsersUseCase(
              page: event.page, query: searchObject); // Fetch notifications
          final hasMore = newUsers.isNotEmpty; // Check if more data exists

          emit(UsersLoaded(currentState.users + newUsers, event.page, hasMore));
        } catch (error) {
          emit(UsersError(error.toString()));
        }
      } else {
        // Initial load
        try {
          final users =
              await fetchUsersUseCase(page: event.page, query: searchObject);

          emit(UsersLoaded(users, event.page, users.isNotEmpty));
        } catch (error) {
          emit(UsersError(error.toString()));
        }
      }
    });

    on<RefreshFetchUsersEvent>((event, emit) async {
      final searchObject = await _getUserPreferences();
      try {
        final users = await fetchUsersUseCase(page: 1, query: searchObject);
        emit(UsersLoaded(users, 1, users.isNotEmpty));
      } catch (error) {
        emit(UsersError(error.toString()));
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
      if (event.ageMin != null && event.ageMax != null) {
        await prefs.setDouble('filter_age_min', event.ageMin!.toDouble());
        await prefs.setDouble('filter_age_max', event.ageMax!.toDouble());
      } else {
        await prefs.setDouble('filter_age_min', 18);
        await prefs.setDouble('filter_age_max', 100);
      }

      if (event.maritalStatus != null && event.maritalStatus!.isNotEmpty) {
        await prefs.setStringList(
            'filter_marital_status', event.maritalStatus!);
      } else {
        await prefs.setStringList('filter_marital_status', List.empty());
      }

      if (event.countries != null && event.countries!.isNotEmpty) {
        await prefs.setStringList('filter_countries', event.countries!);
      } else {
        await prefs.setStringList('filter_countries', List.empty());
      }

      if (event.states != null && event.states!.isNotEmpty) {
        await prefs.setStringList('filter_states', event.states!);
      } else {
        await prefs.setStringList('filter_states', List.empty());
      }

      if (event.nationalities != null && event.nationalities!.isNotEmpty) {
        await prefs.setStringList('filter_nationalities', event.nationalities!);
      } else {
        await prefs.setStringList('filter_nationalities', List.empty());
      }

      if (event.hijabs != null && event.hijabs!.isNotEmpty) {
        await prefs.setStringList('filter_hijabs', event.hijabs!);
      } else {
        await prefs.setStringList('filter_hijabs', List.empty());
      }

      if (event.le7yas != null && event.le7yas!.isNotEmpty) {
        await prefs.setStringList('filter_le7yas', event.le7yas!);
      } else {
        await prefs.setStringList('filter_le7yas', List.empty());
      }

      await prefs.setString('ordering', event.ordering ?? '');
      final searchObject = await _getUserPreferences();
      try {
        final filteredUsers =
            await fetchUsersUseCase(page: 1, query: searchObject);
        print(searchObject);
        emit(
            UsersLoaded(List.from(filteredUsers), 1, filteredUsers.isNotEmpty));
      } catch (error) {
        emit(UsersError(error.toString()));
      }
    });

    on<SetOnlineEvent>((event, emit) async {
      setOnlineUseCase();
    });

    on<SetOfflineEvent>((event, emit) async {
      setOfflineUseCase();
    });
  }

  Future<SearchEntity> _getUserPreferences() async {
    double? ageMin = prefs.getDouble('filter_age_min') ?? 18;
    double? ageMax = prefs.getDouble('filter_age_max') ?? 100;
    List<String>? maritalStatus =
        prefs.getStringList('filter_marital_status') ?? List.empty();
    String? gender = prefs.getString('filter_gender') ?? 'F';
    List<String>? countries =
        prefs.getStringList('filter_countries') ?? List.empty();
    List<String>? states = prefs.getStringList('filter_states') ?? List.empty();
    List<String>? hijabs = prefs.getStringList('filter_hijabs') ?? List.empty();
    List<String>? le7yas = prefs.getStringList('filter_le7yas') ?? List.empty();
    List<String>? nationalities =
        prefs.getStringList('filter_nationalities') ?? List.empty();
    String? ordering = prefs.getString('ordering') ?? '';
    return SearchEntity(
      ageMin: ageMin.toString(),
      ageMax: ageMax.toString(),
      maritalStatus: maritalStatus,
      ordering: ordering,
      gender: gender,
      nationalities: nationalities,
      hijabs: hijabs,
      le7yas: le7yas,
      countries: countries,
      states: states,
    );
  }
}
