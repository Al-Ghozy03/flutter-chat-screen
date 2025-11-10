import 'package:flutter/material.dart';
import 'package:flutter_chat_screen/controllers/dashboard_controller.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final c = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    final chats = List.generate(10, (i) => "Contact $i");

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // TAB FILTER
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 20),
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
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          // LIST CHAT
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return Obx(() {
                  final isSelected = c.selectedChatId.value == index;

                  return Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Color.fromARGB(255, 238, 238, 238)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(),
                      title: Text(chats[index]),
                      subtitle: Text("Last message preview..."),
                      trailing: Text("12m"),
                      onTap: () => c.selectChat(index),
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
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
      ),
      child: Text(text),
    );
  }
}
