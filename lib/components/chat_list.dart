import 'package:flutter/material.dart';
import 'package:flutter_chat_screen/components/user_modal.dart';
import 'package:flutter_chat_screen/controllers/dashboard_controller.dart';
import 'package:flutter_chat_screen/models/identity.dart';
import 'package:flutter_chat_screen/utils/storage.dart';
import 'package:flutter_chat_screen/utils/time_format.dart';
import 'package:get/get.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<DashboardController>();
    final Identity identity = getIdentity();

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => UserModal(),
                );
              },
              child: Text("New chat"),
            ),
          ),

          // LIST CHAT
          Expanded(
            child: Obx(() {
              final chats = c.chatList;

              final sortedChats = [...chats];

              sortedChats.sort((a, b) {
                final aTime = a.messages.isNotEmpty
                    ? a.messages.last.createdAt
                    : DateTime.fromMillisecondsSinceEpoch(0);
                final bTime = b.messages.isNotEmpty
                    ? b.messages.last.createdAt
                    : DateTime.fromMillisecondsSinceEpoch(0);
                return bTime.compareTo(aTime);
              });

              return ListView.builder(
                itemCount: sortedChats.length,
                itemBuilder: (context, index) {
                  final chat = sortedChats[index];
                  final lastMsg =
                      chat.messages.isNotEmpty ? chat.messages.last : null;

                  return Obx(() {
                    final isSelected = c.selectedChatId.value == chat.id;
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
                          lastMsg != null
                              ? "${lastMsg.senderId == identity.id ? "You: " : ""}${lastMsg.content}"
                              : "(No messages)",
                        ),
                        trailing: Text(
                          lastMsg != null
                              ? formatTimestamp(lastMsg.createdAt)
                              : "",
                        ),
                        onTap: () => c.selectChat(chat.id),
                      ),
                    );
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget tab(String text) => Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade200,
        ),
        child: Text(text),
      );
}
