import 'package:flutter/material.dart';
import 'package:flutter_chat_screen/components/chat_detail.dart';
import 'package:flutter_chat_screen/components/chat_list.dart';
import 'package:flutter_chat_screen/components/sidebar.dart';
import 'package:flutter_chat_screen/controllers/dashboard_controller.dart';
import 'package:flutter_chat_screen/models/chat_model.dart';
import 'package:flutter_chat_screen/models/identity.dart';
import 'package:flutter_chat_screen/utils/storage.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter_chat_screen/services/chats.dart';
import 'package:get/instance_manager.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardController c = Get.put(DashboardController());
  final Identity identity = getIdentity();
  late Future getChat;

  @override
  void initState() {
    getChat = ChatService().getListChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f9fc),
      body: FutureBuilder(
        future: getChat,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return Text("Error: ${snapshot.error}");

          if (snapshot.hasData) {
            return Row(
              children: [
                // SIDEBAR
                Container(
                  width: 250,
                  color: Colors.white,
                  child: Sidebar(),
                ),

                // CHAT LIST
                Expanded(
                  flex: 2,
                  child: ChatList(chats: snapshot.data),
                ),

                // CHAT DETAIL
                Expanded(
                  flex: 3,
                  child: Obx(() {
                    final ChatModel chatModel = snapshot.data;
                    if (c.selectedChatId.value == 0) {
                      return const Center(child: Text("Welcome"));
                    }

                    final selectedChat = chatModel.data.firstWhere(
                      (element) => element.id == c.selectedChatId.value,
                      orElse: () => chatModel.data[0],
                    );

                    return ChatDetail(
                      message: selectedChat.messages,
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
          return Center(child: const Text("Empty"));
        },
      ),
    );
  }
}
