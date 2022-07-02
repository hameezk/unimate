import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/viewer_profile.dart';

class ShowDepartment extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final String department;
  const ShowDepartment(
      {Key? key,
      required this.department,
      required this.userModel,
      required this.firebaseUser})
      : super(key: key);

  @override
  _ShowDepartmentState createState() => _ShowDepartmentState();
}

class _ShowDepartmentState extends State<ShowDepartment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(widget.department),
      ),
      body: SafeArea(
        child: Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where("department", isEqualTo: widget.department)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                  if (dataSnapshot.docs.isNotEmpty) {
                    return ListView.builder(
                        itemCount: dataSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> userMap =
                              dataSnapshot.docs[index].data()
                                  as Map<String, dynamic>;
                          UserModel instructor = UserModel.fromMap(userMap);
                          if (dataSnapshot.docs.isNotEmpty) {
                            if (instructor.role != "Student") {
                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ViewProfile(
                                          userModel: widget.userModel,
                                          firebaseUser: widget.firebaseUser,
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
                                  foregroundImage:
                                      NetworkImage(instructor.profilePic!),
                                ),
                                title: Text(
                                  instructor.fullName!,
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  instructor.idDesg!,
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                trailing: Text(
                                  instructor.status!,
                                  style: TextStyle(
                                      color: Theme.of(context).errorColor,
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
                    return const Center(
                      child: Text(
                        "No results found!",
                        style: TextStyle(
                          color: Colors.blueGrey,
                        ),
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "An error occoured!",
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      "No results found!",
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                  );
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
