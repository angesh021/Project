//Packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

//Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';

//Providers
import '../providers/authentication_provider.dart';

//Models
import '../models/chat_user.dart';
import '../models/chat.dart';

//Pages
import '../pages/chat_page.dart';

class UsersPageProvider extends ChangeNotifier {
  AuthenticationProvider auth;

  late DatabaseService database;
  late NavigationService navigation;

  List<ChatUser>? users;
  late List<ChatUser> _selectedUsers;

  List<ChatUser> get selectedUsers {
    return _selectedUsers;
  }

  UsersPageProvider(this.auth) {
    _selectedUsers = [];
    database = GetIt.instance.get<DatabaseService>();
    navigation = GetIt.instance.get<NavigationService>();
    getUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUsers({String? name}) async {
    _selectedUsers = [];
    try {
      database.getUsers(name: name).then(
        (snapshot) {
          users = snapshot.docs.map(
            (doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              data["uid"] = doc.id;
              return ChatUser.fromJSON(data);
            },
          ).toList();
          notifyListeners();
        },
      );
    } catch (e) {
      print("Error getting users.");
      print(e);
    }
  }

  void updateSelectedUsers(ChatUser user) {
    if (_selectedUsers.contains(user)) {
      _selectedUsers.remove(user);
    } else {
      _selectedUsers.add(user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      //Create Chat
      List<String> membersIds = _selectedUsers.map((user) => user.uid).toList();
      membersIds.add(auth.chatUser.uid);
      bool isGroup = _selectedUsers.length > 1;
      DocumentReference? doc = await database.createChat(
        {
          "is_group": isGroup,
          "is_activity": false,
          "members": membersIds,
        },
      );
      //Navigate To Chat Page
      List<ChatUser> members = [];
      for (var uid in membersIds) {
        DocumentSnapshot userSnapshot = await database.getUser(uid);
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        userData["uid"] = userSnapshot.id;
        members.add(
          ChatUser.fromJSON(
            userData,
          ),
        );
      }
      ChatPage chatPage = ChatPage(
        chat: Chat(
            uid: doc!.id,
            currentUserUid: auth.chatUser.uid,
            members: members,
            messages: [],
            activity: false,
            group: isGroup),
      );
      _selectedUsers = [];
      notifyListeners();
      navigation.navigateToPage(chatPage);
    } catch (e) {
      print("Error creating chat.");
      print(e);
    }
  }
}
