import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/request_bloc.dart';
import '../widgets/AcceptanceRequestCard.dart';

class RequestsList extends StatelessWidget {
  const RequestsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RequestBloc()..add(FetchRequestsEvent()),
      child: Scaffold(
        body: BlocBuilder<RequestBloc, RequestState>(
          builder: (context, state) {
            if (state is RequestsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is RequestsError) {
              return Center(child: Text(state.error));
            } else if (state is RequestsLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<RequestBloc>().add(FetchRequestsEvent());
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
                              arguments: request.sender, // Pass the 'id' as an argument
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
              return const Center(child: Text('...'));
            }
          },
        ),
      ),
    );
  }
}
