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

  const CreateEmail(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo[300],
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
                        controller: searchController,
                      ),
                    ),
                    InkWell(
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
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        Container(
                          width: size.width * 0.25,
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
                                ? Colors.indigo[300]
                                : Colors.black38,
                            child: const FittedBox(
                              child: Text(
                                'Attendance',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.25,
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                _selectedSubject = 1;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: _selectedSubject == 1
                                ? Colors.indigo[300]
                                : Colors.black38,
                            child: const FittedBox(
                              child: Text(
                                'Marks Distribution',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.25,
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                _selectedSubject = 2;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: _selectedSubject == 2
                                ? Colors.indigo[300]
                                : Colors.black38,
                            child: const FittedBox(
                              child: Text(
                                'Inquiry',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.25,
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                _selectedSubject = 3;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: _selectedSubject == 3
                                ? Colors.indigo[300]
                                : Colors.black38,
                            child: const FittedBox(
                              child: Text(
                                'Other',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    (_selectedSubject == 3)
                        ? Container(
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              // color: _selectedSubject == 3
                              //     ? Colors.indigo[300]
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
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 10,
                    style: const TextStyle(color: Colors.black),
                    controller: contentController,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () => checkValues(),
        child: Container(
          height: 60,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.indigo[300],
          ),
          child: const Center(
              child: Text(
            "Submit",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )),
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
    String subject =
        (_selectedSubject == 3) ? subjectController.text.trim() : '';
    String content = contentController.text.trim();

    EmailModel newEmail = EmailModel(
      emailId: uuid.v1(),
      sender: widget.userModel.uid,
      recipant: recipantId,
      text: subject,
      subject: _selectedSubject,
      seen: false,
      createdon: Timestamp.fromDate(DateTime.now()),
    );

    await FirebaseFirestore.instance
        .collection("email")
        .doc(newEmail.emailId)
        .set(newEmail.toMap())
        .then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.indigo[300],
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
