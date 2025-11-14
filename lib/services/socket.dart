import 'package:flutter_chat_screen/controllers/dashboard_controller.dart';
import 'package:flutter_chat_screen/models/chat_model.dart';
import 'package:flutter_chat_screen/models/identity.dart';
import 'package:flutter_chat_screen/utils/storage.dart';
import 'package:get/get.dart';
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
      final msg = Message.fromSocketJson(data);
      newMessage.value = msg;
      final Identity identity = getIdentity();
      // print("user ${identity.id} - ${identity.name} dapat data $data");
      final DashboardController controller = Get.find<DashboardController>();

      controller.addMessage(msg.roomCode!, msg);

      final idx =
          controller.chatList.indexWhere((c) => c.roomCode == msg.roomCode);
      if (idx != -1) {
        controller.chatList[idx].messages!.add(msg);
        controller.chatList.refresh();
      }
    });

    socket.on("retrieveUserStatus", (data) {
      final DashboardController controller = Get.find<DashboardController>();
      var selectedChat = controller.chatList.firstWhereOrNull(
        (element) =>
            element.user1.id == data["id"] || element.user2.id == data["id"],
      );

      if (selectedChat != null) {
        if (selectedChat.user1.id == data["id"]) {
          selectedChat.user1.status.value = data["status"];
          selectedChat.user1.lastOnline = data["last_online"];
        }

        if (selectedChat.user2.id == data["id"]) {
          selectedChat.user2.status.value = data["status"];
          selectedChat.user2.lastOnline = data["last_online"];
        }
      }
      controller.chatList.refresh();
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

  void sendUserStatus(int id, String status) {
    socket.emit("userStatus", {"user_id": id, "status": status});
  }
}
