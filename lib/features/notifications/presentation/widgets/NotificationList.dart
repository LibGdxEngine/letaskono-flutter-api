import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notification_bloc.dart';
import 'NotificationCard.dart';

class NotificationsList extends StatefulWidget {
  const NotificationsList({
    super.key,
  });

  @override
  State<NotificationsList> createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final bloc = context.read<NotificationBloc>();
    final state = bloc.state;

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        state is NotificationLoaded &&
        state.hasMore) {
      bloc.add(FetchNotificationsEvent(page: state.currentPage + 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التنبيهات'),),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading &&
              state is! NotificationLoadingMore) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationFailed) {
            return Center(child: Text(state.error));
          } else if (state is NotificationLoaded ||
              state is NotificationLoadingMore) {
            final notifications = state is NotificationLoaded
                ? state.notifications
                : (state as NotificationLoadingMore).notifications;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<NotificationBloc>().add(FetchNotificationsEvent(
                    page: (state as NotificationLoaded).currentPage,
                    isRefreshing: true));
              },
              child:notifications.isNotEmpty ? ListView.builder(
                controller: _scrollController,
                itemCount: notifications.length +
                    (state is NotificationLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= notifications.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return NotificationCard(notification: notifications[index]);
                },
              ) : const Center(child: Text('ليس هناك تنبيهات حاليا'),),
            );
          } else {
            return const Center(child: Text('No notifications available.'));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
