import 'package:flutter_chat_screen/models/identity.dart';
import 'package:get_storage/get_storage.dart';

final box = GetStorage();

String getToken() {
  String token = box.read("token");
  return token;
}

Identity getIdentity() {
  var data = box.read("identity");
  Identity identity = identityFromJson(data);
  return identity;
}
