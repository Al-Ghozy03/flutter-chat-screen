import 'package:flutter/material.dart';
import 'package:flutter_chat_screen/api/chats.dart';
import 'package:flutter_chat_screen/controllers/dashboard_controller.dart';
import 'package:flutter_chat_screen/models/chat_model.dart';
import 'package:flutter_chat_screen/models/identity.dart';
import 'package:flutter_chat_screen/utils/storage.dart';
import 'package:flutter_chat_screen/utils/time_format.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final c = Get.find<DashboardController>();
  late Future getChat;
  final Identity identity = getIdentity();

  @override
  void initState() {
    getChat = ChatService().getListChat();
    super.initState();
  }

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
            child: FutureBuilder(
              future: getChat,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) return Text("Error: ${snapshot.error}");

                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.data.length,
                    itemBuilder: (context, index) {
                      return _listChat(snapshot.data, index, identity);
                    },
                  );
                }
                return const Text("Empty");
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _listChat(ChatModel chatModel, int i, Identity identity) {
    var data = chatModel.data[i];

    return Obx(() {
      bool isSelected = c.selectedChatId.value == data.id;

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
            data.user1.id == identity.id ? data.user2.name : data.user1.name,
          ),
          subtitle: Text(
            data.messages.isNotEmpty
                ? "${data.messages.last.senderId == identity.id ? "You: " : ""}${data.messages.last.content}"
                : "(No messages)",
          ),
          trailing: Text(
            data.messages.isNotEmpty
                ? formatTimestamp(data.messages.last.createdAt)
                : "",
          ),
          onTap: () => c.selectChat(data.id),
        ),
      );
    });
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
