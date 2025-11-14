// To parse this JSON data, do
//
//     final generateRoomModel = generateRoomModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

GenerateRoomModel generateRoomModelFromJson(String str) =>
    GenerateRoomModel.fromJson(json.decode(str));

String generateRoomModelToJson(GenerateRoomModel data) =>
    json.encode(data.toJson());

class GenerateRoomModel {
  String message;
  Data data;

  GenerateRoomModel({
    required this.message,
    required this.data,
  });

  factory GenerateRoomModel.fromJson(Map<String, dynamic> json) =>
      GenerateRoomModel(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  int id;
  User user1;
  User user2;
  String roomCode;

  Data({
    required this.id,
    required this.user1,
    required this.user2,
    required this.roomCode,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        user1: User.fromJson(json["user_1"]),
        user2: User.fromJson(json["user_2"]),
        roomCode: json["room_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_1": user1.toJson(),
        "user_2": user2.toJson(),
        "room_code": roomCode,
      };
}

class User {
  int id;
  String name;
  String email;
  RxString status;
  dynamic avatarUrl;
  DateTime? lastOnline;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.avatarUrl,
    required this.lastOnline,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        status: (json["status"] ?? 'offline').toString().obs,
        avatarUrl: json["avatar_url"],
        lastOnline: json["last_online"] == null
            ? null
            : DateTime.parse(json["last_online"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "status": status.value,
        "avatar_url": avatarUrl,
        "last_online": lastOnline?.toIso8601String(),
      };
}
