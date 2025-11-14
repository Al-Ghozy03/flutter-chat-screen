import 'dart:convert';
import 'dart:io';

import 'package:flutter_chat_screen/models/user_model.dart';
import 'package:flutter_chat_screen/utils/storage.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<UserModel> getListUser() async {
    final url = Uri.parse('http://127.0.0.1:3001/api/users');

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${getToken()}"
      },
    );
    if (response.statusCode == HttpStatus.ok) {
      return userModelFromJson(response.body);
    } else {
      var error = jsonDecode(response.body);
      throw Exception("${error["error"]} - ${error["message"]}");
    }
  }
}
