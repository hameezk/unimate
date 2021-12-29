import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/chats_show_page.dart';
import 'package:unimate/pages/edit_profile.dart';
import 'package:unimate/pages/home_page.dart';

class UserProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const UserProfile({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
              alignment: Alignment.bottomLeft,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                color: Colors.indigo[300],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              elevation: 1,
                              backgroundColor: Colors.orange[50],
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 120,
                                    child: const CircularProgressIndicator(
                                      color: Colors.blueGrey,
                                    ),
                                    backgroundColor: Colors.transparent,
                                    foregroundImage: NetworkImage(
                                        widget.userModel.profilePic.toString()),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                        child: const Text(
                                          "Change profile",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return EditProfile(
                                                    userModel: widget.userModel,
                                                    firebaseUser:
                                                        widget.firebaseUser);
                                              },
                                            ),
                                          );
                                        }),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: CircleAvatar(
                        radius: 35,
                        child: const CircularProgressIndicator(
                          color: Colors.blueGrey,
                        ),
                        backgroundColor: Colors.transparent,
                        foregroundImage: NetworkImage(
                            widget.userModel.profilePic.toString()),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return EditProfile(
                                      userModel: widget.userModel,
                                      firebaseUser: widget.firebaseUser);
                                },
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.settings,
                            color: Colors.orange[50],
                            size: 30,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.userModel.fullName.toString(),
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[300],
                              ),
                            ),
                          ],
                        ),
                        Row(children: [
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            widget.userModel.email.toString(),
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                            ),
                          ),
                        ]),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.indigo[300],
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.person_fill,
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
                    MaterialPageRoute(
                      builder: (context) {
                        return HomePage(
                            userModel: widget.userModel,
                            firebaseUser: widget.firebaseUser);
                      },
                    ),
                  );
                },
                icon: const Icon(
                  CupertinoIcons.house_fill,
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
      ),
    );
  }
}
