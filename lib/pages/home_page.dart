import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/announcement_page.dart';
import 'package:unimate/pages/chats_show_page.dart';
import 'package:unimate/pages/departments.dart';
import 'package:unimate/pages/instructor_list.dart';
import 'package:unimate/pages/login_page.dart';
import 'package:unimate/pages/reported_chats.dart';
import 'package:unimate/pages/search_page.dart';
import 'package:unimate/pages/signup_page.dart';
import 'package:unimate/pages/user_profile.dart';
import 'package:unimate/widgets/navbar.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const HomePage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.indigo[300],
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 200,
              width: 360,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: Colors.indigo[300],
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Unimate",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "(Signed in as \"${widget.userModel.role}\")",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return UserProfile(
                          userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser);
                    }),
                  ),
                  child: Container(
                    width: 80,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.indigo[300],
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          GridTile(
                            child: IconButton(
                              iconSize: 40,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return UserProfile(
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser);
                                  }),
                                );
                              },
                              icon: const Icon(
                                CupertinoIcons.person_fill,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Text(
                            "Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return ChatPage(
                          userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser);
                    }),
                  ),
                  child: Container(
                    width: 80,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.indigo[300],
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          GridTile(
                            child: IconButton(
                              iconSize: 40,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return ChatPage(
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser);
                                  }),
                                );
                              },
                              icon: const Icon(
                                CupertinoIcons.chat_bubble_2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Text(
                            "Chats",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return SearchPage(
                          userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser);
                    }),
                  ),
                  child: Container(
                    width: 80,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.indigo[300],
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          GridTile(
                            child: IconButton(
                              iconSize: 40,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return SearchPage(
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser);
                                  }),
                                );
                              },
                              icon: const Icon(
                                CupertinoIcons.search,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Text(
                            "Search",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return AnnouncementPage(
                          userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser);
                    }),
                  ),
                  child: Container(
                    width: 80,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.indigo[300],
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          GridTile(
                            child: IconButton(
                              iconSize: 40,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return AnnouncementPage(
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser);
                                  }),
                                );
                              },
                              icon: const Icon(
                                CupertinoIcons.speaker_3_fill,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const FittedBox(
                            child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                "Announcements",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  // onTap: () => Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) {
                  //     return ChatPage(
                  //         userModel: widget.userModel,
                  //         firebaseUser: widget.firebaseUser);
                  //   }),
                  // ),
                  child: Container(
                    width: 80,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.indigo[300],
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          GridTile(
                            child: IconButton(
                              iconSize: 40,
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) {
                                //     return ChatPage(
                                //         userModel: widget.userModel,
                                //         firebaseUser: widget.firebaseUser);
                                //   }),
                                // );
                              },
                              icon: const Icon(
                                CupertinoIcons.envelope,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Text(
                            "Email",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  // onTap: () => Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) {
                  //     return SearchPage(
                  //         userModel: widget.userModel,
                  //         firebaseUser: widget.firebaseUser);
                  //   }),
                  // ),
                  child: Container(
                    width: 80,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.indigo[300],
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          GridTile(
                            child: IconButton(
                              iconSize: 40,
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) {
                                //     return SearchPage(
                                //         userModel: widget.userModel,
                                //         firebaseUser: widget.firebaseUser);
                                //   }),
                                // );
                              },
                              icon: const Icon(
                                Icons.settings,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Text(
                            "Settings",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return DepartmemntsList(
                          userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser);
                    }),
                  ),
                  child: Container(
                    width: 80,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.indigo[300],
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          GridTile(
                            child: IconButton(
                              iconSize: 40,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return DepartmemntsList(
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser);
                                  }),
                                );
                              },
                              icon: const Icon(
                                Icons.school,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Text(
                            "Departments",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 13),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return InstructorList(
                          userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser);
                    }),
                  ),
                  child: Container(
                    width: 80,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.indigo[300],
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          GridTile(
                            child: IconButton(
                              iconSize: 40,
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return InstructorList(
                                      userModel: widget.userModel,
                                      firebaseUser: widget.firebaseUser);
                                }));
                              },
                              icon: const Icon(
                                Icons.person_pin,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Text(
                            "Instructors",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 13),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const LoginPage();
                      }),
                    );
                  },
                  child: Container(
                    width: 80,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.indigo[300],
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          GridTile(
                            child: IconButton(
                              iconSize: 40,
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return const LoginPage();
                                  }),
                                );
                              },
                              icon: const Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Text(
                            "Log out",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            (widget.userModel.role == "Admin")
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 80,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: Colors.indigo[300],
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              GridTile(
                                child: IconButton(
                                  iconSize: 40,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const SignupPage();
                                        },
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.person_add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return ReportedChatPage(
                                userModel: widget.userModel,
                                firebaseUser: widget.firebaseUser);
                          }),
                        ),
                        child: Container(
                          width: 80,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: Colors.indigo[300],
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                GridTile(
                                  child: IconButton(
                                    iconSize: 40,
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ReportedChatPage(
                                            userModel: widget.userModel,
                                            firebaseUser: widget.firebaseUser);
                                      }));
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.chat_bubble_text_fill,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const FittedBox(
                                  child: Text(
                                    "Reported\nChats",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 90,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.transparent,
                        ),
                      ),
                    ],
                  )
                : Container(
                    width: 80,
                    height: 90,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.transparent,
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        firebaseUser: widget.firebaseUser,
        userModel: widget.userModel,
        selectedPage: 3,
      ),
    );
  }
}
