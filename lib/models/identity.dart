import 'dart:convert';

Identity identityFromJson(String str) => Identity.fromJson(json.decode(str));

String identityToJson(Identity data) => json.encode(data.toJson());

class Identity {
  int id;
  String name;
  String email;

  Identity({
    required this.id,
    required this.name,
    required this.email,
  });

  factory Identity.fromJson(Map<String, dynamic> json) => Identity(
        id: json["id"],
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
      };
}
