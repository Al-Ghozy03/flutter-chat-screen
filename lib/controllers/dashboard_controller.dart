import 'package:flutter_chat_screen/models/chat_model.dart';
import 'package:get/state_manager.dart';

class DashboardController extends GetxController {
  RxInt selectedChatId = 0.obs;
  RxMap<String, RxList<Message>> roomMessages = <String, RxList<Message>>{}.obs;
  RxList<ChatModel> chatList = <ChatModel>[].obs;

  void setChatList(List<ChatModel> chats) {
    chatList.assignAll(chats);
  }

  void setMessages(String roomCode, List<Message> msgs) {
    roomMessages[roomCode] = RxList<Message>.from(msgs);
  }

  void addMessage(String roomCode, Message msg) {
    if (!roomMessages.containsKey(roomCode)) {
      roomMessages[roomCode] = RxList<Message>();
    }
    roomMessages[roomCode]!.add(msg);
  }

  void selectChat(int id) {
    selectedChatId.value = id;
  }
}
