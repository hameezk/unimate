import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unimate/main.dart';
import 'package:unimate/models/announcement_model.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/announcement_page.dart';

class AddAnnouncement extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const AddAnnouncement(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<AddAnnouncement> createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[300],
        title: const Text("Announcements"),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                child: TextField(
                  onTap: () {},
                  onChanged: (v) {},
                  onSubmitted: (v) {},
                  maxLines: 2,
                  minLines: 1,
                  controller: titleController,
                  textAlignVertical: TextAlignVertical.center,
                  // style: TextStyle(
                  //   color: Colors.indigo[300],
                  // ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 18),
                    labelText: 'Title',
                    labelStyle: TextStyle(
                      color: Colors.indigo[300],
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          const BorderSide(color: Colors.black38, width: 0.3),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: TextField(
                  onTap: () {},
                  onChanged: (v) {},
                  onSubmitted: (v) {},
                  minLines: 3,
                  maxLines: 20,
                  controller: contentController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 18),
                    labelText: 'Content',
                    labelStyle: TextStyle(
                      color: Colors.indigo[300],
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          const BorderSide(color: Colors.black38, width: 0.3),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  checkValues();
                },
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.indigo[300],
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void checkValues() {
    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.indigo[300],
          duration: const Duration(seconds: 1),
          content: const Text("Please fill all the fields!"),
        ),
      );
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    String title = titleController.text.trim();
    String content = contentController.text.trim();

    AnnouncementModel newAnnouncement = AnnouncementModel(
      announcementTitle: title,
      announcementContent: content,
      announcementId: uuid.v1(),
    );

    await FirebaseFirestore.instance
        .collection("announcements")
        .doc(newAnnouncement.announcementId)
        .set(newAnnouncement.toMap())
        .then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.indigo[300],
            duration: const Duration(seconds: 1),
            content: const Text("Announcement Updated"),
          ),
        );
       
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AnnouncementPage(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser);
            },
          ),
        );
      },
    );
  }
}
