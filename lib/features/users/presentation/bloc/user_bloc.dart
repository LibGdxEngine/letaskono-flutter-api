// user_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:letaskono_flutter/core/di/injection_container.dart';
import 'package:letaskono_flutter/features/users/domain/entities/UserDetailsEntity.dart';
import 'package:letaskono_flutter/features/users/domain/entities/user_entity.dart';

import '../../domain/use_cases/fetch_user_details.dart';
import '../../domain/use_cases/fetch_users.dart';
import '../../domain/use_cases/send_request.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UsersEvent, UserState> {
  final FetchUsers fetchUsersUseCase = sl<FetchUsers>();
  final FetchUserDetails fetchUserDetailsUseCase = sl<FetchUserDetails>();
  final SendRequest sendRequestUseCase = sl<SendRequest>();

  UserBloc() : super(UsersInitial()) {
    on<FetchUsersEvent>((event, emit) async {
      emit(UserLoading());

      List<UserEntity> users = [];
      try {
        users = await fetchUsersUseCase();
        emit(UsersLoaded(users));
      } catch (error) {
        emit(UsersError(error.toString()));
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
