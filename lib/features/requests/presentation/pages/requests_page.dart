import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letaskono_flutter/core/utils/ExpandingCircleProgress.dart';

import '../../data/models/request_type.dart';
import '../bloc/request_bloc.dart';
import '../widgets/AcceptanceRequestCard.dart';

class RequestsList extends StatelessWidget {
  const RequestsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RequestBloc()..add(FetchRequestsEvent()),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<RequestBloc, RequestState>(
            builder: (context, state) {
              if (state is RequestsLoading) {
                return Center(child: ExpandingCircleProgress());
              } else if (state is RequestsError) {
                return Center(child: Text(state.error));
              } else if (state is RequestsLoaded) {
                return RefreshIndicator(
                  onRefresh: () async {
                    // context
                    //     .read<RequestBloc>()
                    //     .add(FetchRequestsEvent(page: 1, isRefreshing: true));
                  },
                  child: state.requests.isNotEmpty
                      ? ListView.builder(
                          itemCount: state.requests.length,
                          itemBuilder: (context, index) {
                            final request = state.requests[index];
                            return AcceptanceRequestCard(
                              request: request,
                              onAccept: () => Navigator.pushNamed(
                                context,
                                '/userDetail',
                                arguments: request.requestType ==
                                        RequestType.sent
                                    ? request.sender
                                    : request
                                        .receiver, // Pass the 'id' as an argument
                              ),
                              onReject: () => print('Reject clicked'),
                            );
                          },
                        )
                      : const Center(child: Text("ليس هناك طلبات")),
                );
              } else if (state is RequestsError) {
                return Center(child: Text('Error: ${state.error}'));
              } else {
                return Center(child: ExpandingCircleProgress());
              }
            },
          ),
        ),
      ),
    );
  }
}
