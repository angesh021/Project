//PAKAGES
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'dart:async';

//SERVICES
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/media_service.dart';
import '../services/navigation_service.dart';

//PROVIDERS
import '../providers/authentication_provider.dart';

//MODELS
import '../models/chat_user.dart';
import '../models/chat_message.dart';
import '../models/chat.dart';

class ChatPageProvider extends ChangeNotifier {
  AuthenticationProvider auth;
  late DatabaseService db;
  late MediaService media;
  late NavigationService navigation;
  late CloudStorageService storage;

  ScrollController messageListViewController;

  String chatID;
  List<ChatMessage>? messages;
  late StreamSubscription messagesStream;
  late StreamSubscription keyboardVisibilityStream;
  late KeyboardVisibilityController keyboardVisibilityController;
  String? _message;

  String get message {
    return message;
  }

  void set message(String value) {
    _message = value;
  }

  ChatPageProvider(this.chatID, this.auth, this.messageListViewController) {
    db = GetIt.instance.get<DatabaseService>();
    navigation = GetIt.instance.get<NavigationService>();
    storage = GetIt.instance.get<CloudStorageService>();
    media = GetIt.instance.get<MediaService>();
    keyboardVisibilityController = KeyboardVisibilityController();
    listenToMessages();
    listenToKeyboardChanges();
  }

  @override
  void dispose() {
    messagesStream.cancel();
    super.dispose();
  }

  void listenToMessages() {
    try {
      messagesStream = db.streamMessagesForChat(chatID).listen(
        (snapshot) {
          List<ChatMessage> _messages = snapshot.docs.map(
            (m) {
              Map<String, dynamic> messageData =
                  m.data() as Map<String, dynamic>;
              return ChatMessage.fromJSON(messageData);
            },
          ).toList();
          messages = _messages;
          notifyListeners();
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              if (messageListViewController.hasClients) {
                messageListViewController
                    .jumpTo(messageListViewController.position.maxScrollExtent);
              }
            },
          );
        },
      );
    } catch (e) {
      print("Error getting messages.");
      print(e);
    }
  }

  void listenToKeyboardChanges() {
    keyboardVisibilityStream =
        keyboardVisibilityController.onChange.listen((event) {
      db.updateChat(chatID, {"is_activity": event});
    });
  }

  void sendTextMessage() {
    if (_message != null) {
      ChatMessage messageToSend = ChatMessage(
        content: _message!,
        senderID: auth.chatUser.uid,
        type: MessageType.TEXT,
        sentTime: DateTime.now(),
      );
      db.addMessageToChat(chatID, messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? file = await media.pickImageFromLibrary();
      if (file != null) {
        String? downloadURL = await storage.saveChatImageToStorage(
            chatID, auth.chatUser.uid, file);
        ChatMessage messageToSend = ChatMessage(
          content: downloadURL!,
          senderID: auth.chatUser.uid,
          type: MessageType.IMAGE,
          sentTime: DateTime.now(),
        );
        db.addMessageToChat(chatID, messageToSend);
      }
    } catch (e) {
      print("Error sending image message.");
      print(e);
    }
  }

  void deleteChat() {
    goBack();
    db.deleteChat(chatID);
  }

  void goBack() {
    navigation.goBack();
  }
}
