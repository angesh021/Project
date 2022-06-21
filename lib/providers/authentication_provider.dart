//PACKAGES
import 'package:chatme_app/models/chat_user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

//SERVICES
import '../services/database_service.dart';
import '../services/navigation_service.dart';

//MODELS
import '../models/chat_user.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth auth;
  late final NavigationService navigationService;
  late final DatabaseService databaseService;

  late ChatUser chatUser;

//Constructor
  AuthenticationProvider() {
    auth = FirebaseAuth.instance;
    navigationService = GetIt.instance.get<NavigationService>();
    databaseService = GetIt.instance.get<DatabaseService>();

    //auth.signOut(); // Sign out a user from SSO

    //Check if user is logged in to update time stamp for last seen
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        databaseService.updateUserLastSeenTime(user.uid);
        databaseService.getUser(user.uid).then(
          (snapshot) {
            if (snapshot.data() != null) {
              Map<String, dynamic> userData =
                  snapshot.data()! as Map<String, dynamic>;
              chatUser = ChatUser.fromJSON(
                {
                  "uid": user.uid,
                  "name": userData["name"],
                  "email": userData["email"],
                  "lastActive": userData["lastActive"],
                  "imageURL": userData["imageURL"],
                },
              );
              navigationService.removeAndNavigateToRoute('/home');
            }
          },
        );
      } else {
        navigationService.removeAndNavigateToRoute('/login');
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      print("Error logging user in Firebase");
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUserUsingemailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user!.uid;
    } on FirebaseAuthException {
      print("Error registration user.");
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
