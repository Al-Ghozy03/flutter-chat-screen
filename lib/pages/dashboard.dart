import 'package:flutter/material.dart';
import 'package:flutter_chat_screen/components/chat_detail.dart';
import 'package:flutter_chat_screen/components/chat_list.dart';
import 'package:flutter_chat_screen/components/sidebar.dart';
import 'package:flutter_chat_screen/controllers/dashboard_controller.dart';
import 'package:flutter_chat_screen/models/chat_model.dart';
import 'package:flutter_chat_screen/models/identity.dart';
import 'package:flutter_chat_screen/services/chats.dart';
import 'package:flutter_chat_screen/utils/storage.dart';
import 'package:get/get.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardController c = Get.put(DashboardController());
  final Identity identity = getIdentity();
  late Future<ChatModel> getChat;

  @override
  void initState() {
    super.initState();
    getChat = ChatService().getListChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f9fc),
      body: FutureBuilder(
        future: getChat,
        builder: (context, AsyncSnapshot<ChatModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return Text("Error: ${snapshot.error}");

          if (snapshot.hasData) {
            // simpan ke controller hanya sekali
            if (c.chatList.isEmpty) {
              c.setChatList(snapshot.data!.data);
            }

            return Row(
              children: [
                // SIDEBAR
                Container(width: 250, color: Colors.white, child: Sidebar()),

                // CHAT LIST
                Expanded(flex: 2, child: ChatList()),

                // CHAT DETAIL
                Expanded(
                  flex: 3,
                  child: Obx(() {
                    if (c.selectedChatId.value == 0) {
                      return const Center(child: Text("Welcome"));
                    }

                    final selectedChat = c.chatList.firstWhere(
                      (e) => e.id == c.selectedChatId.value,
                      orElse: () => c.chatList.first,
                    );

                    return ChatDetail(
                      roomCode: selectedChat.roomCode,
                      user: selectedChat.user1.id == identity.id
                          ? selectedChat.user2
                          : selectedChat.user1,
                    );
                  }),
                ),
              ],
            );
          }
          return const Center(child: Text("Empty"));
        },
      ),
    );
  }
}
