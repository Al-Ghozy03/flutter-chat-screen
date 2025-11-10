// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
    String message;
    List<Datum> data;

    ChatModel({
        required this.message,
        required this.data,
    });

    factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int id;
    String roomCode;
    User user1;
    User user2;
    List<Message> messages;

    Datum({
        required this.id,
        required this.roomCode,
        required this.user1,
        required this.user2,
        required this.messages,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        roomCode: json["room_code"],
        user1: User.fromJson(json["user1"]),
        user2: User.fromJson(json["user2"]),
        messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "room_code": roomCode,
        "user1": user1.toJson(),
        "user2": user2.toJson(),
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
    };
}

class Message {
    int id;
    int chatId;
    String content;
    int senderId;
    DateTime createdAt;
    dynamic attachmentUrl;

    Message({
        required this.id,
        required this.chatId,
        required this.content,
        required this.senderId,
        required this.createdAt,
        required this.attachmentUrl,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        chatId: json["chat_id"],
        content: json["content"],
        senderId: json["sender_id"],
        createdAt: DateTime.parse(json["created_at"]),
        attachmentUrl: json["attachment_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "chat_id": chatId,
        "content": content,
        "sender_id": senderId,
        "created_at": createdAt.toIso8601String(),
        "attachment_url": attachmentUrl,
    };
}

class User {
    int id;
    String name;
    String email;
    dynamic avatarUrl;

    User({
        required this.id,
        required this.name,
        required this.email,
        required this.avatarUrl,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        avatarUrl: json["avatar_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "avatar_url": avatarUrl,
    };
}
