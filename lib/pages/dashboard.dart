import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_chat_screen/components/chat_detail.dart';
import 'package:flutter_chat_screen/components/chat_list.dart';
import 'package:flutter_chat_screen/components/sidebar.dart';
import 'package:flutter_chat_screen/controllers/dashboard_controller.dart';
import 'package:flutter_chat_screen/models/chat_model.dart';
import 'package:flutter_chat_screen/models/identity.dart';
import 'package:flutter_chat_screen/services/chats.dart';
import 'package:flutter_chat_screen/services/socket.dart';
import 'package:flutter_chat_screen/utils/storage.dart';
import 'package:get/get.dart';

import 'dart:async';
import 'dart:html' as html;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  final DashboardController c = Get.put(DashboardController());
  final Identity identity = getIdentity();
  late Future<ChatModel> getChat;
  StreamSubscription? _visibilitySub;
  StreamSubscription? _unloadSub;
  final SocketService socketService = Get.find<SocketService>();

  @override
  void initState() {
    socketService.sendUserStatus(identity.id, 'online');
    super.initState();
    getChat = ChatService().getListChat();

    WidgetsBinding.instance.addObserver(this);

    if (kIsWeb) {
      _setupWebLifecycleListeners();
    }
  }

  void _setupWebLifecycleListeners() {
    _visibilitySub = html.document.onVisibilityChange.listen((_) {
      if (html.document.hidden!) {
        print("🔸 [WEB] Tab browser disembunyikan / user pindah tab");
      } else {
        print("🟢 [WEB] Tab browser aktif lagi");
      }
    });

    _unloadSub = html.window.onBeforeUnload.listen((_) {
      socketService.sendUserStatus(identity.id, 'offline');
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _visibilitySub?.cancel();
    _unloadSub?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (!kIsWeb) {
      if (state == AppLifecycleState.detached) {
        socketService.sendUserStatus(identity.id, 'offline');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f9fc),
      body: FutureBuilder<ChatModel>(
        future: getChat,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.hasData) {
            // Simpan ke controller hanya sekali
            if (c.chatList.isEmpty) {
              c.setChatList(snapshot.data!.data);
            }

            return Row(
              children: [
                // SIDEBAR
                Container(
                    width: 250, color: Colors.white, child: const Sidebar()),

                // CHAT LIST
                const Expanded(flex: 2, child: ChatList()),

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
