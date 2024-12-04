// request_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:letaskono_flutter/core/di/injection_container.dart';
import 'package:letaskono_flutter/features/requests/domain/entities/AcceptanceRequestEntity.dart';
import 'package:letaskono_flutter/features/requests/domain/use_cases/fetch_requests.dart';

part 'request_event.dart';

part 'request_state.dart';

class RequestBloc extends Bloc<UsersEvent, RequestState> {
  final FetchRequests fetchRequestsUseCase = sl<FetchRequests>();

  RequestBloc() : super(RequestsInitial()) {
    on<FetchRequestsEvent>((event, emit) async {
      emit(RequestsLoading());

      List<AcceptanceRequestEntity> requests = [];
      try {
        requests = await fetchRequestsUseCase();
        emit(RequestsLoaded(requests));
      } catch (error) {
        emit(RequestsError(error.toString()));
      }
    });
  }
}
