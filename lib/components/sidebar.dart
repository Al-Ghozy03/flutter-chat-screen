import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Lead Finder",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 30),
          menuItem(Icons.dashboard, "Dashboard"),
          menuItem(Icons.person, "Account"),
          menuItem(Icons.chat, "Chats"),
          menuItem(Icons.ads_click, "Campaign"),
          menuItem(Icons.search, "Lead Finder"),
          Spacer(),
          Row(
            children: [
              CircleAvatar(radius: 20, backgroundColor: Colors.grey),
              SizedBox(width: 10),
              Text("Jhon Doe"),
            ],
          )
        ],
      ),
    );
  }

  Widget menuItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 22),
          SizedBox(width: 12),
          Text(title, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
