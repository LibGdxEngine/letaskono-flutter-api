// request_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:letaskono_flutter/core/di/injection_container.dart';
import 'package:letaskono_flutter/features/users/domain/use_cases/accept_request.dart';
import 'package:letaskono_flutter/features/users/domain/use_cases/reject_request.dart';

import '../../domain/use_cases/add_to_blacklist.dart';
import '../../domain/use_cases/add_to_favourites.dart';
import '../../domain/use_cases/fetch_user_details.dart';
import '../../domain/use_cases/fetch_users.dart';
import '../../domain/use_cases/remove_from_blacklist.dart';
import '../../domain/use_cases/remove_from_favourites.dart';
import '../../domain/use_cases/send_request.dart';

part 'action_btn_event.dart';

part 'action_btn_state.dart';

class ActionBtnBloc extends Bloc<ActionBtnEvent, ActionBtnState> {
  final FetchUsers fetchUsersUseCase = sl<FetchUsers>();
  final FetchUserDetails fetchUserDetailsUseCase = sl<FetchUserDetails>();
  final SendRequest sendRequestUseCase = sl<SendRequest>();
  final AcceptRequest acceptRequestUseCase = sl<AcceptRequest>();
  final RejectRequest rejectRequestUseCase = sl<RejectRequest>();
  final AddToFavourites addToFavouritesUseCase = sl<AddToFavourites>();
  final AddToBlacklist addToBlackListUseCase = sl<AddToBlacklist>();
  final RemoveFromBlacklist removeFromBlacklistUseCase =
      sl<RemoveFromBlacklist>();
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

    on<AddToBlackListEvent>((event, emit) async {
      emit(RequestSentLoading());

      String? result;
      try {
        result = await addToBlackListUseCase(event.userCode);
        emit(AddToBlockListSuccess(result));
      } catch (error) {
        emit(RequestSentFailed(error.toString()));
      }
    });

    on<RemoveFromBlackListEvent>((event, emit) async {
      emit(RequestSentLoading());

      String? result;
      try {
        result = await removeFromBlacklistUseCase(event.userCode);
        emit(RemoveFromFavouritesSuccess(result));
      } catch (error) {
        emit(RequestSentFailed(error.toString()));
      }
    });

    on<AcceptRequestEvent>((event, emit) async {
      emit(RequestSentLoading());

      String? result;
      try {
        result = await acceptRequestUseCase(event.requestId);
        emit(RequestAcceptedSuccess(result));
      } catch (error) {
        emit(RequestSentFailed(error.toString()));
      }
    });

    on<RejectRequestEvent>((event, emit) async {
      emit(RequestSentLoading());

      String? result;
      try {
        result = await rejectRequestUseCase(event.requestId);
        emit(RequestRejectedSuccess(result));
      } catch (error) {
        emit(RequestSentFailed(error.toString()));
      }
    });
  }
}
