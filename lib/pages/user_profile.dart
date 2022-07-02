import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/chats_show_page.dart';
import 'package:unimate/pages/edit_profile.dart';
import 'package:unimate/pages/home_page.dart';
import 'package:unimate/widgets/navbar.dart';

class UserProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const UserProfile({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  List<String> roles = ["Available", "Busy", "In Class"];
  String? status;

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).canvasColor,
          ),
        ),
      );

  Future<void> updateStatus(String status) async {
    widget.userModel.status = status;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blueGrey,
            duration: Duration(seconds: 1),
            content: Text("Status Updated"),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    status = widget.userModel.status ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          actions: [
            (widget.userModel.role == "Admin")
                ? IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return EditProfile(
                                userModel: widget.userModel,
                                firebaseUser: widget.firebaseUser);
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings),
                  )
                : Container(),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                alignment: Alignment.bottomLeft,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
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
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 120,
                                      child: const CircularProgressIndicator(
                                        color: Colors.blueGrey,
                                      ),
                                      backgroundColor: Colors.transparent,
                                      foregroundImage: NetworkImage(widget
                                          .userModel.profilePic
                                          .toString()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextButton(
                                          child: const Text(
                                            "Change profile",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return EditProfile(
                                                      userModel:
                                                          widget.userModel,
                                                      firebaseUser:
                                                          widget.firebaseUser);
                                                },
                                              ),
                                            );
                                          }),
                                    )
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
                              widget.userModel.profilePic.toString()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            (widget.userModel.role == "Instructor")
                                ? Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 17),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            iconEnabledColor:
                                                Theme.of(context).canvasColor,
                                            // isExpanded: true,
                                            dropdownColor: Colors.white,
                                            hint: Text(
                                              "Status",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .canvasColor),
                                            ),
                                            value: status,
                                            items: roles
                                                .map(buildMenuItem)
                                                .toList(),
                                            onChanged: (value) => setState(
                                              () {
                                                status = value;
                                                updateStatus(status!);
                                              },
                                            ),
                                          ),
                                        )),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Text(
                            widget.userModel.fullName.toString(),
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).errorColor,
                            ),
                          ),
                          Row(children: [
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              widget.userModel.email.toString(),
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[700],
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
                        borderRadius: BorderRadius.circular(30),
                        color: Theme.of(context).canvasColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child: Row(
                          children: [
                            (widget.userModel.role == "Student")
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
                              widget.userModel.idDesg!,
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
                  ],
                ),
              ),
              (widget.userModel.role == "Instructor")
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
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
                        const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: ListTile(
                            isThreeLine: true,
                            title: Text("Course 1"),
                            subtitle:
                                Text("<Day><Time-Time>\n<Day><Time-Time>"),
                            trailing: Text("<Venue>"),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: ListTile(
                            isThreeLine: true,
                            title: Text("Course 2"),
                            subtitle:
                                Text("<Day><Time-Time>\n<Day><Time-Time>"),
                            trailing: Text("<Venue>"),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: ListTile(
                            isThreeLine: true,
                            title: Text("Course 3"),
                            subtitle:
                                Text("<Day><Time-Time>\n<Day><Time-Time>"),
                            trailing: Text("<Venue>"),
                          ),
                        )
                      ],
                    )
                  : Container(),
              ((widget.userModel.role == "Student"))
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(
                            "Enrolled Courses:",
                            style: TextStyle(
                              color: Theme.of(context).errorColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: ListTile(
                            isThreeLine: true,
                            title: Text("Course 1"),
                            subtitle:
                                Text("<Day><Time-Time>\n<Day><Time-Time>"),
                            trailing: Text("<Venue>"),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: ListTile(
                            isThreeLine: true,
                            title: Text("Course 2"),
                            subtitle:
                                Text("<Day><Time-Time>\n<Day><Time-Time>"),
                            trailing: Text("<Venue>"),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: ListTile(
                            isThreeLine: true,
                            title: Text("Course 3"),
                            subtitle:
                                Text("<Day><Time-Time>\n<Day><Time-Time>"),
                            trailing: Text("<Venue>"),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: ListTile(
                            isThreeLine: true,
                            title: Text("Course 4"),
                            subtitle:
                                Text("<Day><Time-Time>\n<Day><Time-Time>"),
                            trailing: Text("<Venue>"),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: ListTile(
                            isThreeLine: true,
                            title: Text("Course 5"),
                            subtitle:
                                Text("<Day><Time-Time>\n<Day><Time-Time>"),
                            trailing: Text("<Venue>"),
                          ),
                        )
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        bottomNavigationBar: NavBar(
          firebaseUser: widget.firebaseUser,
          userModel: widget.userModel,
          selectedPage: 1,
        ),
      ),
    );
  }
}
