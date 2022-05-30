import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/announcement_page.dart';
import 'package:unimate/pages/chats_show_page.dart';
import 'package:unimate/pages/home_page.dart';
import 'package:unimate/pages/user_profile.dart';

class NavBar extends StatefulWidget {
  final int selectedPage;
  final UserModel userModel;
  final User firebaseUser;
  const NavBar(
      {Key? key,
      required this.userModel,
      required this.firebaseUser,
      required this.selectedPage})
      : super(key: key);
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.indigo[300],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              (widget.selectedPage != 1)
                  ? Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return UserProfile(
                              userModel: widget.userModel,
                              firebaseUser: widget.firebaseUser);
                        },
                      ),
                    )
                  : null;
            },
            icon: Icon(
              CupertinoIcons.person_fill,
              color:
                  (widget.selectedPage == 1) ? Colors.grey[900] : Colors.white,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              (widget.selectedPage != 2)
                  ? Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return AnnouncementPage(
                            userModel: widget.userModel,
                            firebaseUser: widget.firebaseUser);
                      }),
                    )
                  : null;
            },
            icon: Icon(
              CupertinoIcons.speaker_3,
              color:
                  (widget.selectedPage == 2) ? Colors.grey[900] : Colors.white,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              (widget.selectedPage != 3)
                  ? Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomePage(
                              userModel: widget.userModel,
                              firebaseUser: widget.firebaseUser);
                        },
                      ),
                    )
                  : null;
            },
            icon: Icon(
              CupertinoIcons.house_fill,
              color:
                  (widget.selectedPage == 3) ? Colors.grey[900] : Colors.white,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              (widget.selectedPage != 4) ? null : null;
            },
            icon: Icon(
              CupertinoIcons.settings,
              color:
                  (widget.selectedPage == 4) ? Colors.grey[900] : Colors.white,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              (widget.selectedPage != 5)
                  ? Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ChatPage(
                          firebaseUser: widget.firebaseUser,
                          userModel: widget.userModel,
                        );
                      }),
                    )
                  : null;
            },
            icon: Icon(
              CupertinoIcons.chat_bubble_2_fill,
              color:
                  (widget.selectedPage == 5) ? Colors.grey[900] : Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
