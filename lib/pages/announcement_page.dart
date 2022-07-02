import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unimate/models/announcement_model.dart';
import 'package:unimate/models/firebase_helper.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/add_announcement.dart';
import 'package:unimate/widgets/navbar.dart';

class AnnouncementPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const AnnouncementPage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: const Text("Announcements"),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("announcements")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot announcementSnapshot =
                    snapshot.data as QuerySnapshot;

                return ListView.builder(
                  itemCount: announcementSnapshot.docs.length,
                  itemBuilder: (context, index) {
                    AnnouncementModel announcementModel =
                        AnnouncementModel.fromMap(
                            announcementSnapshot.docs[index].data()
                                as Map<String, dynamic>);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${announcementModel.announcementTitle!}:',
                                style: TextStyle(
                                  color: Theme.of(context).errorColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                announcementModel.announcementContent!,
                                maxLines: 20,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return const Center(
                  child: Text("No Announcements"),
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
      floatingActionButton: (widget.userModel.role == 'Admin')
          ? FloatingActionButton(
              tooltip: 'Add Announcement',
              backgroundColor: Theme.of(context).canvasColor,
              child: const Icon(Icons.add,color: Colors.white54,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AddAnnouncement(
                        userModel: widget.userModel,
                        firebaseUser: widget.firebaseUser,
                      );
                    },
                  ),
                );
              },
            )
          : Container(
              height: 0,
            ),
      bottomNavigationBar: NavBar(
          userModel: widget.userModel,
          firebaseUser: widget.firebaseUser,
          selectedPage: 2),
    );
  }
}
