import 'package:flutter/material.dart';
import 'package:flutter_chat_screen/models/chat_model.dart';
import 'package:flutter_chat_screen/models/identity.dart';
import 'package:flutter_chat_screen/utils/storage.dart';
import 'package:intl/intl.dart';

class ChatDetail extends StatefulWidget {
  List<Message> message;
  String roomCode;
  User user;
  ChatDetail(
      {super.key,
      required this.message,
      required this.roomCode,
      required this.user});

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  final Identity identity = getIdentity();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff6f8fb),
      child: Column(
        children: [
          // HEADER
          Container(
            height: 70,
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: Row(
              children: [
                CircleAvatar(),
                SizedBox(width: 10),
                Text(widget.user.name, style: TextStyle(fontSize: 18)),
              ],
            ),
          ),

          // CHAT CONTENT
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: widget.message.length,
              itemBuilder: (context, index) => chatBubble(
                  widget.message[index].content,
                  widget.message[index].senderId == identity.id,
                  DateFormat.Hm().format(widget.message[index].createdAt)),
            ),
          ),

          // INPUT MESSAGE
          Container(
            padding: EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Type something here...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Icon(Icons.send, color: Colors.green, size: 32),
              ],
            ),
          ),
        ],
      ),
    );
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
                Text(
                  time,
                  style: TextStyle(fontSize: 10),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(text),
                ),
              ]
            : [
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(text),
                ),
                SizedBox(width: 8),
                Text(
                  time,
                  style: TextStyle(fontSize: 10),
                ),
              ],
      ),
    );
  }
}
