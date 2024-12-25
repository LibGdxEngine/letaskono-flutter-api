import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letaskono_flutter/core/utils/ExpandingCircleProgress.dart';
import 'package:letaskono_flutter/features/users/data/models/chat_room.dart';

import '../bloc/chat_bloc.dart';
import '../widgets/ChatRoomWidget.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      // Add pull-to-refresh functionality
      onRefresh: () async {},
      child: BlocConsumer<WebSocketBloc, WebSocketState>(
        listener: (context, state) {
          if (state is ChatRoomsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('حدث خطأ')),
            );
          }
        },
        builder: (context, state) {
          if (state is ChatRoomsLoading) {
            return ExpandingCircleProgress();
          } else if (state is ChatRoomsLoaded) {
            final rooms = state.rooms;
            return rooms.isNotEmpty
                ? SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListView.builder(
                        itemCount: rooms.length,
                        itemBuilder: (context, index) {
                          final newRoom = rooms[index];
                          return ChatRoomWidget(chatRoomData: newRoom.toJson());
                        },
                      ),
                    ),
                  )
                : const Center(
                    child: Text("لا توجد أي محادثات حاليا"),
                  );
          } else if (state is ChatRoomsError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return Center(
              child: ExpandingCircleProgress(),
            );
          }
        },
      ),
    );
  }
}
