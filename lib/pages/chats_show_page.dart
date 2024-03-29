import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unimate/models/chat_room_model.dart';
import 'package:unimate/models/firebase_helper.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/chat_room.dart';
import 'package:unimate/pages/home_page.dart';
import 'package:unimate/pages/search_page.dart';
import 'package:unimate/pages/user_profile.dart';
import 'package:unimate/pages/viewer_profile.dart';
import 'package:unimate/widgets/navbar.dart';

class ChatPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const ChatPage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: const Text("Chats"),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatrooms")
              .where("participants.${widget.userModel.uid}", isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;

                return ListView.builder(
                  itemCount: chatRoomSnapshot.docs.length,
                  itemBuilder: (context, index) {
                    ChatroomModel chatRoomModel = ChatroomModel.fromMap(
                        chatRoomSnapshot.docs[index].data()
                            as Map<String, dynamic>);

                    Map<String, dynamic> participants =
                        chatRoomModel.participants!;

                    List<String> participantKeys = participants.keys.toList();
                    participantKeys.remove(widget.userModel.uid);

                    return FutureBuilder(
                      future:
                          FirebaseHelper.getUserModelById(participantKeys[0]),
                      builder: (context, userData) {
                        if (userData.connectionState == ConnectionState.done) {
                          if (userData.data != null) {
                            UserModel targetUser = userData.data as UserModel;

                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return ChatRoom(
                                      chatRoom: chatRoomModel,
                                      firebaseUser: widget.firebaseUser,
                                      userModel: widget.userModel,
                                      targetUser: targetUser,
                                    );
                                  }),
                                );
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: const CircularProgressIndicator(),
                                foregroundImage: NetworkImage(
                                    targetUser.profilePic.toString()),
                              ),
                              title: Text(targetUser.fullName.toString()),
                              subtitle: (chatRoomModel.lastMessage.toString() !=
                                      "")
                                  ? Text(chatRoomModel.lastMessage.toString())
                                  : Text(
                                      "Say hi to your new friend!",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                              trailing: IconButton(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ViewProfile(
                                          userModel: widget.userModel,
                                          firebaseUser: widget.firebaseUser,
                                          targetUserModel: targetUser,
                                        );
                                      },
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.person,
                                  size: 40.0,
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return const Center(
                  child: Text("No Chats"),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).canvasColor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SearchPage(
                userModel: widget.userModel, firebaseUser: widget.firebaseUser);
          }));
        },
        child: const Icon(
          Icons.search,
          color: Colors.white54,
        ),
      ),
      bottomNavigationBar: NavBar(
        firebaseUser: widget.firebaseUser,
        userModel: widget.userModel,
        selectedPage: 5,
      ),
    );
  }
}
