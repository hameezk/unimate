import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/home_page.dart';

class ViewProfile extends StatefulWidget {
  final UserModel targetUserModel;
  final UserModel userModel;
  final User firebaseUser;
  const ViewProfile({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
    required this.targetUserModel,
  }) : super(key: key);

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
            alignment: Alignment.bottomLeft,
            height: 190,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.indigo[300],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
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
                            backgroundColor: Colors.white,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 120,
                                  child: const CircularProgressIndicator(
                                      color: Colors.blueAccent),
                                  backgroundColor: Colors.transparent,
                                  foregroundImage: NetworkImage(widget
                                      .targetUserModel.profilePic
                                      .toString()),
                                ),
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
                          widget.targetUserModel.profilePic.toString()),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                          Icons.home,
                          color: Colors.white,
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
                            widget.targetUserModel.fullName.toString(),
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
                          widget.targetUserModel.email.toString(),
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.blueGrey,
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
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.indigo[300],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
