// user_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:letaskono_flutter/core/di/injection_container.dart';

import '../../domain/use_cases/add_to_favourites.dart';
import '../../domain/use_cases/fetch_user_details.dart';
import '../../domain/use_cases/fetch_users.dart';
import '../../domain/use_cases/remove_from_favourites.dart';
import '../../domain/use_cases/send_request.dart';

part 'action_btn_event.dart';

part 'action_btn_state.dart';

class ActionBtnBloc extends Bloc<ActionBtnEvent, ActionBtnState> {
  final FetchUsers fetchUsersUseCase = sl<FetchUsers>();
  final FetchUserDetails fetchUserDetailsUseCase = sl<FetchUserDetails>();
  final SendRequest sendRequestUseCase = sl<SendRequest>();
  final AddToFavourites addToFavouritesUseCase = sl<AddToFavourites>();
  final RemoveFromFavourites removeFromFavouritesUseCase =
      sl<RemoveFromFavourites>();

  ActionBtnBloc() : super(ActionBtnInitial()) {
    on<SendRequestEvent>((event, emit) async {
      emit(RequestSentLoading());

      String? result;
      try {
        result = await sendRequestUseCase(event.userCode);
        emit(RequestSentSuccess(result));
      } catch (error) {
        emit(RequestSentFailed(error.toString()));
      }
    });

    on<AddToFavouritesEvent>((event, emit) async {
      emit(RequestSentLoading());

      String? result;
      try {
        result = await addToFavouritesUseCase(event.userCode);
        emit(AddToFavouritesSuccess(result));
      } catch (error) {
        emit(RequestSentFailed(error.toString()));
      }
    });

    on<RemoveFromFavouritesEvent>((event, emit) async {
      emit(RequestSentLoading());

      String? result;
      try {
        result = await removeFromFavouritesUseCase(event.userCode);
        emit(RemoveFromFavouritesSuccess(result));
      } catch (error) {
        emit(RequestSentFailed(error.toString()));
      }
    });
  }
}
