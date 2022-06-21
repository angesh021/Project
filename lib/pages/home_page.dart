//PACKAGES
import 'package:flutter/material.dart';


//PAGES
import '../pages/chats_page.dart';
import '../pages/users_page.dart';


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int currentPage = 0;
  final List<Widget> pages = [
     //Show Chats Page when clicked by Index Item (currentPage)= 0
    ChatsPage(),
    //Show User Page when clicked by Index Item (currentPage)= 1
    UsersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
        //Index item = 0 to show icon Chats
        items: [
          BottomNavigationBarItem(
            label: "Chats",
            icon: Icon(
              Icons.chat_bubble_sharp,
            ),
          ),
          //Index item =1 to show icon Users
          BottomNavigationBarItem(
            label: "Users",
            icon: Icon(
              Icons.supervised_user_circle_sharp,
            ),
          ),
        ],
      ),
    );
  }
}
