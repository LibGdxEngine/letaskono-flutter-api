import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letaskono_flutter/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:letaskono_flutter/features/chat/presentation/pages/chat_list_page.dart';

class ChatListMain extends StatefulWidget {
  const ChatListMain({super.key});

  @override
  State<ChatListMain> createState() => _ChatListMainState();
}

class _ChatListMainState extends State<ChatListMain> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WebSocketBloc()..add(FetchChatRoomsEvent(page: 1)),
      child: const Center(
        child: ChatListPage(),
      ),
    );
  }
}
