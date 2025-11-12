import 'package:flutter/material.dart';
import 'package:flutter_chat_screen/controllers/dashboard_controller.dart';
import 'package:flutter_chat_screen/models/chat_model.dart';
import 'package:flutter_chat_screen/models/identity.dart';
import 'package:flutter_chat_screen/services/socket.dart';
import 'package:flutter_chat_screen/utils/storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatDetail extends StatefulWidget {
  final String roomCode;
  final User user;

  const ChatDetail({
    super.key,
    required this.roomCode,
    required this.user,
  });

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  final Identity identity = getIdentity();
  final SocketService socketService = Get.find<SocketService>();
  final DashboardController c = Get.find<DashboardController>();

  late TextEditingController textEditingController;
  late Worker messageListener;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    _listenToSocket();

    socketService.joinRoom(widget.roomCode);
  }

  @override
  void didUpdateWidget(covariant ChatDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.roomCode != widget.roomCode) {
      messageListener.dispose();

      socketService.joinRoom(widget.roomCode);
      _listenToSocket();
    }
  }

  void _listenToSocket() {
    messageListener = ever(socketService.newMessage, (msg) {
      if (msg == null) return;
      if (msg.roomCode == widget.roomCode) {
        c.addMessage(widget.roomCode, msg);
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 20), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    messageListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfff6f8fb),
      child: Column(
        children: [
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const CircleAvatar(),
                const SizedBox(width: 10),
                Text(widget.user.name, style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final messages =
                  c.roomMessages[widget.roomCode] ?? <Message>[].obs;

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return chatBubble(
                    msg.content,
                    msg.senderId == identity.id,
                    DateFormat.Hm().format(msg.createdAt),
                  );
                },
              );
            }),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    onSubmitted: _sendMessage,
                    decoration: InputDecoration(
                      hintText: "Type something here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green, size: 32),
                  onPressed: () => _sendMessage(textEditingController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    socketService.sendMessage(
      c.selectedChatId.value,
      identity.id,
      trimmed,
      widget.roomCode,
      null,
    );

    textEditingController.clear();
    Future.delayed(const Duration(milliseconds: 50), _scrollToBottom);
  }

  Widget chatBubble(String text, bool isMe, String time) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: isMe
              ? [
                  Text(time, style: const TextStyle(fontSize: 10)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(text),
                  ),
                ]
              : [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(text),
                  ),
                  const SizedBox(width: 8),
                  Text(time, style: const TextStyle(fontSize: 10)),
                ],
        ),
      );
}
