import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enitity/chat_message_entity.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/MessageBubble.dart';

class ChatPage extends StatefulWidget {
  final int? roomId, senderId, receiverId;

  const ChatPage({
    super.key,
    required this.roomId,
    required this.senderId,
    required this.receiverId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late WebSocketBloc webSocketBloc;
  final List<ChatMessageEntity> messages = [
    ChatMessageEntity(
      id: 1,
      content: 'Welcome to the chat!',
      senderId: 0,
      type: 'admin',
      timestamp: '2024-12-12T12:00:00Z',
      isRead: true,
    ),
    ChatMessageEntity(
      id: 2,
      content: 'Hello there!',
      senderId: 1,
      type: 'sender',
      timestamp: '2024-12-12T12:01:00Z',
      isRead: false,
    ),
    ChatMessageEntity(
      id: 3,
      content: 'Hi!',
      senderId: 2,
      type: 'receiver',
      timestamp: '2024-12-12T12:02:00Z',
      isRead: false,
    ),
  ];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  int senderMessageCount = 30;
  int receiverMessageCount = 30;

  @override
  void initState() {
    super.initState();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String userType) {
    if (_messageController.text.trim().isEmpty ||
        senderMessageCount <= 0 ||
        receiverMessageCount <= 0) return;
    late ChatMessageEntity message;
    setState(() {
      if (userType == 'sender' && senderMessageCount > 0) {
        message = ChatMessageEntity(
          id: DateTime.now().millisecondsSinceEpoch,
          content: _messageController.text.trim(),
          senderId: widget.senderId!,
          type: 'sender',
          timestamp: DateTime.now().toIso8601String(),
          isRead: false,
        );
        senderMessageCount--;
      } else if (userType == 'receiver' && receiverMessageCount > 0) {
        message = ChatMessageEntity(
          id: DateTime.now().millisecondsSinceEpoch,
          content: _messageController.text.trim(),
          senderId: widget.receiverId!,
          type: 'receiver',
          timestamp: DateTime.now().toIso8601String(),
          isRead: false,
        );
        receiverMessageCount--;
      }
    });

    BlocProvider.of<WebSocketBloc>(context, listen: false)
        .add(SendMessageEvent(message, widget.roomId!));
    _messageController.clear();
  }

  Widget _buildMessage(ChatMessageEntity message) {
    final messageId = message.senderId;
    if (message.type == "admin") {
      return Center(
        child: MessageBubble(
          text: message.content,
          backgroundColor: Colors.orange[300]!,
          textColor: Colors.white,
          isBold: true,
        ),
      );
    }
    if (messageId == widget.senderId) {
      return Align(
        alignment: Alignment.centerRight,
        child: MessageBubble(
          text: message.content,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: MessageBubble(
          text: message.content,
          backgroundColor: Colors.grey[300]!,
          textColor: Colors.black,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.roomId == null) {
      return const Center(
        child: Text('ليس هناك غرفة موجودة !'),
      );
    }
    return BlocConsumer<WebSocketBloc, WebSocketState>(
      listener: (context, state) {
        if (state is WebSocketMessageReceived) {
          messages.add(state.message);
          _scrollToBottom();
        } else if (state is WebSocketDisconnected) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text("إلفاء الاتصال")),
          // );
        } else if (state is MessageLimitReached) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("وصلت للحد الأقصى من الرسائل")),
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sender: $senderMessageCount messages left'),
                  Text('Receiver: $receiverMessageCount messages left'),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: messages.length,
                itemBuilder: (context, index) => _buildMessage(messages[index]),
              ),
            ),
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Type a message...',
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: senderMessageCount > 0
                            ? () => _sendMessage('sender')
                            : null,
                        icon: const Icon(Icons.send, color: Colors.blueAccent),
                      ),
                      IconButton(
                        onPressed: receiverMessageCount > 0
                            ? () => _sendMessage('receiver')
                            : null,
                        icon: const Icon(Icons.person, color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safely access the context to add the event to the bloc
    BlocProvider.of<WebSocketBloc>(context, listen: false)
        .add(DisconnectWebSocket());
  }
}
