import 'package:flutter/material.dart';
import 'package:flutter_chat_screen/controllers/dashboard_controller.dart';
import 'package:flutter_chat_screen/models/chat_model.dart';
import 'package:flutter_chat_screen/services/chats.dart';
import 'package:flutter_chat_screen/services/user.dart';
import 'package:get/get.dart';

class UserModal extends StatefulWidget {
  const UserModal({super.key});

  @override
  State<UserModal> createState() => _UserModalState();
}

class _UserModalState extends State<UserModal> {
  bool isLoading = false;
  final DashboardController controller = Get.find<DashboardController>();
  @override
  Widget build(BuildContext context) {
    void handleGenerateRoom(int user2) async {
      try {
        setState(() {
          isLoading = true;
        });
        final response = await ChatService().generateRoom(user2);
        var data = response.data;
        controller.selectChat(data.id);
        var selectChat = controller.chatList.firstWhereOrNull(
          (element) => element.roomCode == data.roomCode,
        );
        if (selectChat == null) {
          DataChat newData = DataChat(
            id: data.id,
            roomCode: data.roomCode,
            user1: User(
              id: data.user1.id,
              name: data.user1.name,
              email: data.user1.email,
              avatarUrl: data.user1.avatarUrl,
              status: data.user1.status,
              lastOnline: data.user1.lastOnline,
            ),
            user2: User(
              id: data.user2.id,
              name: data.user2.name,
              email: data.user2.email,
              avatarUrl: data.user2.avatarUrl,
              status: data.user2.status,
              lastOnline: data.user2.lastOnline,
            ),
            messages: [],
          );
          controller.setChatList([...controller.chatList, newData]);
          controller.chatList.refresh();
        }
        Get.back();
      } catch (e) {
        print("error generate room $e");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: FutureBuilder(
        future: UserService().getListUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final users = snapshot.data!.data;

          return ListView.separated(
            itemCount: snapshot.data!.data.length,
            separatorBuilder: (context, i) => Divider(),
            itemBuilder: (context, i) {
              final user = users[i];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                onTap: () {
                  handleGenerateRoom(users[i].id);
                },
              );
            },
          );
        },
      ),
    );
  }
}
