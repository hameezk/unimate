import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unimate/models/chat_room_model.dart';
import 'package:unimate/models/firebase_helper.dart';
import 'package:unimate/models/report_model.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/chat_room.dart';
import 'package:unimate/pages/home_page.dart';
import 'package:unimate/pages/reported_chatroom.dart';
import 'package:unimate/pages/search_page.dart';
import 'package:unimate/pages/user_profile.dart';
import 'package:unimate/pages/viewer_profile.dart';
import 'package:unimate/widgets/navbar.dart';

class ReportedChatPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const ReportedChatPage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _ReportedChatPageState createState() => _ReportedChatPageState();
}

class _ReportedChatPageState extends State<ReportedChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: const Text("Reported Chats"),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("reportedChats")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;

                return ListView.builder(
                  itemCount: chatRoomSnapshot.docs.length,
                  itemBuilder: (context, index) {
                    ReportModel reportModel = ReportModel.fromMap(
                        chatRoomSnapshot.docs[index].data()
                            as Map<String, dynamic>);

                    return FutureBuilder(
                      future: getUserModel(
                        reportModel.currentUserId!,
                        reportModel.reportedUserId!,
                      ),
                      builder: (context, userData) {
                        if (userData.connectionState == ConnectionState.done) {
                          if (userData.data != null) {
                            List<UserModel?> userModels =
                                userData.data as List<UserModel?>;
                            UserModel reportedUSer = userModels[0]!;
                            UserModel user = userModels[1]!;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return ReportedChatroom(
                                              firebaseUser: widget.firebaseUser,
                                              userModel: widget.userModel,
                                              chatRoomId:
                                                  reportModel.chatroomId!,
                                              reportedUser: reportedUSer,
                                              user: user,
                                            );
                                          }),
                                        );
                                      },
                                      leading: CircleAvatar(
                                        child:
                                            const CircularProgressIndicator(),
                                        foregroundImage: NetworkImage(
                                            user.profilePic.toString()),
                                      ),
                                      title: Text(user.fullName.toString()),
                                      trailing: IconButton(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return ViewProfile(
                                                  userModel: widget.userModel,
                                                  firebaseUser:
                                                      widget.firebaseUser,
                                                  targetUserModel: user,
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
                                    ),
                                    const Divider(
                                      height: 0,
                                      thickness: 2,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return ReportedChatroom(
                                              firebaseUser: widget.firebaseUser,
                                              userModel: widget.userModel,
                                              chatRoomId:
                                                  reportModel.chatroomId!,
                                              reportedUser: reportedUSer,
                                              user: user,
                                            );
                                          }),
                                        );
                                      },
                                      leading: CircleAvatar(
                                        child:
                                            const CircularProgressIndicator(),
                                        foregroundImage: NetworkImage(
                                            reportedUSer.profilePic.toString()),
                                      ),
                                      title: Text(
                                          reportedUSer.fullName.toString()),
                                      trailing: IconButton(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return ViewProfile(
                                                  userModel: widget.userModel,
                                                  firebaseUser:
                                                      widget.firebaseUser,
                                                  targetUserModel: reportedUSer,
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
                                    ),
                                  ],
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
        child: const Icon(Icons.search),
      ),
      // bottomNavigationBar: NavBar(
      //   firebaseUser: widget.firebaseUser,
      //   userModel: widget.userModel,
      //   selectedPage: 5,
      // ),
    );
  }

  Future<List<UserModel?>> getUserModel(
      String currentUserId, String reportedUserId) async {
    List<UserModel?> userModels = [];
    userModels.add(await FirebaseHelper.getUserModelById(currentUserId));
    userModels.add(await FirebaseHelper.getUserModelById(reportedUserId));
    return userModels;
  }
}
