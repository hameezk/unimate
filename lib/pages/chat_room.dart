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

class ChatRoom extends StatefulWidget {
  final UserModel targetUser;
  final ChatroomModel chatRoom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoom(
      {Key? key,
      required this.targetUser,
      required this.chatRoom,
      required this.userModel,
      required this.firebaseUser})
      : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg != "") {
      MessageModel newMessage = MessageModel(
        messageId: uuid.v1(),
        sender: widget.userModel.uid,
        createdon: Timestamp.now(),
        text: msg,
        seen: false,
      );

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomId)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());

      widget.chatRoom.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomId)
          .set(widget.chatRoom.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).canvasColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              child: const CircularProgressIndicator(
                color: Colors.blueGrey,
              ),
              backgroundColor: Colors.transparent,
              foregroundImage:
                  NetworkImage(widget.targetUser.profilePic.toString()),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              widget.targetUser.fullName.toString(),
              style: const TextStyle(fontSize: 18),
              maxLines: 2,
            )
          ],
        ),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: const [
                    Icon(
                      Icons.person,
                      size: 30.0,
                      color: Colors.blueGrey,
                    ),
                    SizedBox(
                      // sized box with width 10
                      width: 10,
                    ),
                    Text(
                      "View Profile",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: const [
                    Icon(
                      CupertinoIcons.exclamationmark_shield,
                      size: 30.0,
                      color: Colors.blueGrey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Report Chat",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            offset: const Offset(0, 40),
            color: Colors.grey[100],
            elevation: 2,
            onSelected: (value) {
              if (value == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ViewProfile(
                        userModel: widget.userModel,
                        firebaseUser: widget.firebaseUser,
                        targetUserModel: widget.targetUser,
                      );
                    },
                  ),
                );
              } else if (value == 2) {
                _showReportDialog(
                  context,
                  widget.targetUser.uid!,
                  widget.userModel.uid!,
                  widget.chatRoom.chatroomId!,
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatRoom.chatroomId)
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

                          return (currentMessage.sender == widget.userModel.uid)
                              //  FOR LOGGED IN USER
                              ? ListTile(
                                  trailing: CircleAvatar(
                                    child: const CircularProgressIndicator(
                                      color: Colors.blueGrey,
                                    ),
                                    backgroundColor: Colors.transparent,
                                    foregroundImage: NetworkImage(
                                        widget.userModel.profilePic.toString()),
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
                                        .targetUser.profilePic
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
                      return Center(
                        child: Text("Say Hi to ${widget.targetUser.fullName}"),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: messageController,
                      maxLines: null,
                      style: const TextStyle(color: Colors.blueGrey),
                      decoration: const InputDecoration(
                        hintText: "Enter Message...",
                        hintStyle: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.blueGrey,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _showReportDialog(
    BuildContext context,
    String reportedUserId,
    String currentUserId,
    String chatroomId,
  ) {
    List<dynamic> reportReasons = [
      'Report Reason 1',
      'Report Reason 2',
    ];
    int? _reportReason = -1;
    TextEditingController _reasonController = TextEditingController();
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        _reasonController.text = "";
        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Text(
            "Report User",
            style: TextStyle(
              color: Theme.of(context).indicatorColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: (size.height * 0.05 * (reportReasons.length)),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: reportReasons.length,
                    itemBuilder: (context, index) {
                      String reason = reportReasons[index];
                      return SizedBox(
                        height: size.height * 0.05,
                        child: RadioListTile(
                          activeColor: Theme.of(context).canvasColor,
                          selectedTileColor: Theme.of(context).canvasColor,
                          groupValue: _reportReason,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                            reason,
                          ),
                          value: index + 1,
                          onChanged: (value) {
                            setState(() {
                              _reportReason = value as int?;
                            });
                          },
                        ),
                      );
                    }),
              ),

              SizedBox(
                height: size.height * 0.05,
                child: RadioListTile(
                  activeColor: Theme.of(context).canvasColor,
                  selectedTileColor: Theme.of(context).canvasColor,
                  groupValue: _reportReason,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text("Other"),
                  // value: reportReasons.length + 1,
                  value: 3,
                  onChanged: (value) {
                    setState(() {
                      _reportReason = value! as int?;
                    });
                  },
                ),
              ),
              // (_reportReason == reportReasons.length + 1)
              (_reportReason == 3)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: _reasonController,
                          minLines: 1,
                          maxLines: 3,
                          cursorColor: Theme.of(context).canvasColor,
                        ),
                      ),
                    )
                  : Container(
                      height: 0,
                    ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Theme.of(context).canvasColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (_reportReason == 1 ||
                    _reportReason == 2 ||
                    _reportReason == 3) {
                  if (_reportReason == 3 && _reasonController.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text('Please spacify a reason'),
                      ),
                    );
                  } else {
                    await _reportUser(reportedUserId, currentUserId, chatroomId,
                        _reportReason!, reportReasons, _reasonController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text('Chat Reported'),
                      ),
                    );

                    Navigator.pop(context);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text('Please select a reason'),
                    ),
                  );
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Text(
                    "Report",
                    style: TextStyle(
                      color: Theme.of(context).canvasColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.02,
            ),
          ],
        );
      }),
    );
  }

  _reportUser(
    String reportedUserId,
    String currentUserId,
    String chatroomId,
    int reasonIndex,
    List reportReasons,
    String reportText,
  ) async {
    ReportModel reportModel = ReportModel()
      ..reportId = uuid.v1()
      ..chatroomId = chatroomId
      ..reportedUserId = reportedUserId
      ..currentUserId = currentUserId
      ..reasonIndex = reasonIndex - 1
      ..reportReasons = reportReasons
      ..reportText = reportText;

    await FirebaseFirestore.instance
        .collection("reportedChats")
        .doc(reportModel.reportId)
        .set(reportModel.toMap())
        .then(
      (value) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     backgroundColor: Theme.of(context).canvasColor,
        //     duration: const Duration(seconds: 1),
        //     content: const Text("Announcement Updated"),
        //   ),
        // );
      },
    );
  }
}
