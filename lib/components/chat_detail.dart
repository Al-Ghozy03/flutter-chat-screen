import 'package:flutter/material.dart';
import 'package:flutter_chat_screen/controllers/dashboard_controller.dart';
import 'package:flutter_chat_screen/models/chat_model.dart';
import 'package:flutter_chat_screen/models/identity.dart';
import 'package:flutter_chat_screen/services/socket.dart';
import 'package:flutter_chat_screen/utils/storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatDetail extends StatefulWidget {
  final List<Message> message;
  final String roomCode;
  final User user;
  ChatDetail({
    super.key,
    required this.message,
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
  late RxList<Message> messages;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    textEditingController = TextEditingController();
    scrollController = ScrollController();

    // copy pesan awal dari API
    messages = RxList<Message>.from(widget.message);

    // scroll ke bawah setelah widget build pertama kali
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    // listen setiap ada pesan baru dari socket
    ever(socketService.newMessage, (msg) {
      if (msg == null) return;

      if (msg.roomCode == widget.roomCode) {
        messages.add(msg);
        _scrollToBottom();
      }
    });

    // join room
    socketService.joinRoom(widget.roomCode);
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfff6f8fb),
      child: Column(
        children: [
          // HEADER
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: Row(
              children: [
                const CircleAvatar(),
                const SizedBox(width: 10),
                Text(widget.user.name, style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),

          // CHAT CONTENT
          Expanded(
            child: Obx(
              () => ListView.builder(
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
              ),
            ),
          ),

          // INPUT MESSAGE
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

  void _sendMessage(String value) {
    final text = value.trim();
    if (text.isEmpty) return;

    socketService.sendMessage(
      c.selectedChatId.value,
      identity.id,
      text,
      widget.roomCode,
      null,
    );

    textEditingController.clear();
    _scrollToBottom();
  }

  Widget chatBubble(String text, bool isMe, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
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
}
