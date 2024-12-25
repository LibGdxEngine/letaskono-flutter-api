// request_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:letaskono_flutter/core/di/injection_container.dart';
import 'package:letaskono_flutter/features/requests/domain/entities/AcceptanceRequestEntity.dart';
import 'package:letaskono_flutter/features/requests/domain/use_cases/fetch_requests.dart';

part 'request_event.dart';

part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final FetchRequests fetchRequestsUseCase = sl<FetchRequests>();

  RequestBloc() : super(RequestsInitial()) {
    on<FetchRequestsEvent>((event, emit) async {
      final currentState = state;
      if (currentState is RequestsLoaded || currentState is RequestsLoadingMore) {
        if (!event.isRefreshing && !(currentState as RequestsLoaded).hasMore)
          return; // Prevent fetch if no more data

        emit(RequestsLoadingMore((currentState as RequestsLoaded).requests,
            currentState.currentPage, currentState.hasMore));

        try {
          final newUsers =
          await fetchRequestsUseCase(page: event.page); // Fetch notifications
          final hasMore = newUsers.isNotEmpty; // Check if more data exists

          emit(RequestsLoaded(currentState.requests + newUsers, event.page, hasMore));
        } catch (error) {
          emit(RequestsError(error.toString()));
        }
      } else {
        // Initial load
        try {
          final users = await fetchRequestsUseCase(page: event.page);
          emit(RequestsLoaded(List.from(users), event.page, users.isNotEmpty));
        } catch (error) {
          emit(RequestsError(error.toString()));
        }
      }
    });
  }
}
