import 'package:flutter_chat_screen/models/chat_model.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends GetxService {
  late IO.Socket socket;
  Rx<Message?> newMessage = Rx<Message?>(null);

  @override
  void onInit() {
    socket = IO.io("http://localhost:3001", {
      "transports": ["websocket"],
      "autoConnect": true,
    });

    socket.onConnect((_) {
      print("Connected");
    });

    socket.onDisconnect((data) {
      print("Disconnect: ${data}");
    });

    socket.on("retrieveMessage", (data) {
      newMessage.value = Message.fromSocketJson(data);
    });

    super.onInit();
  }

  void joinRoom(String roomCode) {
    socket.emit("joinRoom", roomCode);
  }

  void sendMessage(
    int chatId,
    int senderId,
    String content,
    String roomCode,
    String? attachmentUrl,
  ) {
    socket.emit("sendMessage", {
      "chat_id": chatId,
      "sender_id": senderId,
      "content": content,
      "attachment_url": attachmentUrl,
      "room_code": roomCode,
    });
  }
}
