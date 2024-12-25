import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:letaskono_flutter/core/utils/CustomException.dart';
import 'package:letaskono_flutter/core/utils/constants.dart';
import 'package:letaskono_flutter/features/chat/domain/enitity/chat_message_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../core/network/http_client.dart';
import '../models/chat_message.dart';
import '../models/chat_room.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatMessage>> loadMessages(int roomId);

  void sendMessage(ChatMessageEntity message, int roomId);

  Future<Map<String, dynamic>> updateState(String state, int roomId);

  void dispose();

  Stream<dynamic> connectToChat(String roomId);

  Future<List<ChatRoom>> fetchChatRooms(int page);

  Future<ChatRoom> getKhetbaDetails(int roomId);
}

class ChatRemoteDataSourceImpl extends ChatRemoteDataSource {
  final HttpClient httpClient;
  final SharedPreferences prefs;
  WebSocketChannel? channel;

  ChatRemoteDataSourceImpl({
    required this.httpClient,
    required this.prefs,
  });

  @override
  Stream<dynamic> connectToChat(String roomId) {
    final url = "ws://${Constants.baseUrl}:8000/ws/chat/$roomId/";
    try {
      channel = WebSocketChannel.connect(Uri.parse(url));
      return channel!.stream;
    } catch (e) {
      throw Exception("Failed to connect to WebSocket: $e");
    }
  }

  @override
  void sendMessage(ChatMessageEntity message, int roomId) {
    final payload = {
      "content": message.content,
      "sender": message.senderId,
      "chat_room_id": roomId,
      "type": message.type,
    };
    channel!.sink.add(jsonEncode(payload));
  }

  @override
  Future<List<ChatMessage>> loadMessages(int roomId) async {
    String? token = prefs.getString('auth_token');
    try {
      final response = await httpClient.get(
        'api/v1/chats/messages?chat_room=$roomId',
        headers: {
          "Authorization": "Token ${token}",
          "Content-Type": "application/json",
        },
      );
      return (response.data as List<dynamic>)
          .map((data) => ChatMessage.fromJson(data))
          .toList();
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  @override
  void dispose() {
    if (channel != null) {
      channel!.sink.close();
    }
  }

  @override
  Future<List<ChatRoom>> fetchChatRooms(int page) async {
    String? token = prefs.getString('auth_token');
    try {
      final response = await httpClient.get(
        'api/v1/chats/chatrooms/?page=$page',
        headers: {
          "Authorization": "Token ${token}",
          "Content-Type": "application/json",
        },
      );
      return (response.data['results'] as List<dynamic>)
          .map((data) => ChatRoom.fromJson(data))
          .toList();
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Map<String, dynamic>> updateState(String state, int roomId) async {
    String? token = prefs.getString('auth_token');
    try {
      final response = await httpClient
          .post('api/v1/chats/chatrooms/${roomId}/update-state/', headers: {
        "Authorization": "Token ${token}",
        "Content-Type": "application/json",
      }, data: {
        "state": state,
      });
      return response.data;
    } on DioException catch (e) {
      throw Customexception((e.response?.data['error'].toString())!);
    }
  }

  @override
  Future<ChatRoom> getKhetbaDetails(int roomId) async {
    String? token = prefs.getString('auth_token');
    try {
      final response = await httpClient.get(
        'api/v1/chats/chatrooms/$roomId',
        headers: {
          "Authorization": "Token ${token}",
          "Content-Type": "application/json",
        },
      );
      return ChatRoom.fromJson(response.data['results'][0]);
    } on DioException catch (e) {
      throw Exception(e);
    }
  }
}
