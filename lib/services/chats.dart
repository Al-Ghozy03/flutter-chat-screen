import 'dart:convert';
import 'dart:io';

import 'package:flutter_chat_screen/models/chat_model.dart';
import 'package:flutter_chat_screen/models/generate_room_model.dart';
import 'package:flutter_chat_screen/models/identity.dart';
import 'package:flutter_chat_screen/utils/storage.dart';
import 'package:http/http.dart' as http;

class ChatService {
  Future<ChatModel> getListChat() async {
    final url = Uri.parse('http://127.0.0.1:3001/api/chat');

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${getToken()}"
      },
    );
    if (response.statusCode == HttpStatus.ok) {
      return chatModelFromJson(response.body);
    } else {
      var error = jsonDecode(response.body);
      throw Exception("${error["error"]} - ${error["message"]}");
    }
  }

  Future<GenerateRoomModel> generateRoom(int user2) async {
    final url = Uri.parse('http://127.0.0.1:3001/api/chat/generate-room-code');
    final Identity identity = getIdentity();

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${getToken()}"
        },
        body: jsonEncode({"user_1": identity.id, "user_2": user2}));
    if (response.statusCode == HttpStatus.created) {
      return generateRoomModelFromJson(response.body);
    } else {
      var error = jsonDecode(response.body);
      throw Exception("${error["error"]} - ${error["message"]}");
    }
  }
}
