import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/edit_target_user.dart';

import '../widgets/offered_courses.dart';

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
        actions: [
          (widget.userModel.role == "Admin")
              ? IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EditTargetUser(
                            userModel: widget.userModel,
                            firebaseUser: widget.firebaseUser,
                            targetUser: widget.targetUserModel,
                          );
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings),
                )
              : Container(),
        ],
      ),
      // extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
              alignment: Alignment.bottomLeft,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                color: Theme.of(context).canvasColor,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          (widget.targetUserModel.role == "Instructor")
                              ? Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 17),
                                    child: Center(
                                      child: Text(
                                        widget.targetUserModel.status!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).canvasColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                ),
                        ],
                      ),
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
                                color: Theme.of(context).errorColor,
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
                        ),
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Theme.of(context).canvasColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 17),
                            child: Row(
                              children: [
                                (widget.targetUserModel.role == "Student")
                                    ? const Text(
                                        "Student ID: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      )
                                    : const Text(
                                        "Designation: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                Text(
                                  widget.targetUserModel.idDesg!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Department: ${widget.targetUserModel.department}",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        (widget.targetUserModel.role == "Instructor")
                            ? Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      "Offered Courses:",
                                      style: TextStyle(
                                        color: Theme.of(context).errorColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  OfferedCourses(
                                    offeredCourseIds:
                                        widget.targetUserModel.courses ?? [],
                                  ),
                                ],
                              )
                            : Container(),
                        // (widget.userModel.role != "Student")
                        //     ? ((widget.targetUserModel.role == "Student"))
                        //         ? Column(
                        //             mainAxisSize: MainAxisSize.min,
                        //             children: [
                        //               ListTile(
                        //                 title: Text(
                        //                   "Enrolled Courses:",
                        //                   style: TextStyle(
                        //                     color: Theme.of(context).errorColor,
                        //                     fontSize: 20,
                        //                     fontWeight: FontWeight.w700,
                        //                   ),
                        //                 ),
                        //               ),
                        //               const Padding(
                        //                 padding: EdgeInsets.all(5.0),
                        //                 child: ListTile(
                        //                   isThreeLine: true,
                        //                   title: Text("Course 1"),
                        //                   subtitle: Text(
                        //                       "<Day><Time-Time>\n<Day><Time-Time>"),
                        //                   trailing: Text("<Venue>"),
                        //                 ),
                        //               ),
                        //               const Padding(
                        //                 padding: EdgeInsets.all(5.0),
                        //                 child: ListTile(
                        //                   isThreeLine: true,
                        //                   title: Text("Course 2"),
                        //                   subtitle: Text(
                        //                       "<Day><Time-Time>\n<Day><Time-Time>"),
                        //                   trailing: Text("<Venue>"),
                        //                 ),
                        //               ),
                        //               const Padding(
                        //                 padding: EdgeInsets.all(5.0),
                        //                 child: ListTile(
                        //                   isThreeLine: true,
                        //                   title: Text("Course 3"),
                        //                   subtitle: Text(
                        //                       "<Day><Time-Time>\n<Day><Time-Time>"),
                        //                   trailing: Text("<Venue>"),
                        //                 ),
                        //               ),
                        //               const Padding(
                        //                 padding: EdgeInsets.all(5.0),
                        //                 child: ListTile(
                        //                   isThreeLine: true,
                        //                   title: Text("Course 4"),
                        //                   subtitle: Text(
                        //                       "<Day><Time-Time>\n<Day><Time-Time>"),
                        //                   trailing: Text("<Venue>"),
                        //                 ),
                        //               ),
                        //               const Padding(
                        //                 padding: EdgeInsets.all(5.0),
                        //                 child: ListTile(
                        //                   isThreeLine: true,
                        //                   title: Text("Course 5"),
                        //                   subtitle: Text(
                        //                       "<Day><Time-Time>\n<Day><Time-Time>"),
                        //                   trailing: Text("<Venue>"),
                        //                 ),
                        //               )
                        //             ],
                        //           )
                        //         : Container()
                            // : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
