import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/chats_show_page.dart';
import 'package:unimate/pages/login_page.dart';
import 'package:unimate/pages/user_profile.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const HomePage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.indigo[300],
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text("UNIMATE"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return const LoginPage();
                }),
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Welcome ${widget.userModel.fullName}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.pink[900],
          ),
        ),
      ),
      bottomNavigationBar: Container(
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return UserProfile(
                        userModel: widget.userModel,
                        firebaseUser: widget.firebaseUser);
                  }),
                );
              },
              icon: const Icon(
                CupertinoIcons.person_fill,
                color: Colors.white,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.app,
                color: Colors.white,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.house_fill,
                color: Colors.grey[900],
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.app,
                color: Colors.white,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ChatPage(
                      firebaseUser: widget.firebaseUser,
                      userModel: widget.userModel,
                    );
                  }),
                );
              },
              icon: const Icon(
                CupertinoIcons.chat_bubble_2_fill,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
