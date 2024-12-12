import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letaskono_flutter/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:letaskono_flutter/features/chat/presentation/pages/chat_page.dart';

class ChatMain extends StatefulWidget {
  final int? roomId;

  const ChatMain({super.key, required this.roomId});

  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WebSocketBloc()..add(ConnectWebSocket(widget.roomId!)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Chat')),
        body: ChatPage(roomId: widget.roomId),
      ),
    );
  }
}
