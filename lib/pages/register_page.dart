import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

//SERVICES
import '../services/media_service.dart';
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/navigation_service.dart';

//WIDGETS
import '../widgets/custom_input_fields.dart';
import '../widgets/rounded_button.dart';
import '../widgets/rounded_image.dart';

//PROVIDERS
import '../providers/authentication_provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  late double deviceHeight;
  late double deviceWidth;
  final registerFormkey = GlobalKey<FormState>();

  late AuthenticationProvider auth;
  late DatabaseService db;
  late CloudStorageService cloudStorage;
  late NavigationService navigation;

  String? email;
  String? password;
  String? name;
  PlatformFile? profileImage;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    db = GetIt.instance.get<DatabaseService>();
    cloudStorage = GetIt.instance.get<CloudStorageService>();
    navigation = GetIt.instance.get<NavigationService>();
    return builUI();
  }

  Widget builUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.03,
          vertical: deviceHeight * 0.02,
        ),
        height: deviceHeight * 0.98,
        width: deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profileImageField(),
            SizedBox(
              height: deviceHeight * 0.05,
            ),
            registerForm(),
            SizedBox(
              height: deviceHeight * 0.05,
            ),
            registerButton(),
            SizedBox(
              height: deviceHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  Widget profileImageField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then(
          (file) {
            setState(
              () {
                profileImage = file;
              },
            );
          },
        );
      },
      child: () {
        if (profileImage != null) {
          return RoundedImageFile(
            key: UniqueKey(),
            image: profileImage!,
            size: deviceHeight * 0.15,
          );
        } else {
          return RoundedImageNetwork(
            key: UniqueKey(),
            imagePath: "https://icon-library.com/images/photo-album-icon-png/photo-album-icon-png-24.jpg",
            size: deviceHeight * 0.15,
          );
        }
      }(),
    );
  }

  Widget registerForm() {
    return Container(
      height: deviceHeight * 0.35,
      child: Form(
        key: registerFormkey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
                onSaved: (value) {
                  setState(() {
                    name = value;
                  });
                },
                regEx: r'.{8,}',
                hintText: "Name",
                obscureText: false),
            CustomTextFormField(
                onSaved: (value) {
                  setState(() {
                    email = value;
                  });
                },
                regEx:
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                hintText: "Email",
                obscureText: false),
            CustomTextFormField(
                onSaved: (value) {
                  setState(() {
                    password = value;
                  });
                },
                regEx: r'.{8,}',
                hintText: "Password",
                obscureText: true),
          ],
        ),
      ),
    );
  }

  Widget registerButton() {
    return RoundedButton(
      name: "Register",
      height: deviceHeight * 0.065,
      width: deviceWidth * 0.65,
      onPressed: () async {
        if (registerFormkey.currentState!.validate() && profileImage != null) {
          //Proceed with registering a user
          registerFormkey.currentState!.save();
          String? uid =
              await auth.registerUserUsingemailAndPassword(email!, password!);
          String? imageURL =
              await cloudStorage.saveUserImageToStorage(uid!, profileImage!);

// In order to save the image in firebase database, we need to change the rule.
// Go to Firebase console -> Storage -> Rules
// And change the following line 'allow read, write: if false;' to 'allow read, write: if true;'
          await db.createUser(uid, email!, name!, imageURL!);
          await auth.logout();
          await auth.loginUsingEmailAndPassword(email!, password!);
          navigation.goBack();
        }
      },
    );
  }
}
