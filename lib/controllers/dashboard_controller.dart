import 'package:flutter/material.dart';
import 'package:flutter_chat_screen/models/chat_model.dart';
import 'package:flutter_chat_screen/services/socket.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  RxInt selectedChatId = 0.obs;
  RxList<DataChat> chatList = <DataChat>[].obs;
  RxMap<String, RxList<Message>> roomMessages = <String, RxList<Message>>{}.obs;

  Color getUserStatusColor(DataChat? chat, int identityId) {
    if (chat == null) return Colors.grey;
    final user = (chat.user1.id == identityId) ? chat.user2 : chat.user1;
    return user.status.value == 'online' ? Colors.green : Colors.grey;
  }

  void setChatList(List<DataChat> chats) {
    chatList.assignAll(chats);
    final socket = Get.find<SocketService>();

    for (final chat in chats) {
      roomMessages[chat.roomCode] = RxList<Message>.from(chat.messages);
      socket.joinRoom(chat.roomCode);
    }
  }

  void selectChat(int id) => selectedChatId.value = id;

  void setMessages(String roomCode, List<Message> msgs) {
    roomMessages[roomCode] ??= <Message>[].obs;
    roomMessages[roomCode]!.assignAll(msgs);
  }

  void addMessage(String roomCode, Message msg) {
    roomMessages[roomCode] ??= <Message>[].obs;
    roomMessages[roomCode]!.add(msg);

    final idx = chatList.indexWhere((c) => c.roomCode == roomCode);
    if (idx != -1) {
      chatList[idx].messages.add(msg);
      chatList.refresh();
    }
  }
}
