import 'package:flutter/material.dart';
import 'package:flutter_chat_screen/controllers/dashboard_controller.dart';
import 'package:flutter_chat_screen/models/chat_model.dart';
import 'package:flutter_chat_screen/models/identity.dart';
import 'package:flutter_chat_screen/services/socket.dart';
import 'package:flutter_chat_screen/utils/storage.dart';
import 'package:flutter_chat_screen/utils/time_format.dart';
import 'package:get/get.dart';

class ChatList extends StatelessWidget {
  final ChatModel chats;
  ChatList({super.key, required this.chats});

  final c = Get.find<DashboardController>();
  final Identity identity = getIdentity();
  final socketService = Get.find<SocketService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // TAB FILTER
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                tab("All Message"),
                tab("Instagram"),
                tab("Whatsapp"),
                tab("Facebook"),
              ],
            ),
          ),

          // SEARCH
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          // LIST CHAT
          Expanded(
            child: ListView.builder(
              itemCount: chats.data.length,
              itemBuilder: (context, index) {
                final chat = chats.data[index];
                return Obx(() {
                  bool isSelected = c.selectedChatId.value == chat.id;
                  return Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color.fromARGB(255, 235, 240, 255)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(),
                      title: Text(
                        chat.user1.id == identity.id
                            ? chat.user2.name
                            : chat.user1.name,
                      ),
                      subtitle: Text(
                        chat.messages.isNotEmpty
                            ? "${chat.messages.last.senderId == identity.id ? "You: " : ""}${chat.messages.last.content}"
                            : "(No messages)",
                      ),
                      trailing: Text(
                        chat.messages.isNotEmpty
                            ? formatTimestamp(chat.messages.last.createdAt)
                            : "",
                      ),
                      onTap: () {
                        c.selectChat(chat.id);
                      },
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget tab(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
      ),
      child: Text(text),
    );
  }
}
