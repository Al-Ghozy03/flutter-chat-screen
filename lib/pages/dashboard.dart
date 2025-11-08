import 'package:flutter/material.dart';
import 'package:flutter_chat_screen/components/chat_detail.dart';
import 'package:flutter_chat_screen/components/chat_list.dart';
import 'package:flutter_chat_screen/components/sidebar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f9fc),
      body: Row(
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
            child: ChatList(),
          ),

          // CHAT DETAIL
          Expanded(
            flex: 3,
            child: ChatDetail(),
          ),
        ],
      ),
    );
  }
}
