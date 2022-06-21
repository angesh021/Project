import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

//SERVICES
import '../services/navigation_service.dart';

//WIDGETS
import '../widgets/custom_input_fields.dart';
import '../widgets/rounded_button.dart';

//PROVIDERS
import '../providers/authentication_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  //Define variable to be used in the late cycle of the app
  late double deviceHeight;
  late double deviceWidth;
  late AuthenticationProvider auth;
  late NavigationService navigation;

  final loginFormKey = GlobalKey<FormState>();


  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    navigation = GetIt.instance.get<NavigationService>();
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
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
            pageTitle(),
            SizedBox(
              height: deviceHeight * 0.04,
            ),
            loginForm(), //Calling the login form to display
            SizedBox(
              height: deviceHeight * 0.05,
            ),
            loginButton(),
            SizedBox(
              height: deviceHeight * 0.03,
            ),
            registerAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget pageTitle() {
    return Container(
      height: deviceHeight * 0.10,
      child: Text(
        'ChatME',
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget loginForm() {
    return Container(
      height: deviceHeight * 0.18,
      child: Form(
        key: loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                regEx: r".{8}",
                hintText: "Password",
                obscureText: true),
          ],
        ),
      ),
    );
  }

//Function that return a Button Rounded
  Widget loginButton() {
    return RoundedButton(
      name: "Login",
      height: deviceHeight * 0.065,
      width: deviceWidth * 0.65,
      onPressed: () {
        if (loginFormKey.currentState!.validate()) {
          loginFormKey.currentState!.save();
          auth.loginUsingEmailAndPassword(email!, password!);
        }
      },
    );
  }

  Widget registerAccountLink() {
    return GestureDetector(
      onTap: () => navigation.navigatorToRoute('/register'),
      child: Container(
        child: Text(
          'Don\'t have an account?',
          style: TextStyle(
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
