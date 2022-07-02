import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unimate/models/chat_room_model.dart';
import 'package:unimate/models/message_model.dart';
import 'package:unimate/models/report_model.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/viewer_profile.dart';

import '../main.dart';

class ReportedChatroom extends StatefulWidget {
  final UserModel reportedUser;
  final UserModel user;
  final String chatRoomId;
  final UserModel userModel;
  final User firebaseUser;

  const ReportedChatroom({
    Key? key,
    required this.chatRoomId,
    required this.userModel,
    required this.firebaseUser,
    required this.reportedUser,
    required this.user,
  }) : super(key: key);

  @override
  _ReportedChatroomState createState() => _ReportedChatroomState();
}

class _ReportedChatroomState extends State<ReportedChatroom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 105,
              color: Theme.of(context).canvasColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          child: const CircularProgressIndicator(
                            color: Colors.blueGrey,
                          ),
                          backgroundColor: Colors.transparent,
                          foregroundImage:
                              NetworkImage(widget.user.profilePic.toString()),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.user.fullName.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          child: const CircularProgressIndicator(
                            color: Colors.blueGrey,
                          ),
                          backgroundColor: Colors.transparent,
                          foregroundImage: NetworkImage(
                              widget.reportedUser.profilePic.toString()),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.reportedUser.fullName.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatRoomId)
                    .collection("messages")
                    .orderBy("createdOn", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        reverse: true,
                        itemBuilder: (context, index) {
                          MessageModel currentMessage = MessageModel.fromMap(
                              dataSnapshot.docs[index].data()
                                  as Map<String, dynamic>);

                          return (currentMessage.sender == widget.user.uid)
                              //  FOR LOGGED IN USER
                              ? ListTile(
                                  trailing: CircleAvatar(
                                    child: const CircularProgressIndicator(
                                      color: Colors.blueGrey,
                                    ),
                                    backgroundColor: Colors.transparent,
                                    foregroundImage: NetworkImage(
                                        widget.user.profilePic.toString()),
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.blueGrey,
                                        ),
                                        child:
                                            Text(currentMessage.text.toString(),
                                                maxLines: 20,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                )),
                                      ),
                                    ],
                                  ),
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                  ),
                                )
                              //  FOR TARGET USER
                              : ListTile(
                                  leading: CircleAvatar(
                                    child: const CircularProgressIndicator(
                                      color: Colors.blueGrey,
                                    ),
                                    backgroundColor: Colors.transparent,
                                    foregroundImage: NetworkImage(widget
                                        .reportedUser.profilePic
                                        .toString()),
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Theme.of(context).canvasColor,
                                        ),
                                        child:
                                            Text(currentMessage.text.toString(),
                                                maxLines: 20,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                )),
                                      ),
                                    ],
                                  ),
                                  trailing: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                  ),
                                );
                        },
                        itemCount: dataSnapshot.docs.length,
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                            "An error occoured! Please check your internet connection "),
                      );
                    } else {
                      return const Center(
                        child: Text("No messages to display"),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
