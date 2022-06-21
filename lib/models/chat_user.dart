import 'package:flutter/material.dart';

class ChatUser {
  final String uid;
  final String name;
  final String email;
  final String imageURL;
  late DateTime lastActive;

  ChatUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageURL,
    required this.lastActive,
  });

  factory ChatUser.fromJSON(Map<String, dynamic> json) {
    return ChatUser(
      uid: json["uid"],
      name: json["name"],
      email: json["email"],
      imageURL: json["imageURL"],
      lastActive: json["lastActive"].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "name": name,
      "lastActive": lastActive,
      "image": imageURL,
    };
  }

  String lastDayActive() {
    return "${lastActive.day}/${lastActive.month}/${lastActive.year}";
  }

  bool wasRecentlyActive() {
    return DateTime.now().difference(lastActive).inHours < 2;
  }
}
