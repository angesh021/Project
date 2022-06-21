//PAKAGES
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';

//PAGES
import './pages/splash_page.dart';
import './pages/login_page.dart';
import './pages/home_page.dart';
import './pages/register_page.dart';

//SERVICES
import './services/navigation_service.dart';

//PROVIDERS
import './providers/authentication_provider.dart';

//Driver Code
// Will class the splash page first for few seconds then the login page
void main() {
  runApp(
    SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () {
        runApp(
          MainApp(),
        );
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (BuildContext context) {
            return AuthenticationProvider();
          },
        )
      ],
      child: MaterialApp(
        title: 'ChatME',
        theme: ThemeData(
          backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
          scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
          ),
        ),
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: '/login',
        routes: {
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
          '/home': (BuildContext context) => HomePage(),
        },
      ),
    );
  }
}
