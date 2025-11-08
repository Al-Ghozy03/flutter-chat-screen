import 'package:flutter/material.dart';

class ChatDetail extends StatefulWidget {
  const ChatDetail({super.key});

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
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
                Text("Carlos Martin", style: TextStyle(fontSize: 18)),
              ],
            ),
          ),

          // CHAT CONTENT
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                chatBubble(
                    "Hi there, I saw your ad about the new fitness tracker...",
                    false),
                chatBubble(
                    "Hey I'm interested in the early bird discount...", false),
                chatBubble("Hi there! Thanks for your interest...", true),
                chatBubble(
                    "I received an email about your product launch...", false),
              ],
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

  Widget chatBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text),
      ),
    );
  }
}
