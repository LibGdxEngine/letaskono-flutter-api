import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class ChatRoomWidget extends StatelessWidget {
  final Map<String, dynamic> chatRoomData;

  const ChatRoomWidget({Key? key, required this.chatRoomData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String numberToString(num number) {
      // Convert the number to a JSON string
      String jsonString = jsonEncode(number);

      // Calculate the hash of the JSON string
      var bytes = utf8.encode(jsonString);
      var digest = sha256.convert(bytes);

      // Convert the hash to a hexadecimal string
      String hashString = digest.toString().substring(0, 7);

      return hashString;
    }

    Map<String, String> stateMap = {
      "open": "مستمرة",
      "closed": "مغلقة",
      "khetba": "في مرحلة الخطبة"
    };
    final currentUserCode = chatRoomData['current_user_code'];
    int? otherUserCode;
    String? currentUserState, otherUserState;
    int? currentMessageCount;
    if (currentUserCode == chatRoomData['male']) {
      otherUserCode = chatRoomData['female'];
      currentUserState = chatRoomData['male_state'];
      otherUserState = chatRoomData['female_state'];
      currentMessageCount = chatRoomData['male_message_count'];
    } else if (currentUserCode == chatRoomData['female']) {
      otherUserCode = chatRoomData['male'];
      currentUserState = chatRoomData['female_state'];
      otherUserState = chatRoomData['male_state'];
      currentMessageCount = chatRoomData['female_message_count'];
    }
    final isKhetba = currentUserState == "accept" && otherUserState == "accept";
    final date = DateTime.parse(chatRoomData['created_at']);
    final hDate = HijriCalendar.fromDate(date);
    final statusColors = {
      "accept": Colors.green,
      "reject": Colors.red,
    };
    final maleCircleColor = statusColors[chatRoomData['status']] ?? Colors.grey;
    return GestureDetector(
      onTap: () {
        chatRoomData['state'] == "closed"
            ? ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('هذه المحادثة مغلقة')),
              )
            : isKhetba
                ? Navigator.pushNamed(context, "/khetba",
                    arguments: {'roomId': chatRoomData['id'] as int?})
                : Navigator.pushNamed(context, '/chat', arguments: {
                    'currentMessageCount': currentMessageCount,
                    'currentUserState': currentUserState,
                    'otherUserState': otherUserState,
                    'roomId': chatRoomData['id'] as int?,
                    'senderId': currentUserCode as int?,
                    'receiverId': otherUserCode as int?,
                  });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chat Room Name
            Wrap(
              children: [
                Text(
                  'محادثة رقم',
                  style: TextStyle(
                      color: chatRoomData['state'] == "closed"
                          ? Colors.grey
                          : Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  numberToString(chatRoomData['id']),
                  style: TextStyle(
                      color: chatRoomData['state'] == "closed"
                          ? Colors.grey
                          : Theme.of(context).colorScheme.primary),
                ),
                // Text(
                //   currentUserCode.toString(),
                //   style: TextStyle(
                //       color: chatRoomData['state'] == "closed"
                //           ? Colors.grey
                //           : Theme.of(context).colorScheme.primary),
                // ),
                const SizedBox(
                  width: 6,
                ),
                // Container(
                //   width: 25,
                //   height: 25,
                //   decoration: BoxDecoration(
                //     color: maleCircleColor,
                //     shape: BoxShape.circle,
                //   ),
                //   child: Center(
                //       child: Text(
                //     chatRoomData['male_message_count'].toString(),
                //     style: const TextStyle(
                //       color: Colors.white,
                //     ),
                //   )),
                // ),
                // const SizedBox(
                //   width: 6,
                // ),
                // Text(
                //   'وبين',
                //   style: TextStyle(
                //       color: chatRoomData['state'] == "closed"
                //           ? Colors.grey
                //           : Theme.of(context).colorScheme.primary),
                // ),
                // const SizedBox(
                //   width: 6,
                // ),
                // Text(
                //   otherUserCode.toString(),
                //   style: TextStyle(
                //       color: chatRoomData['state'] == "closed"
                //           ? Colors.grey
                //           : Theme.of(context).colorScheme.primary),
                // ),
                // const SizedBox(
                //   width: 6,
                // ),
                // Container(
                //   width: 25,
                //   height: 25,
                //   decoration: BoxDecoration(
                //     color: maleCircleColor,
                //     shape: BoxShape.circle,
                //   ),
                //   child: Center(
                //       child: Text(
                //     chatRoomData['female_message_count'].toString(),
                //     style: const TextStyle(
                //       color: Colors.white,
                //     ),
                //   )),
                // ),
                const SizedBox(
                  width: 6,
                ),
              ],
            ),

            const SizedBox(height: 6.0),
            Text(
              'حالة المحادثة: ${stateMap[chatRoomData['state']]}',
              style: TextStyle(
                  color: chatRoomData['state'] == "closed"
                      ? Colors.grey
                      : Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 6.0),
            Text(
              'بتاريخ: ${hDate}',
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .inverseSurface
                      .withOpacity(0.8)),
            ),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
