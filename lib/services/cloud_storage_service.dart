import 'dart:io';

//PAKAGES
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

const String USER_COLLECTION = "Users";

class CloudStorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  CloudStorageService() {}


// In order to save the image in firebase database, we need to change the rule.
// Go to Firebase console -> Storage -> Rules 
// And change the following line 'allow read, write: if false;' to 'allow read, write: if true;'
  Future<String?> saveUserImageToStorage(String uid, PlatformFile file) async {
    try {
      Reference reference =
          storage.ref().child('images/users/$uid/profile.${file.extension}');
      UploadTask task = reference.putFile(
        File(file.path),
      );
      return await task.then(
        (result) => result.ref.getDownloadURL(),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<String?> saveChatImageToStorage(
      String chatID, String userID, PlatformFile file) async {
    try {
      Reference reference = storage.ref().child(
          'images/chats/$chatID/${userID}_${Timestamp.now().millisecondsSinceEpoch}.${file.extension}');
      UploadTask task = reference.putFile(
        File(file.path),
      );
      return await task.then(
        (result) => result.ref.getDownloadURL(),
      );
    } catch (e) {
      print(e);
    }
  }
}
