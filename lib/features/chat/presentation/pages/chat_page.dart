import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letaskono_flutter/core/utils/CustomButton.dart';
import 'package:letaskono_flutter/core/utils/CustomDialog.dart';
import 'package:letaskono_flutter/features/users/presentation/widgets/CircularText.dart';

import '../../domain/enitity/chat_message_entity.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/AcceptRejectToggle.dart';
import '../widgets/MessageBubble.dart';

class ChatPage extends StatefulWidget {
  final int? roomId, senderId, receiverId, currentMessageCount;
  final WebSocketBloc chatBloc;
  String? currentUserState, otherUserState;

  ChatPage({
    super.key,
    required this.currentMessageCount,
    required this.roomId,
    required this.senderId,
    required this.receiverId,
    required this.chatBloc,
    required this.currentUserState,
    required this.otherUserState,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<ChatMessageEntity> messages = [
    ChatMessageEntity(
      id: 1,
      content: 'مَا يَلْفِظُ مِنْ قَوْلٍ إِلا لَدَيْهِ رَقِيبٌ عَتِيدٌ',
      senderId: 0,
      type: 'admin',
      timestamp: DateTime.now().toString(),
      isRead: true,
    ),
  ];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  int senderMessageCount = 30;
  int receiverMessageCount = 30;
  late WebSocketBloc _chatBloc;

  @override
  void initState() {
    _chatBloc = widget.chatBloc;
    if (widget.currentUserState == "accept" &&
        widget.otherUserState == "accept") {
      _chatBloc.add(EnterKhetbaPage(widget.roomId!));
    }
    if (widget.currentMessageCount != null) {
      senderMessageCount -= widget.currentMessageCount!;
    }
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
          backgroundColor:
              Theme.of(context).colorScheme.secondary.withOpacity(0.95),
          textColor: Colors.white,
          isSender: true,
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: MessageBubble(
          text: message.content,
          backgroundColor: Theme.of(context).colorScheme.primary,
          textColor: Theme.of(context).colorScheme.surface,
          isSender: false,
        ),
      );
    }
  }

  bool? parseUserState(String? state) {
    switch (state) {
      case 'none':
        return null;
      case 'accept':
        return true;
      case 'reject':
        return false;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
            SnackBar(content: Text(state.message)),
          );
        } else if (state is ChatRoomStateUpdated) {
          if (state.maleState == "accept" && state.femaleState == "accept") {
            _chatBloc.add(EnterKhetbaPage(widget.roomId!));
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  state.maleState == "reject" || state.femaleState == "reject"
                      ? 'تم الرفض'
                      : 'تم إرسال الطلب')));
        } else if (state is KhetbaStageEntered) {
        } else if (state is ChatRoomsError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: const Text('مراسلة'),
              actions: [
                const SizedBox(width: 8),
                Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: 'عدد الرسائل المتبقية لديك',
                  child: CircularText(
                    text: senderMessageCount.toString(),
                    borderColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AcceptRejectToggle(
                    onChange: (isAccepted) {
                      if (isAccepted == true) {
                        // if(parseUserState(widget.currentUserState)!) {
                        //   return;
                        // }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(
                              title: 'هل تريد طلب رؤية شرعية ؟',
                              content: const Text(
                                  'طلب الرؤية الشرعية يعني تواصل العريس مع ولي الأمر لتحديد موعد الرؤية شرعية'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => {
                                    _chatBloc.add(ChatStateUpdated(
                                        "accept", widget.roomId!)),
                                    Navigator.pop(context, 'OK'),
                                    setState(() {
                                      widget.currentUserState = "accept";
                                    }),
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4B164C),
                                    // Darkest color
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('نعم'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    Navigator.pop(context, 'Cancel'),
                                    setState(() {}),
                                  },
                                  child: Text(
                                    'إلغاء',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.7)), // Accent color
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (isAccepted == false) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(
                              title: 'هل تريد رفض الاستمرار ؟',
                              content: const Text(
                                  'سيتم إنهاء المراسلة بينكما فور رفض أحدكما للاستمرار'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => {
                                    _chatBloc.add(ChatStateUpdated(
                                        "reject", widget.roomId!)),
                                    Navigator.pop(context, 'OK'),
                                    setState(() {
                                      widget.currentUserState = "reject";
                                    }),
                                    Navigator.pushReplacementNamed(
                                        context, "/users"),
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4B164C),
                                    // Darkest color
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('نعم'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    Navigator.pop(context, 'Cancel'),
                                    setState(() {}),
                                  },
                                  child: Text(
                                    'إلغاء',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.7)), // Accent color
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    isAcceptSelected: parseUserState(widget.currentUserState),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: messages.length,
                    itemBuilder: (context, index) =>
                        _buildMessage(messages[index]),
                  ),
                ),
                // const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8, top: 4, bottom: 4),
                  child: Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // border: Border.all(
                      //   color: Theme.of(context)
                      //       .colorScheme
                      //       .primary
                      //       .withOpacity(0.3), // Border color
                      //   width: 1.0, // Border width
                      // ),
                      borderRadius:
                          BorderRadius.circular(50), // Circular border
                    ),
                    padding: const EdgeInsets.only(
                        left: 8, right: 16, top: 0, bottom: 0),
                    // color: Theme.of(context).colorScheme.surface,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF22172A),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration.collapsed(
                                hintText: 'اكتب رسالتك',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inverseSurface)),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: senderMessageCount > 0
                                  ? () => _sendMessage('sender')
                                  : () => ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'لا يمكنك إرسال المزيد من الرسائل')),
                                      ),
                              icon: Icon(Icons.send,
                                  color: senderMessageCount > 0
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  @override
  void dispose() {
    _chatBloc.add(DisconnectWebSocket());
    super.dispose();
  }
}
