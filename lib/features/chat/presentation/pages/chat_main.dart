import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letaskono_flutter/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:letaskono_flutter/features/chat/presentation/pages/chat_page.dart';

class ChatMain extends StatefulWidget {
  final int? roomId, senderId, receiverId, currentMessageCount;
  final String? currentUserState, otherUserState;
  const ChatMain({
    super.key,
    required this.currentMessageCount,
    required this.roomId,
    required this.senderId,
    required this.receiverId,
    required this.currentUserState,
    required this.otherUserState,
  });

  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  @override
  Widget build(BuildContext context) {
    final chatBloc = WebSocketBloc();
    return BlocProvider(
      create: (context) =>
      chatBloc..add(ConnectWebSocket(widget.roomId!)),
      child: ChatPage(
        chatBloc: chatBloc,
        currentUserState: widget.currentUserState,
        otherUserState: widget.otherUserState,
        roomId: widget.roomId,
        currentMessageCount: widget.currentMessageCount,
        senderId: widget.senderId,
        receiverId: widget.receiverId,
      ),
    );
  }
}
