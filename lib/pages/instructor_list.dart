import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/viewer_profile.dart';

class InstructorList extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const InstructorList(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _InstructorListState createState() => _InstructorListState();
}

class _InstructorListState extends State<InstructorList> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo[300],
          title: const Text("Instructors List"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  onChanged: (value) => setState(() {}),
                  controller: searchController,
                  decoration: const InputDecoration(
                    label: Text(
                      "Search Instructor",
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                    hintText: "Enter Name...",
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: (searchController.text == "")
                      ? FirebaseFirestore.instance
                          .collection("users")
                          .where("role", isEqualTo: "Instructor")
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection("users")
                          .where("email",
                              isGreaterThanOrEqualTo:
                                  searchController.text.trim())
                          .where("email", isNotEqualTo: widget.userModel.email)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;
                        if (dataSnapshot.docs.isNotEmpty) {
                          return ListView.builder(
                              itemCount: dataSnapshot.docs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> userMap =
                                    dataSnapshot.docs[index].data()
                                        as Map<String, dynamic>;
                                UserModel instructor =
                                    UserModel.fromMap(userMap);
                                if (instructor.email!.contains(
                                        searchController.text.trim()) ||
                                    searchController.text.isEmpty) {
                                  if (instructor.role == "Instructor") {
                                    return ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ViewProfile(
                                                userModel: widget.userModel,
                                                firebaseUser:
                                                    widget.firebaseUser,
                                                targetUserModel: instructor,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      leading: CircleAvatar(
                                        child: const CircularProgressIndicator(
                                          color: Colors.blueGrey,
                                        ),
                                        backgroundColor: Colors.transparent,
                                        foregroundImage: NetworkImage(
                                            instructor.profilePic!),
                                      ),
                                      title: Text(
                                        instructor.fullName!,
                                        style: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        instructor.department!,
                                        style: const TextStyle(
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      trailing: Text(
                                        instructor.status!,
                                        style: TextStyle(
                                            color: Colors.indigo[300],
                                            fontWeight: FontWeight.w700),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  return Container();
                                }
                              });
                        } else {
                          return const Text(
                            "No results found!",
                            style: TextStyle(
                              color: Colors.blueGrey,
                            ),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return const Text(
                          "An error occoured!",
                          style: TextStyle(
                            color: Colors.blueGrey,
                          ),
                        );
                      } else {
                        return const Text(
                          "No results found!",
                          style: TextStyle(
                            color: Colors.blueGrey,
                          ),
                        );
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
