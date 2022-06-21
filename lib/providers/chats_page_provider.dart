//PAKAGES
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

//SERVICES
import '../services/database_service.dart';

//PROVIDERS
import '../providers/authentication_provider.dart';

//MODELS
import '../models/chat_user.dart';
import '../models/chat_message.dart';
import '../models/chat.dart';

class ChatsPageProvider extends ChangeNotifier {
  AuthenticationProvider auth;
  late DatabaseService db;
  List<Chat>? chats;
  late StreamSubscription chatStream;

  ChatsPageProvider(this.auth) {
    db = GetIt.instance.get<DatabaseService>();
    getChats();
  }

  @override
  void dispose() {
    chatStream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      chatStream = db.getChatsForUser(auth.chatUser.uid).listen(
        (snapshot) async {
          chats = await Future.wait(
            snapshot.docs.map(
              (d) async {
                Map<String, dynamic> chatData =
                    d.data() as Map<String, dynamic>;
                //Get User in chat
                List<ChatUser> members = [];
                for (var uid in chatData["members"]) {
                  DocumentSnapshot userSnapshot = await db.getUser(uid);
                  Map<String, dynamic> userData =
                      userSnapshot.data() as Map<String, dynamic>;
                  userData["uid"] = userSnapshot.id;
                  members.add(
                    ChatUser.fromJSON(userData),
                  );
                }
                //Get Last Message from chat
                List<ChatMessage> messages = [];
                QuerySnapshot chatMessage =
                    await db.getLastMessageForChat(d.id);
                if (chatMessage.docs.isNotEmpty) {
                  Map<String, dynamic> messageData =
                      chatMessage.docs.first.data()! as Map<String, dynamic>;
                  ChatMessage message = ChatMessage.fromJSON(messageData);
                  messages.add(message);
                }
                //return chat instances
                return Chat(
                  uid: d.id,
                  currentUserUid: auth.chatUser.uid,
                  activity: chatData["is_activity"],
                  group: chatData["is_group"],
                  members: members,
                  messages: messages,
                );
              },
            ).toList(),
          );
          notifyListeners();
        },
      );
    } catch (e) {
      print("Error getting chats.");
      print(e);
    }
  }
}
