import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unimate/models/email_model.dart';
import 'package:unimate/models/user_model.dart';
import 'package:unimate/pages/viewer_profile.dart';

import '../main.dart';

class CreateEmail extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final bool isReply;
  final EmailModel? parentEmail;
  final String? parentEmailId;
  const CreateEmail({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
    required this.isReply,
    this.parentEmail,
    this.parentEmailId,
  }) : super(key: key);

  @override
  State<CreateEmail> createState() => _CreateEmailState();
}

class _CreateEmailState extends State<CreateEmail> {
  TextEditingController searchController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  String? recipantId;
  int _selectedSubject = -1;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _selectedSubject = (widget.isReply) ? widget.parentEmail!.subject! : -1;
    if (widget.isReply) {
      searchController.text = widget.parentEmailId!;
    }
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: const Text("Create Email"),
      ),
      body: Column(
        children: [
          SizedBox(
            width: size.width,
            height: 80,
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                child: Row(
                  children: [
                    const Text('To:   '),
                    Expanded(
                      child: TextField(
                        enabled: !widget.isReply,
                        controller: searchController,
                      ),
                    ),
                    (widget.isReply)
                        ? Container(
                            height: 0,
                          )
                        : InkWell(
                            child: const Icon(
                              Icons.search_rounded,
                            ),
                            onTap: () {
                              _showSearch(context, size);
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.width,
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: const [
                        Text('Subject:   '),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: EmailModel.subjects.length,
                        itemBuilder: (context, index) {
                          return buildSubjectTile(size, index);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            width: 5,
                          );
                        },
                      ),
                    ),
                    (_selectedSubject == 3)
                        ? Container(
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              // color: _selectedSubject == 3
                              //     ? Theme.of(context).canvasColor
                              //     : Colors.black38,
                            ),
                            child: SizedBox(
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 5,
                                style: const TextStyle(color: Colors.black),
                                controller: subjectController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: const BorderSide(
                                        color: Colors.black38, width: 0.3),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: const BorderSide(
                                        color: Colors.black38, width: 0.3),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 0,
                          ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            child: SizedBox(
              width: size.width,
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Content: ',
                      fillColor: Colors.white70,
                      filled: false,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            const BorderSide(color: Colors.black38, width: 0.3),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 10,
                    // style: const TextStyle(color: Colors.black),
                    controller: contentController,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 60),
        child: GestureDetector(
          onTap: () => checkValues(),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).canvasColor,
            ),
            child: const Center(
                child: Text(
              "Submit",
              style: TextStyle(color: Colors.white, fontSize: 18),
            )),
          ),
        ),
      ),
    );
  }

  Widget buildSubjectTile(size, index) {
    return SizedBox(
      // width: size.width * 0.25,
      child: FlatButton(
        onPressed: () {
          setState(() {
            _selectedSubject = 0;
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: _selectedSubject == 0
            ? Theme.of(context).canvasColor
            : Colors.black38,
        child: FittedBox(
          child: Text(
            EmailModel.subjects[index],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  void _showSearch(BuildContext context, Size size) {
    showDialog(
      context: context,
      builder: (context) {
        return Card(
          child: StatefulBuilder(builder: (context, setSearchState) {
            return SingleChildScrollView(
              child: SizedBox(
                height: size.height * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListTile(
                        title: TextField(
                          onChanged: (value) => setSearchState(() {}),
                          controller: searchController,
                          decoration: const InputDecoration(
                            label: Text(
                              "Email Address",
                              style: TextStyle(
                                color: Colors.blueGrey,
                              ),
                            ),
                            hintText: "Enter Email...",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    (searchController.text.trim() != "")
                        ? StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .where("email",
                                    isGreaterThanOrEqualTo:
                                        searchController.text.trim())
                                .where("email",
                                    isNotEqualTo: widget.userModel.email)
                                // .where('role', isEqualTo: 'Student')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                if (snapshot.hasData) {
                                  QuerySnapshot dataSnapshot =
                                      snapshot.data as QuerySnapshot;

                                  if (dataSnapshot.docs.isNotEmpty) {
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: dataSnapshot.docs.length,
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> userMap =
                                              dataSnapshot.docs[index].data()
                                                  as Map<String, dynamic>;

                                          UserModel searchedUser =
                                              UserModel.fromMap(userMap);
                                          if (searchedUser.email!.contains(
                                              searchController.text.trim())) {
                                            if (searchedUser.role !=
                                                'Student') {
                                              return ListTile(
                                                onTap: () async {
                                                  setState(() {
                                                    recipantId =
                                                        searchedUser.uid;
                                                    searchController.text =
                                                        searchedUser.email!;
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                leading: CircleAvatar(
                                                  child:
                                                      const CircularProgressIndicator(
                                                    color: Colors.blueGrey,
                                                  ),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  foregroundImage: NetworkImage(
                                                      searchedUser.profilePic!),
                                                ),
                                                title: Text(
                                                  searchedUser.fullName!,
                                                  style: const TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  searchedUser.email!,
                                                  style: const TextStyle(
                                                    color: Colors.blueGrey,
                                                  ),
                                                ),
                                                trailing: IconButton(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return ViewProfile(
                                                            userModel: widget
                                                                .userModel,
                                                            firebaseUser: widget
                                                                .firebaseUser,
                                                            targetUserModel:
                                                                searchedUser,
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
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          )
                        : const Text(
                            "No results found!",
                            style: TextStyle(
                              color: Colors.blueGrey,
                            ),
                          ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  void checkValues() {
    if (searchController.text.isEmpty ||
        contentController.text.isEmpty ||
        _selectedSubject < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).canvasColor,
          duration: const Duration(seconds: 1),
          content: const Text("Please fill all the fields!"),
        ),
      );
    } else {
      if (_selectedSubject == 3 && subjectController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).canvasColor,
            duration: const Duration(seconds: 1),
            content: const Text("Please fill all the fields!"),
          ),
        );
      } else {
        uploadData();
      }
    }
  }

  void uploadData() async {
    String subject =
        (_selectedSubject == 3) ? subjectController.text.trim() : '';
    String content = contentController.text.trim();

    EmailModel newEmail = EmailModel(
      otherSubject: subject,
      emailId: uuid.v1(),
      sender: widget.userModel.uid,
      recipant: (widget.isReply) ? widget.parentEmail!.sender : recipantId,
      text: content,
      subject: _selectedSubject,
      seen: false,
      createdon: Timestamp.fromDate(DateTime.now()),
      isReply: widget.isReply,
      parentId: (widget.parentEmail != null) ? widget.parentEmail!.emailId : '',
    );

    await FirebaseFirestore.instance
        .collection("email")
        .doc(newEmail.emailId)
        .set(newEmail.toMap())
        .then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).canvasColor,
            duration: const Duration(seconds: 1),
            content: const Text("Email Updated"),
          ),
        );
        Navigator.pop(context);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) {
        //       return AnnouncementPage(
        //           userModel: widget.userModel,
        //           firebaseUser: widget.firebaseUser);
        //     },
        //   ),
        // );
      },
    );
  }
}
