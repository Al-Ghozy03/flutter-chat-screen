import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future login(String email, String password) async {
  final url = Uri.parse('http://127.0.0.1:3001/api/users/login');

  final response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}));
  if (response.statusCode == HttpStatus.created) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    var error = jsonDecode(response.body);
    throw Exception("${error["error"]} - ${error["message"]}");
  }
}

Future register(String email, String name, String password) async {
  final url = Uri.parse('http://127.0.0.1:3001/api/users/register');

  final response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "name": name, "password": password}));
  if (response.statusCode == HttpStatus.created) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    var error = jsonDecode(response.body);
    throw Exception("${error["error"]} - ${error["message"]}");
  }
}
